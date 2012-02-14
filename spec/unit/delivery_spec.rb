require 'spec_helper'

describe Transit::Delivery, type: :view do
  
  def deliver_item(item)
    Transit::Delivery.new(item, view).deliver
  end
  
  let(:audio) do
    Audio.new(:source => 'www.test.com/something.mp3')
  end
  
  let(:text) do
    TextBlock.new(:body => "<p>My text is awesome</p>")
  end
  
  describe "an instance" do
    
    it "takes an instance of a view as @template" do
      Transit::Delivery.new(TextBlock.new, view).template.should_not be_nil
    end
    
  end
  
  describe "The response" do
    
    it 'raises an undeliverable error unless the resource is a deliverable' do
      lambda{ deliver_item(Class.new) }.should 
        raise_error(Transit::Delivery::UndeliverableResourceError)
    end
    
    it 'renders in the scope of the current view' do
      deliver_item(audio).should == "<audio src=\"#{audio.source}\" data-context-id=\"#{audio.id.to_s}\" controls></audio>" 
    end
    
    context 'when no delivery is configured for a context' do
      
      it 'raises an undeliverable context error' do
        lambda{ deliver_item(UndeliverableContext.new) }.should 
          raise_error(Transit::Delivery::UndeliverableContextError)
      end
      
    end
    
    context 'when a partial for the context is found' do
      
      it 'renders the partial for the delivery' do
        deliver_item(InlineTextWithPartial.new(:body => 'Some Heading')).should == "<h2>Some Heading</h2>"
      end
      
    end
    
    context 'when the context has a .deliver method' do
      
      context 'its result === false' do
        
        it 'falls back to the configured delivery' do
          deliver_item(AltTextBlock.new(:body => "body text")).should == "<p>body text</p>"
        end
        
      end # false .deliver
      
      context 'its result === false' do
        
        it 'uses the result' do
          deliver_item(text).should == "<p>My text is awesome</p>"
        end
        
      end # passing .deliver
      
    end
    
  end
  
  
end