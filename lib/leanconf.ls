module.exports = me =
  parse: (conf, opts) ->
    conf = conf.toString! if conf instanceof Buffer
    throw new Error 'conf must be a string or buffer' unless typeof conf is \string
    opts = (defaults = asArray:false comment:\#) with opts
    parse 1, conf / '\n', opts <<< rx:comment:new RegExp "^([^#{opts.comment}]*)"
  value-parser: (raw) ->
    return null unless (str = raw.trim!).length
    return true if str is \true
    return false if str is \false
    return parseInt str, 10 if /^[-\+]?\d+$/.test str
    return parseFloat str if /^[-\+]?\d+\.\d+$/.test str
    str

function parse offset, lines, opts
  return void unless lines.length
  i = -1; res = if opts.asArray then [] else {}

  function append v, k
    if opts.asArray and k then return res.push "#k":v
    if opts.asArray then return if v? then res.push v
    if k then return res[k] = v else return unless v?
    if typeof res is \string then err \string v else res := v
  function get-indent line then /^(\s*)/.exec line .0.length
  function strip-comment line then opts.rx.comment.exec line .0
  function err what, x then throw new Error "Unexpected #what at line #{i + offset}:'#x'"

  while ++i < lines.length
    err \indent li unless 0 is get-indent li = strip-comment lines[i]
    is-sep = (sepidx = li.indexOf \:) > -1
    is-subconf = get-indent lines[1 + i]
    k = (if is-sep then li.substr 0 sepidx else if is-subconf then li else '').trim!
    err 'empty key' '' if is-sep and not (k = if k.length then k else void)
    vraw = if is-sep then li.substr 1 + sepidx else if is-subconf then '' else li
    v = me.valueParser vraw
    unless is-subconf then append v, k else
      sublines = []; suboffset = offset + i + 1
      while i++ < lines.length and get-indent li = lines[i]
        err \outdent li if li.substr 0 (subind ?= get-indent li) .trim!length
        sublines.push li.substr subind
      append (parse suboffset, sublines, opts with asArray:not is-sep), k
      i--
  res
