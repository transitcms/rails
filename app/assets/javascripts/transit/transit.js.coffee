#= require spine
#= require bootstrap
#= require_self

#= require transit/support/utils
#= require transit/editor
#= require transit/model
#= require transit/context
#= require transit/deliverable
#= require transit/manager
#= require transit/toolbar

Spine   = @Spine or require('spine')
$       = Spine.$
Transit = null


###---------------------------------------
  Class
---------------------------------------### 

class Transit extends Spine.Module
  @include Spine.Events
  VERSION: "0.4.0"
  options: 
    branding: 
      label: "transit"
      icon: "truck"
    managers:
      'Transit.PropertyManager':
        url: null
      'Transit.AssetManager':
        url: "/transit/assets"

  debug: true
  editor: null
  toolbar: null
  
  $: Spine.$ || jQuery
  
  init:=>
    $ => 
      @editor  = new @Editor()
      @toolbar = new @Toolbar()
 
    @one "ready", ()=>
      $('#logo > span.text').text( @options.branding.label )
      $('#logo > span.icon i').removeClass('icon-truck')
        .addClass("icon-#{@options.branding.icon || 'truck'}")
  
  configure:( options = {} )=> $.extend( true, @options, options)

class Logger extends Spine.Module
  prefix: "(Transit)"
  info: (args...) ->
    return unless Transit.debug
    if @prefix then args.unshift(@prefix)
    console?.log?(args...)
    this
    
  error: (args...) ->
    return unless Transit.debug
    if @prefix then args.unshift(@prefix)
    console?.error?(args...)
    this

Transit = @Transit = new Transit()
Transit.logger = new Logger()

$(document).ajaxStart ()->
  $('#logo i').removeClass('icon-truck')
    .addClass('icon-spinner icon-spin')
  
$(document).ajaxComplete ()->
  $('#logo i')
    .removeClass('icon-spinner icon-spin')
    .addClass('icon-truck')
    
  
###---------------------------------------
 Exports
---------------------------------------### 

@Transit ||= Transit
module?.exports = Transit