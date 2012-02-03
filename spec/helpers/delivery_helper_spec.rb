require 'spec_helper'

describe DeliveryHelper, :type => :helper do
  
  before(:all) do
    @post = Post.make!
    @text  = @post.contexts.build({ :position => 0, :body => "<p>sample text body</p>" }, TextBlock)
    @audio = @post.contexts.build({ :position => 1, :source => "somefile.mp3" }, Audio)
    @post.save
  end
  Audio
  
  before do
    Transit::Delivery.configure(:audio) do |context|
      content_tag(:div, "", :class =>  "audio-player", 
        :data => { 
          :context_id   => context.id.to_s, 
          :context_type => "audio", 
          :source       => context.source 
        }).html_safe
    end
  end
  
  let(:body_copy) do
    "<p>sample text body</p>"
  end
  
  let(:audio_body) do
    %Q{<div class="audio-player" data-context-id="#{@audio.id.to_s}" data-context-type="audio" data-source="somefile.mp3"></div>}
  end
  
  it "delivers contexts in order of position" do
    helper.deliver(@post).should == [body_copy, audio_body].join
  end
  
  context "when changing context order" do
    
    before(:all) do
      @text.update_attributes(:position => 1)
      @audio.update_attributes(:position => 0)
    end
    
    it "changes the output order" do
      helper.deliver(@post).should == [audio_body, body_copy].join
    end
    
  end
  
end