require 'spec_helper'

describe "Delivery Helper", :type => :helper do
  
  let!(:post) do
    Post.make!
  end
  
  let!(:text) do
    post.contexts.build({
      position: 0, 
      body: "<p>sample text body</p>"
    }, TextBlock)
  end
  
  let!(:audio) do
    post.contexts.build({
      position: 0, 
      source: "somefile.mp3"
    }, Audio)
  end
  
  let(:body_copy) do
    "<p>sample text body</p>"
  end
  
  let(:audio_body) do
    %Q{<audio src="somefile.mp3" data-context-id="#{audio.id.to_s}" controls></audio>}
  end
  
  let(:post_body) do
    [body_copy, audio_body].join
  end
  
  let(:reverse_body) do
    [audio_body, body_copy].join
  end
  
  it "delivers contexts in order of position" do
    helper.deliver(post)
      .should eq post_body
  end
  
  context "when changing context order" do
    
    before do
      text.set(:position, 1)
      audio.set(:position, 0)
    end
    
    it "changes the output order" do
      helper.deliver(post)
        .should eq reverse_body
    end
  end
  
  context 'when delivering a single context' do
    
    it 'only outputs that context' do
      helper.deliver(audio)
        .should eq audio_body
    end
  end
  
  context 'when :managed is passed to deliver' do
    
    context 'and :managed is true' do
      
      let(:result) do
        helper.deliver(text, 
          :managed => true
        )
      end
      
      let(:selector) do
        'div.managed-context'
      end
      
      it 'renders the manage view' do
        result.should(
          have_tag('div.managed')
        )
      end
      
      describe 'the containing div' do
        
        it 'includes the context name as a class' do
          result.should(
            have_tag(selector,
              :with => { 
                :class => 'managed-context text-block'
              }
            )
          )
        end
        it 'should include data-context-id' do
          result.should(
            have_tag(selector, 
              :with => {
                "data-context-id" => text.id.to_s
              }
            )
          )
        end
        
        it 'should include data-context-type' do
          result.should(
            have_tag(selector, 
              :with => {
                "data-context-type" => 'TextBlock'
              }
            ))
        end
      end
    end
    
    context 'and :managed is false' do
      
      let(:result) do
        helper.deliver(text, 
          :managed => false
        )
      end
      
      it 'renders a context as-is' do
        result.should(
          eq body_copy
        )
      end
    end
  end
end