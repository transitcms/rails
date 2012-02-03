require 'spec_helper'

describe Transit::Delivery, type: :view do
  
  it "has a configure method" do
    Transit::Delivery.respond_to?(:configure).should be_true
  end
  
  it "accepts a name and proc and stores it" do
    Transit::Delivery.configure(:test) do |ctext, template|      
    end
    Transit::Delivery.delivery_methods['test'].should be_a(Proc)
  end
  
  describe "an instance" do
    
    it "takes an instance of a view as @template" do
      delivery = Transit::Delivery.new(TextBlock.new, view)
      delivery.template.should_not be_nil
    end
    
    context "when delivering a context" do
      
      let(:item) do
        Audio.new(source: 'www.test.com/something.mp3')
      end
      
      it 'renders in the scope of the current view' do
        Transit::Delivery.configure(:audio) do |ctext|
          ctext.is_a?(Audio).should == true
          content_tag(:div)
        end               
        Transit::Delivery.new(item, view).deliver.should == "<div></div>" 
      end
      
    end
    
  end
  
  
end