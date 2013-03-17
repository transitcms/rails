#= require spine
#= require bootstrap
#= require_self

#= require transit/editor
#= require transit/model
#= require transit/context
#= require transit/deliverable
#= require transit/manager

Spine   = @Spine or require('spine')
$       = Spine.$
Transit = null


###---------------------------------------
  Class
---------------------------------------### 

class Transit extends Spine.Module
  @include Spine.Events
  VERSION: "0.4.0"
  branding: "transit"
  debug: true
  editor: null
  
  managers: []
  init:->
    $ =>
      $('#logo > span.text').text( @branding )

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