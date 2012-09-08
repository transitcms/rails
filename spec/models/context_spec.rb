require 'spec_helper' 

describe Context do
  
  it "is embedded in a deliverable" do
    should be_embedded_in(:deliverable)
  end
  
  let!(:post) do
    @_post ||= Post.make!
  end
  
  describe "position" do
    
    context "when the first context" do
      
      before(:all) do
        post.contexts.create({ body: "test post body" }, TextBlock)
      end
      
      it 'defaults to 1' do
        post.contexts.first.position.should == 1
      end
    end
    
    context "when an additional context" do
      
      before(:all) do
        post.contexts.create({ body: "test post body" }, TextBlock)
      end
      
      it "increments the position by 1" do
        post.contexts.create({ body: "another test body" }, TextBlock)
        post.contexts.last.position.should == 2
      end
    end
  end 
  
end