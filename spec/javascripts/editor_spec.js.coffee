#= require spec_helper

describe 'Transit.Editor', ->
  
  beforeEach (done)->
    page.append("<iframe id='transit_frame' src='about:blank' style='visibility:hidden'></iframe>")
    setTimeout(done, 1000)
  
  it 'should be a global object', ->
    expect(Transit.Editor).to.exist
  
  describe 'the editor iframe', ->

    @timeout(5000)
    editor = null
    
    beforeEach ()->
      editor = new Transit.Editor()
    
    describe 'when the frame loads', ->
      
      rdy = sinon.spy()
      
      beforeEach (done)->
        Transit.one('ready', rdy)
        editor.$el.one('load', (-> done()))
        editor.$el.attr('src', '/pages/1?transit_managed=true')
      
      it 'triggers a ready event', ->
        expect(rdy.callCount)
          .to.equal 1

      it 'assigns the iframe window to @win', ->
        expect(editor.win)
          .to.exist
        
      it 'should assign Transit to the iframe window', ->
        expect(editor.win.Transit)
          .to.exist
      
      