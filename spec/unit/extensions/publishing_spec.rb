require 'spec_helper' 

describe 'the Publishing extension' do

  describe "published scope" do
   
    before do      
      Post.make!(:post_date => 1.year.ago.to_time, :published => true)
      Post.make!(:post_date => 1.year.from_now.to_time, :published => true)
      Post.make!(:post_date => 1.year.ago.to_time, :published => false)
    end
    
    it 'finds resources where published is true, and the post date is before or on today' do
      Post.published.count.should == 1
    end
  
  end
  
end