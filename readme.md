# leanconf
[![npm version][npm-image]][npm-url]
[![Build Status][travis-image]][travis-url]

Configuration without brackets, quotes or escaping, using just 2 markup characters:

* the key/value separator `:`
* the comment character `#`

Indented whitespace controls nesting and primitive [data types] are [inferred](#value-parser).

## example

    # shop.conf
    name: dizzib's corner shop: Leeds, Yorkshire

    patrons:
      alice:
        cash: 5.03
      bob:
        credit: 10.00

    fruits          # omit key/val separator to parse immediate children to an array
      apples
        Braeburn
        Cox's       # omit key/val separator to parse as a value
        Royal Gala
      banana
      orange:
        special: true
        stock: 17

[node.js] code:

```javascript
var conf = require('fs').readFileSync('shop.conf'});
var obj = require('leanconf').parse(conf);
console.log(require('util').inspect(obj, {depth:null}));
```

output:

```javascript
{ name: 'dizzib\'s corner shop: Leeds, Yorkshire',
  patrons: { alice: { cash: 5.03 }, bob: { credit: 10 } },
  fruits:
   [ { apples: [ 'Braeburn', 'Cox\'s', 'Royal Gala' ] },
     'banana',
     { orange: { special: true, stock: 17 } } ] }
```

## methods

```javascript
var leanconf = require('leanconf');
```

### var obj = leanconf.parse(conf, opts)

Parse configuration string `conf` returning object `obj`.

Set `opts.asArray` to return top-level items in an array (default is `false`).

Set `opts.comment` to change the comment character (default is `#`).
Keys or values cannot contain this character.
Set `opts.sep` to change the key/value separator (default is `:`).

### <a name="value-parser"></a> var val = leanconf.value-parser(raw)

This function parses a raw value-string to the most appropriate [data type] of
boolean, floating-point number, integer, null or string.
Don't call this directly, rather replace or wrap it if you want to alter
the default behaviour.

## install

    $ npm install leanconf

## developer build and run

    $ git clone --branch=dev https://github.com/dizzib/leanconf.git
    $ cd leanconf
    $ npm install     # install dependencies
    $ npm test        # build all and run tests
    $ npm start       # start the task runner

## license

[MIT](./LICENSE)

[data type]: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Data_structures
[data types]: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Data_structures
[node.js]: http://nodejs.org
[npm]: https://npmjs.org
[npm-image]: https://img.shields.io/npm/v/leanconf.svg
[npm-url]: https://npmjs.org/package/leanconf
[travis-image]: https://travis-ci.org/dizzib/leanconf.svg?branch=master
[travis-url]: https://travis-ci.org/dizzib/leanconf
