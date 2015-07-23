name       : \leanconf
version    : \0.2.0
description: "Configuration without the brackets, quotes or escaping, using just 2 markup characters"
keywords   : <[ clean config configuration indent indented js lean nodejs pojo pure simple whitespace ]>
homepage   : \https://github.com/dizzib/leanconf
bugs       : \https://github.com/dizzib/leanconf/issues
license:   : \MIT
author     : \dizzib
main       : \./leanconf.js
repository :
  type: \git
  url : \https://github.com/dizzib/leanconf
scripts:
  start: './task/bootstrap && node ./_build/task/repl'
  test : './task/bootstrap && node ./_build/task/npm-test'
devDependencies:
  chai       : \~3.0.0
  chalk      : \~0.4.0
  chokidar   : \~1.0.1
  commander  : \~2.6.0
  gntp       : \~0.1.1
  istanbul   : \~0.3.13
  livescript : \~1.4.0
  lodash     : \~3.5.0
  mocha      : \~2.2.5
  shelljs    : \~0.3.0
  'wait.for' : \~0.6.3
engines:
  node: '>=0.10.x'
  npm : '>=1.0.x'
