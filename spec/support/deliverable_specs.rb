module DeliverableSpecs
  unloadable
  extend ActiveSupport::Concern
  
  included do

    it "has a deliver_as method" do
      described_class.respond_to?(:deliver_as).should be_true
    end
    
    it "has a deliver_with method" do
      described_class.respond_to?(:deliver_with).should be_true
    end 
    
    it "has a delivers_as attribute" do
      described_class.respond_to?(:delivers_as).should be_true
    end
    
    it "has a delivery_options attribute" do
      described_class.respond_to?(:delivery_options).should be_true
    end
    
    it{ should embed_many(:contexts) }
    
    describe 'serializing as json' do
      
      let!(:item) do
        described_class.make!(
          :contexts => [
            TextBlock.new
          ]
        )
      end
      
      let(:item_data) do
        item.as_json.stringify_keys!
      end
      
      it 'includes additional options in serialization' do
        item_data['contexts'].first
          .keys.should include('id')
      end
    end
  end
  
  
end