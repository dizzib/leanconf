# leanconf
[![Build Status](https://travis-ci.org/dizzib/leanconf.svg?branch=master)](https://travis-ci.org/dizzib/leanconf)

Specify configuration using just 2 markup characters:

* the key/value separator `:`
* the comment character `#`

Indented whitespace controls nesting and values are parsed to strings.

# example

    # shop.conf
    name: dizzib's corner shop

    patrons:
      alice:
        cash: 5.00
      bob:
        credit: 10.00

    fruits          # omit key/val separator to parse immediate children to an array
      apples
        Braeburn
        Cox's       # omit key/val separator to parse childless to a string
        Royal Gala
      banana
      orange:
        price: 0.10

[node.js] code:

```javascript
var conf = require('fs').readFileSync('shop.conf', {encoding:'utf8'});
var obj = require('leanconf').parse(conf);
console.log(require('util').inspect(obj, {depth:null}));
```

output:

```javascript
{ name: 'dizzib\'s corner shop',
  patrons: { alice: { cash: '5.00' }, bob: { credit: '10.00' } },
  fruits:
   [ { apples: [ 'Braeburn', 'Cox\'s', 'Royal Gala' ] },
     'banana',
     { orange: { price: '0.10' } } ] }
```

# methods

```javascript
var leanconf = require('leanconf');
```

## var obj = leanconf.parse(conf, opts)

Parse configuration string `conf` returning object `obj`.

Set `opts.asArray` to return top-level items in an array (default is `false`).

Set `opts.comment` to change the comment character (default is `#`).

# install

    $ npm install leanconf

# developer build and run

    $ git clone --branch=dev https://github.com/dizzib/leanconf.git
    $ cd leanconf
    $ npm install     # install dependencies
    $ npm test        # build all and run tests
    $ npm start       # start the task runner

# license

[MIT](./LICENSE)

[node.js]: http://nodejs.org
[npm]: https://npmjs.org
