class @Transit.Editor extends Spine.Controller
  frame: null
  doc: null
  url: null
  
  constructor: ->
    super
    @frame ||= $('#transit_frame')
    @frame.one 'load', ()=>
      @doc = @frame.contents()
      @logger.info("Managing resource at #{url}")
    @iframe.attr('src', "#{url}#{split}transit_managed=true")  
    @frame.attr('src', editor_url(@url))


editor_url = (base)->
  parseUrl = (url)->
    link = document.createElement('a')
    link.href = url
    link
  data = parseUrl(url)
    
  split = if data.search is "" then "?" else "&"
  url   = "/#{url}" unless url.match(/^\//)
  return "#{url}#{split}transit_managed=true"