#= require spec_helper

describe 'Transit.Deliverable', ->
  
  page = new Transit.Deliverable()
  
  it 'should be a global object', ->
    expect(Transit.Deliverable)
      .to.exist
  
  it 'has many contexts', ->
    expect(page.contexts)
      .to.be.a('function')
  
  it 'has many attachments', ->
    expect(page.attachments)
      .to.be.a('function')
    
    
  describe 'contexts', ->