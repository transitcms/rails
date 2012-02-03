require 'spec_helper'

describe Transit::Delivery, type: :view do
  
  def deliver_item(item)
    Transit::Delivery.new(item, view).deliver
  end
  
  before do
    Transit::Delivery.configure(:audio) do |obj|
      obj.is_a?(Audio).should == true
      content_tag(:div, "", :data => { :source => obj.source })
    end
  end
  
  let(:audio) do
    Audio.new(:source => 'www.test.com/something.mp3')
  end
  
  let(:text) do
    TextBlock.new(:body => "<p>My text is awesome</p>")
  end
  
  describe 'configuration' do
  
    it "has a configure method" do
      Transit::Delivery.respond_to?(:configure).should be_true
    end

    it "accepts a name and proc and stores it" do
      Transit::Delivery.configure(:test){ |obj| }
      Transit::Delivery.delivery_methods['test'].should be_a(Proc)
    end
    
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
      deliver_item(audio).should == "<div data-source=\"#{audio.source}\"></div>" 
    end
    
    context 'when no delivery is configured for a context' do
      
      it 'raises an undeliverable context error' do
        lambda{ deliver_item(UndeliverableContext.new) }.should 
          raise_error(Transit::Delivery::UndeliverableContextError)
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