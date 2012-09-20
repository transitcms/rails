require 'spec_helper'

describe Transit::Interpolations do
  
  let!(:post) do
    Post.make
  end
  
  describe 'adding methods with Transit.interpolates' do

    before do
      Transit.interpolates(:test) do |model|
        "success"
      end
      
      Transit.interpolates(:post) do |model|
        model.title
      end
    end
    
    it 'should add an interpolation method' do
      Transit::Interpolations[:test]
        .should_not be_nil
    end
    
    it 'should add the callback as an interpolation' do
      Transit::Interpolations[:test]
        .should be_a(Method)
    end
    
    context 'when the interpolation is ran' do
      
      it 'replaces each key with the callback result' do
        Transit::Interpolations.interpolate(":test", post)
          .should eq "success"
      end
      
      it 'passes any arguments to the interpolation block' do
        Transit::Interpolations.interpolate(":post", post)
          .should eq post.title
      end
    end
  end
  
  describe 'built in interpolations' do
    
    before do
      post.stub(
        :publish_date => Date.today,
        :title        => 'sample title'
      )
    end
    
    let(:expected) do
      "#{Date.today.month}/#{Date.today.year}/#{post.title.to_slug}"
    end
      
    let(:result) do
      Transit::Interpolations.interpolate(":month/:year/:title", post)
    end
      
    it "interpolates month, year, and title" do
      result.should eq expected
    end
  end
end