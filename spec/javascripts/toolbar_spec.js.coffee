#= require spec_helper

describe 'Transit.Toolbar', ->
  
  toolbar = null
  
  beforeEach ->
    Transit.init
    toolbar = Transit.toolbar = new Transit.Toolbar()
