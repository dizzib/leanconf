Assert = require \assert
Shell  = require \shelljs/global
W4     = require \wait.for .for
Args   = require \./args
Dir    = require \./constants .dir

module.exports =
  prepare: ->
    if test \-e pjson = "#{Dir.BUILD}/package.json"
      cp \-f pjson, Dir.ROOT
      cp \-f pjson, Dir.build.LIB
    cp \-f "#{Dir.ROOT}/readme.md" Dir.build.LIB

  publish-local: ->
    pushd Dir.build.LIB
    try
      port = Args.reggie-server-port
      W4 exec, "reggie -u http://localhost:#port publish" silent:false
    finally
      popd!

  publish-public: ->
    pushd Dir.build.LIB
    try
      W4 exec, 'npm publish' silent:false
    finally
      popd!
