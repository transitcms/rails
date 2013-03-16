#= require spine
#= require_self
#= require transit/deliverable

Spine    = @Spine or require('spine')
Transit  = null

###---------------------------------------
  Class
---------------------------------------### 

class Transit extends Spine.Module
  @include Spine.Events
  VERSION: "0.4.0"
  

Transit = @Transit = new Transit()
  
###---------------------------------------
 Exports
---------------------------------------### 

@Transit ||= Transit
module?.exports = Transit