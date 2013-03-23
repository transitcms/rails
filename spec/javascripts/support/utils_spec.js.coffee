#= require spec_helper

describe 'Transit.utils', ->
  
  describe 'findClass', ->
    
    beforeEach ->
      window.Temp = 
        A: 1
        B: 2
    
    it 'finds an object from a context and string', ->
      klass = Transit.utils
        .findClass( window, "Temp.A" )
      expect(klass).to.equal 1