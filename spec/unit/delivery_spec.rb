require 'spec_helper'

describe Transit::Delivery, type: :view do
  
  def deliver_item(item)
    Transit::Delivery.new(item, view).deliver
  end
  
  let(:audio) do
    Audio.new(
      :source => 'www.test.com/something.mp3'
    )
  end
  
  let(:text) do
    TextBlock.new(
      :body => "<p>My text is awesome</p>"
    )
  end
  
  describe "an instance" do
    
    it "takes an instance of a view as @template" do
      Transit::Delivery.new(TextBlock.new, view)
        .template.should_not be_nil
    end
  end
  
  describe "The response" do
    
    context 'when the resource is missing a view' do
      
      let(:render) do
        lambda{ 
          deliver_item(Class.new) 
        }
      end
      
      it 'raises an undeliverable error' do
        render.should(
          raise_error(Transit::Delivery::UndeliverableResourceError)
        )
      end
    end
    
    context 'when the resource view exists' do
      
      let(:result) do
        "<audio src=\"#{audio.source}\" data-context-id=\"#{audio.id.to_s}\" controls></audio>" 
      end
      
      it 'renders the view for that context' do
        deliver_item(audio)
          .should eq result
      end
    end
    
    context 'when the context has a .deliver method' do
      
      let!(:text) do
        TextBlock.new(
          :body => 'body text'
        )
      end
      
      context 'when .deliver returns false' do
        
        before do
          text.stub(
            :deliver => false
          )
        end
        
        it 'falls back to the configured delivery' do
          deliver_item(text)
            .should eq "<p>body text</p>"
        end
      end
      
      context 'when .deliver does not return false' do
        
        it 'uses the result' do
          deliver_item(text)
            .should eq 'body text'
        end
      end
    end
  end
end