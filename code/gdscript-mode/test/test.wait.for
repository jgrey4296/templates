# -*- mode: snippet -*-
# name  : test.wait.for
# uuid  : test.wait.for
# key   : test.wait.for
# group : gut await condition
# --
await wait_until(${1:callable}, ${2:10}, "Waiting until $1 returns true")$0