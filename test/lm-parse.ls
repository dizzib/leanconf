A = require \chai .assert
T = require \../lib/lm-parse

const ARRAY = as-array:true
deq = A.deepEqual

test = it
function run conf, expect, opts then deq (T conf, opts), expect

describe 'error' ->
  function run conf, expect, opts then A.throws (-> T conf, opts), expect
  test 'not string'  -> run 123 'conf must be a string'
  test 'bad indent'  -> run ' a:b' 'Unexpected indent at line 1:  a:b'
  test 'bad outdent' -> run 'a\n  b\n c' 'Unexpected outdent at line 3:  c'
  test 'bad string'  -> run 'a:\n b\n c' 'Unexpected string at line 3: c'

describe 'empty' ->
  test 'hash 1'  -> run '' {}
  test 'hash 2'  -> run '\n\n' {}
  test 'array 1' -> run '' [] ARRAY
  test 'array 2' -> run '\n\n' [] ARRAY

describe 'flat' ->
  test 'single' -> run 'foo' 'foo'
  test 'hash'   -> run 'a:b\nc:d e f' a:'b' c:'d e f'
  test 'array'  -> run 's0\ns1, s1a\ns2  s2a ' ['s0' 's1, s1a' 's2  s2a'] ARRAY

describe 'nested' ->
  test 'hash 1'  -> run 'a:\n b:c\n d:e' a:{b:\c d:\e}
  test 'hash 2'  -> run 'a:\n b:\n  c:d\n e:f\ng:h' a:{b:{c:\d} e:\f} g:\h
  test 'array 1' -> run 'a\n b\n c' a:<[b c]>
  test 'array 2' -> run 'a\n b:c\n d:e' a:[{b:\c} {d:\e}]
  test 'mixed 1' -> run 'a:\n b:c\n d\n  e\n  f' a:{b:\c d:<[e f]>}
  test 'mixed 2' -> run 'a\nb:c\nd\ne\n f\n g:h' [\a {b:\c} \d e:[\f g:\h]] ARRAY
  test 'string'  -> run 'a:\n b' a:\b

describe 'comments' ->
  test '#' -> run '# a comment\nfoo # bar baz\n#foo#bar' 'foo'
  test ';' -> run '; a comment\nfoo ; bar baz\n;foo;bar' 'foo' comment:\;

describe 'real world' ->
  test 'xawt' -> run '# conf\n/(.*)/:\n  in: echo $1\n' '/(.*)/': in:'echo $1'
  test 'markfound' -> run 'names\n  *.md\n  *.markdown' names:<[ *.md *.markdown ]>
