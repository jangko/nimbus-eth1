import
  std/monotimes,
  stew/byteutils,
  ../execution_chain/evm/types,
  ../execution_chain/evm/precompiles {.all.}

const maxIter = 100

template run(impl: untyped, input: string) =
  let c = Computation(
    msg: Message()
  )
  let start = getMonoTime()
  for _ in 0..<maxIter:
    for line in lines("tests/" & input):
      c.msg.data = hexToSeqByte(line)
      let res = impl(c)
  let stop = getMonoTime()
  echo "TIME: ", stop.ticks-start.ticks

run(modExp, "modexp.txt")
# 67827400
# 72129600