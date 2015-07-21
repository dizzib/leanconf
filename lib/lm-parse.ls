module.exports = (conf, opts) ->
  throw new Error 'conf must be a string' unless typeof conf is \string
  const DEFAULT-OPTS = as-array:false comment:\#
  parse 0, conf / '\n', DEFAULT-OPTS with opts

function parse offset, lines, opts
  return void unless lines.length
  res = if opts.as-array then [] else {}
  i = 0

  function append v, k
    if opts.as-array
      return res.push "#k":v if k?length
      res.push v if v?length
    else
      return res[k] = v if k?length
      return unless v?length
      err \string v if typeof res is \string
      res := v
  function get-indent line then /^(\s*)/.exec line .0.length
  function strip-comment line then /^([^#]*)/.exec line .0
  function err what, x then throw new Error "Unexpected #what at line #{1 + i + offset}: #x"

  while i < lines.length
    err \indent li unless 0 is get-indent li = strip-comment lines[i]
    is-sep = (sepidx = li.indexOf \:) > -1
    is-subconf = get-indent lines[1 + i]
    k = (if is-sep then li.substr 0 sepidx else if is-subconf then li else '').trim!
    v = (if is-sep then li.substr 1 + sepidx else if is-subconf then '' else li).trim!
    #console.log "k='#k' sepidx=#sepidx v='#v'"
    if v.length
      append v, k
      i++
      continue
    sublines = []
    suboffset = offset + ++i
    while i < lines.length and get-indent li = lines[i]
      err \outdent li if li.substr 0 (subind ?= get-indent li) .trim!length
      sublines.push li.substr subind
      i++
    append (parse suboffset, sublines, opts with as-array:not is-sep), k
  res
