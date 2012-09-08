require 'spec_helper'

describe "the Ordering extension" do
  
  context 'when included' do
    
    it 'adds a position field' do
      Context.fields.keys
        .should include('position')
    end
  end
  
  let!(:menu) do
    Menu.make!
  end
  
  describe "position" do
    
    let!(:item) do
      menu.items
        .create({ 
          :title => "Home Page" 
        })
    end
      
    context "when the first item" do

      it 'defaults to 1' do
        item.position
          .should eq 1
      end
    end
    
    context "when an additional item" do
      
      let!(:second) do
        menu.items
          .create({ 
            :title => "About Page" 
          })
      end
      
      it "increments the position by 1" do
        second.position
          .should eq 2
      end
    end
  end 
end