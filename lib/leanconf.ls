module.exports = me =
  parse: (conf, opts) ->
    conf = conf.toString! if conf instanceof Buffer
    throw new Error 'conf must be a string or buffer' unless typeof conf is \string
    opts = (defaults = asArray:false comment:\# sep:\:) with opts
    parse 1, conf / '\n', opts <<< rx:comment:new RegExp "^([^#{opts.comment}]*)"
  value-parser: (raw) ->
    return null unless (str = raw.trim!).length
    return true if str is \true
    return false if str is \false
    return parseInt str, 10 if /^[-\+]?\d+$/.test str
    return parseFloat str if /^[-\+]?\d+\.\d+$/.test str
    str

function parse offset, lines, opts
  i = -1; res = if opts.asArray then [] else {}
  sep = opts.sep; seplen = sep.length

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
    if is-followed-by-nested-subconf = get-indent lines[1 + i]
      is-sep = (li .= trim!).slice(-seplen) is sep
      k = if is-sep then li.slice 0, -seplen else li
      err 'empty key' li if not (k = if k.length then k else void)
      sublines = []; suboffset = offset + i + 1
      while i++ < lines.length and get-indent li = lines[i]
        err \outdent li if li.substr 0 (subind ?= get-indent li) .trim!length
        sublines.push li.slice subind
      append (parse suboffset, sublines, opts with asArray:not is-sep), k
      i--
    else # k:v or v
      is-sep = (sepidx = li.indexOf sep) > -1
      k = if is-sep then li.slice(0 sepidx).trim! else ''
      err 'empty key' li if is-sep and not (k = if k.length then k else void)
      append (me.valueParser if is-sep then li.slice seplen + sepidx else li), k
  res
