require 'spec_helper'
require 'rack/test'

describe 'EmbeddedImage' do
  
  class PicHolder
    include Mongoid::Document
    field :image, :type => EmbeddedImage
  end
  
  it 'acts as a serializable field' do
    PicHolder.new.respond_to?(:image).should be_true
  end
  
  let(:klass) do
    PicHolder.new
  end
  
  context 'when assigned a string' do
    
    let(:image_data) do
      "http://somewhere.com/something.png"
    end 
    
    before(:all) do
      klass.image = image_data
    end
    
    it "creates an instance of the EmbeddedImage class" do
      klass.image.should be_a(EmbeddedImage)
    end
    
    it 'returns the passed string for its data' do
      klass.image.to_s.should == image_data
    end
    
  end
  
  context 'when assigned an image' do

    let(:image_data) do
      Rack::Test::UploadedFile.new(File.join(File.expand_path('../../../fixtures', __FILE__), 'image.jpg'), nil, false)
    end
    
    before(:all) do
      klass.image = image_data
    end
    
    it "creates an instance of the EmbeddedImage class" do
      klass.image.should be_a(EmbeddedImage)
    end
    
    it 'returns the passed string for its data' do
      klass.image.to_s.should match(/^data\:/)
    end
    
  end
  
end