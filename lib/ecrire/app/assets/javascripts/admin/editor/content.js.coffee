class Content
  header: /^#{1,6}\s/i
  loaded: =>
    @on 'keyup', @parse
    @observer = new MutationObserver (mutations) =>
      @mutated(mutation) for mutation in mutations
    config = { attributes: true, childList: true, characterData: true }
    @observer.observe(@element(), config)

  # ContentEditable is the opposite of predictive and consistent.
  # this is why I need to parse this the current line that is edited
  parse: (e) =>
    return if e.which == 16
    if e.which == 8
      @clearEmptyDom(e)
      return
    else if e.which == 14
      return
    el = e.target
    sel = window.getSelection()
    node = sel.extentNode
    if (regexp = @header.exec(node.textContent))? || node.parentElement instanceof HTMLHeadingElement
      offset = sel.extentOffset
      dom = @parser.header(sel, regexp, e)
      if dom?
        range = document.createRange()
        range.setStart(dom.childNodes[0], offset)
        range.collapse(true)
        sel.removeAllRanges()
        sel.addRange(range)

  mutated: (mutation) =>
    el = mutation.previousSibling
    if el? && el.nodeType == 1
      spans = el.querySelectorAll('span[style]')
      for span in spans
        el.replaceChild(span.childNodes[0], span)


  clearEmptyDom: (e) =>
    sel = window.getSelection()
    node = sel.extentNode
    if !(node instanceof HTMLDivElement) && node.textContent.length == 0
      sel.extentNode.remove()

  parser:
    header: (sel, rx, e) =>
      node = sel.extentNode

      unless rx?
        header = node.parentElement
        div = "<div>".toHTML()
        div.innerText = header.innerText
        header.parentElement.replaceChild(div, header)
        return div

      hSize = rx[0].length - 1
      return if node.parentElement.nodeName == "H#{hSize}"

      if !(node.parentElement instanceof HTMLHeadingElement)
        header = "<h#{hSize}>".toHTML()
        header.innerText = node.textContent
        node.parentElement.replaceChild(header, node)
        return header
      else
        header = "<h#{hSize}>".toHTML()
        header.innerText = node.textContent
        node.parentElement.parentElement.replaceChild(header, node.parentElement)
        return header



Ethereal.Models.add Content, 'Posts.Editor.Content'
