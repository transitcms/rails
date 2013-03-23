$ = @Transit.$

class @Transit.Editor extends Spine.Controller
  document: null
  win: null
  $: null
  
  constructor: ->
    super
    @setup()
    
  setup:=>
    @$el = $('#transit_frame')
    @$el.one 'load', ()=>
      @document = @$el.contents()
      @win = @$el.get(0).contentWindow
      @win.Transit = Transit
      @win.$ = $ unless @win.$
      @$ = @win.$
      @setupFrame()
      
      @$.event.trigger('transit:ready')
      Transit.trigger('ready')

  setupFrame:()=>
    for node in $('a, form', @document)
      if node.target == '' || node.target == '_self'
        $(node).attr('target', '_parent')