#= require transit/context
#= require_self

class @Transit.Deliverable extends Transit.Model
  @extend Spine.Model.Local
  @configure 'Deliverable', 'contexts_attributes'
  @hasMany 'contexts', 'Transit.Context'
