Assert = require \assert
Shell  = require \shelljs/global

const DIRNAME =
  BUILD: \_build
  LIB  : \lib
  TASK : \task
  TEST : \test

root = pwd!

dir =
  BUILD: "#root/#{DIRNAME.BUILD}"
  build:
    LIB : "#root/#{DIRNAME.BUILD}/#{DIRNAME.LIB}"
    TASK: "#root/#{DIRNAME.BUILD}/#{DIRNAME.TASK}"
    TEST: "#root/#{DIRNAME.BUILD}/#{DIRNAME.TEST}"
  ROOT : root
  LIB  : "#root/#{DIRNAME.LIB}"
  TASK : "#root/#{DIRNAME.TASK}"
  TEST : "#root/#{DIRNAME.TEST}"

module.exports =
  APPNAME: \lm-parse
  dirname: DIRNAME
  dir    : dir

Assert test \-e dir.LIB
Assert test \-e dir.TASK
Assert test \-e dir.TEST
