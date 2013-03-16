#= require spec_helper

describe 'Transit', ->
  
  it 'should be a global object', ->
    expect(Transit).to.exist
  
  it 'includes an .on event handler', ->
    expect(Transit.on).to.exist
  
  it 'includes an .off event handler', ->
    expect(Transit.off).to.exist
  
  describe 'the .one event handler', ->
    callback = null

    beforeEach ->
      callback = sinon.spy()
      Transit.one('spec:init', callback)
      Transit.trigger('spec:init')
      Transit.trigger('spec:init')

    it 'only runs a callback once', ->
      expect(callback.callCount)
        .to.equal(1)