A = require \chai .assert
T = require \../lib/leanconf .parse

const ARRAY = as-array:true
deq = A.deepEqual

test = it
function run conf, expect, opts then deq (T conf, opts), expect

describe 'comments' ->
  test '#' -> run '# a comment\nfoo # bar baz\n#foo#bar' 'foo'
  test ';' -> run '; a comment\nfoo ; bar baz\n;foo;bar' 'foo' comment:\;

describe 'empty' ->
  test '{} 1' -> run '' {}
  test '{} 2' -> run '\n\n' {}
  test '[] 1' -> run '' [] ARRAY
  test '[] 2' -> run '\n\n' [] ARRAY

describe 'error' ->
  function run conf, expect, opts then A.throws (-> T conf, opts), expect
  test 'bad type'    -> run 123 'conf must be a string or buffer'
  test 'bad indent'  -> run ' a:b' "Unexpected indent at line 1:' a:b'"
  test 'bad outdent' -> run 'a\n  b\n c' "Unexpected outdent at line 3:' c'"
  test 'bad string'  -> run 'a:\n b\n c' "Unexpected string at line 3:'c'"
  test 'void key'    -> run ':foo' "Unexpected empty key at line 1:':foo'"

describe 'flat' ->
  test 'string' -> run 'foo' 'foo'
  test 'buffer' -> run (new Buffer 'foo'), 'foo'
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

describe 'separator' ->
  test 'in key 1' -> run 'a:b\n c' 'a:b':[\c]
  test 'in key 2' -> run 'a:b:\n c' 'a:b':\c
  test 'in value' -> run 'a:b:c:d' a:'b:c:d'

describe 'type inference' ->
  test 'bool'   -> run 'true\nfalse' [true false] ARRAY
  test 'float'  -> run '0.123\n5432.1' [0.123 5432.1] ARRAY
  test 'int'    -> run '1\n54321' [1 54321] ARRAY
  test 'null'   -> run 'a:\nb : ' a:null b:null
  test 'string' -> run '\nTrue\nFalse\nnot true\n1 2\n.3\n4.' [\True \False 'not true' '1 2' \.3 \4.] ARRAY

describe 'real world' ->
  test 'xawt'      -> run '# conf\n/(\\w+):foo/:\n  in: echo $1\n' '/(\\w+):foo/': in:'echo $1'
  test 'markfound' -> run 'names\n  *.md\n  *.markdown' names:<[ *.md *.markdown ]>
  test 'shop.conf' -> deq T(require \fs .readFileSync "#__dirname/shop.conf"), do
    name: "dizzib's corner shop: Leeds, Yorkshire"
    patrons:
      alice:
        cash: 5.03
      bob:
        credit: -10.00
    fruits:
      apples: ['Braeburn' "Cox's" 'Royal Gala']
      'banana'
      orange:
        special: true
        stock: 17
