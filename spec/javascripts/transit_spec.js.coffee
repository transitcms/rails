#= require spec_helper

describe 'Transit', ->
  
  it 'should be a global object', ->
    expect(Transit).to.exist
  
  it 'includes an .on event handler', ->
    expect(Transit.on).to.exist
  
  it 'includes an .off event handler', ->
    expect(Transit.off).to.exist
  
  describe '.init', ->
    
    beforeEach -> 
      Transit.init()
    
    it 'should create an editor instance', ->
      expect(Transit.editor)
        .to.exist
        
    it 'should create a toolbar instance', ->
      console.log(Transit)
      expect(Transit.toolbar)
        .to.exist
  
  describe '.configure', ->
    
    beforeEach ->
      Transit.configure
        branding:
          label: "tester"
    
    it 'extends the .options property', ->
      expect(
        Transit.options.branding.label
      ).to.equal 'tester'
      