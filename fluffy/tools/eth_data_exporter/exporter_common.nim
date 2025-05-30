# Nimbus
# Copyright (c) 2023-2025 Status Research & Development GmbH
# Licensed and distributed under either of
#   * MIT license (license terms in the root directory or at https://opensource.org/licenses/MIT).
#   * Apache v2 license (license terms in the root directory or at https://www.apache.org/licenses/LICENSE-2.0).
# at your option. This file may not be copied, modified, or distributed except according to those terms.

{.push raises: [].}

import
  std/[strutils, os],
  chronicles,
  stew/io2,
  faststreams,
  json_serialization,
  json_serialization/std/tables,
  ../../eth_data/history_data_json_store,
  ../../eth_data/yaml_utils

export history_data_json_store

proc writePortalContentToJson*(
    fh: OutputStreamHandle, content: JsonPortalContentTable
) =
  try:
    var writer = JsonWriter[DefaultFlavor].init(fh.s, pretty = true)
    writer.writeValue(content)
  except IOError as e:
    fatal "Error occured while writing to file", error = e.msg
    quit 1

proc writeDataToYaml*[T](data: T, file: string) =
  let res = data.dumpToYaml(file)
  if res.isErr():
    error "Failed writing content to file", file, error = res.error
    quit QuitFailure
  else:
    notice "Successfully wrote content to file", file

proc writePortalContentToYaml*(file: string, contentKey: string, contentValue: string) =
  let yamlPortalContent =
    YamlPortalContent(content_key: contentKey, content_value: contentValue)
  yamlPortalContent.writeDataToYaml(file)

proc createAndOpenFile*(dataDir: string, fileName: string): OutputStreamHandle =
  # Creates directory and file, if file already exists
  # program is aborted with info to user, to avoid losing data
  let fileName: string =
    if not fileName.endsWith(".json"):
      fileName & ".json"
    else:
      fileName

  let filePath = dataDir / fileName

  if isFile(filePath):
    fatal "File under provided path already exists and would be overwritten",
      path = filePath
    quit 1

  let res = createPath(dataDir)
  if res.isErr():
    fatal "Error occurred while creating directory", error = ioErrorMsg(res.error)
    quit 1

  try:
    return fileOutput(filePath)
  except IOError as e:
    fatal "Error occurred while opening the file", error = e.msg
    quit 1

proc existsFile*(dataDir: string, fileName: string) =
  let filePath = dataDir / fileName

  if isFile(filePath):
    fatal "File under provided path already exists and would be overwritten",
      path = filePath
    quit 1
