class Parser
  constructor: (sel, node) ->
    @node = node
    @sel = sel
    @offset = sel.extentOffset
    @matches = /^#{1,6}\s/i.exec(node.textContent)

  valid: =>
    @matches? || (@node? && @node.parentElement instanceof HTMLHeadingElement)

  parse: =>
    dom = @update()
    if dom?
      range = document.createRange()
      range.setStart(dom.childNodes[0], @offset)
      range.collapse(true)
      @sel.removeAllRanges()
      @sel.addRange(range)

  update: =>
    unless @matches?
      header = @node.parentElement
      div = "<div>".toHTML()
      div.innerText = header.innerText
      header.parentElement.replaceChild(div, header)
      return div

    hSize = @matches[0].length - 1
    return if @node.parentElement.nodeName == "H#{hSize}"

    if !(@node.parentElement instanceof HTMLHeadingElement)
      header = "<h#{hSize}>".toHTML()
      header.innerText = @node.textContent
      @node.parentElement.replaceChild(header, @node)
      return header
    else
      header = "<h#{hSize}>".toHTML()
      header.innerText = @node.textContent
      @node.parentElement.parentElement.replaceChild(header, @node.parentElement)
      return header


Content.Parsers.Header = Parser
