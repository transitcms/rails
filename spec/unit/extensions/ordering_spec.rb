require 'spec_helper'

describe "the Ordering extension" do
  
  context 'when included' do
    
    it 'adds a position field' do
      Context.fields.keys
        .should include('position')
    end
  end
  
  let!(:menu) do
    Transit::Menu.make!
  end
  
  describe "position" do
    
    let!(:item) do
      menu.items
        .create({ 
          :title => "Home Page",
          :url   => "/about"  
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
            :title => "About Page",
            :url   => "/about" 
          })
      end
      
      it "increments the position by 1" do
        second.position
          .should eq 2
      end
    end
  end 
  
  describe 'repositioning items' do
    
    let!(:item1) do
      menu.items
        .create({ 
          :title => "Home Page",
          :url   => "/about" 
        })
    end
    
    let!(:item2) do
      menu.items
        .create({ 
          :title => "Second Page",
          :url   => "/about" 
        })
    end
    
    let!(:item3) do
      menu.items
        .create({ 
          :title => "Third Page",
          :url   => "/about" 
        })
    end
    
    let!(:item4) do
      menu.items
        .create({ 
          :title => "Fourth Page",
          :url   => "/about" 
        })
    end
    
    context 'when repositioning with a valid position' do
      
      before do
        item2.reposition!(1)
      end
      
      it 'moves the item to the current location' do
        item2.reload.position
          .should eq 1
      end
      
      it 'moves all other items up the list' do
        item1.reload.position
          .should eq 2
        item3.reload.position
          .should eq 3
        item4.reload.position
          .should eq 4
      end
    end
    
    context 'when repositioning with an invalid position' do
      
      context 'and the position is less than or 0' do
        
        before do
          item2.reposition!(-1)
        end
        
        it 'moves the item to position 1' do
          item2.reload.position
            .should eq 1
        end
        
        it 'moves all other items up the list' do
          item1.reload.position
            .should eq 2
          item3.reload.position
            .should eq 3
          item4.reload.position
            .should eq 4
        end
      end
      
      context 'and the position is greater than the number of countable items' do
        
        before do
          item2.reposition!(10)
        end
        
        it 'moves the item the last position' do
          item2.reload.position
            .should eq 4
        end
        
        it 'reorders items less than its position' do
          item1.reload.position
            .should eq 1
          item3.reload.position
            .should eq 2
          item4.reload.position
            .should eq 3
        end
      end
    end
  end
end