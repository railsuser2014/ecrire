class @Content
  @Parsers: {}

  loaded: =>
    @on 'keyup', @parse
    @observer = new MutationObserver (mutations) =>
      @mutated(mutation) for mutation in mutations
    config = { attributes: true, attributeFilter: ['style'], subtree: true, characterData: true }
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
    header = new Content.Parsers.Header(sel, node)
    if header.valid()
      header.parse()

  mutated: (mutation) =>
    el = mutation.target
    console.log(mutation)
    if el? && el.nodeType == 1
      spans = el.querySelectorAll('span[style]')
      for span in spans
        span.parentElement.replaceChild(span.childNodes[0], span)


  clearEmptyDom: (e) =>
    sel = window.getSelection()
    node = sel.extentNode
    if !(node instanceof HTMLDivElement) && node.textContent.length == 0
      sel.extentNode.remove()


Ethereal.Models.add Content, 'Posts.Editor.Content'
