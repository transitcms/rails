require 'mongoid'
##
# Adds support for embedding images directly into a document as Base64 strings.
# These images can then be used as data uris inline in html or served via rack handler.
# 
class EmbeddedImage
  include ::Mongoid::Fields::Serializable
  attr_reader :data
  
  ##
  # Acts as a `middleware` to provide compatability
  # between general files and uploaded files. 
  # 
  class ImageData
    
    attr_reader :content_type, :body
    
    def initialize(img) #:nodoc:
      @content_type = img.content_type
      @body         = img.read
    end
    
  end
  
  ##
  # Stores the image data to be serialized on save.
  # If an uploaded file, or image based object is provided the object 
  # is stored as-is. If raw data is passed, an instance of ImageData is generated
  # for compatability.
  # 
  def set_data(image_data)
    unless image_data.respond_to?(:content_type)
      @data = image_data.to_s
    else
      @data = ImageData.new(image_data)
    end
  end
  
  ##
  # Called on load from the database
  # 
  def deserialize(image_data)
    return self.class.new unless image_data
    ::Marshal.load(::Base64.decode64(image_data)) 
  end

  ##
  # Called on store to the database
  #
  def serialize(image_data)
    set_data(image_data)
    ::Base64.encode64(::Marshal.dump(self))
  end
  
  ##
  # If the stored data is a string, return it directly.
  # Otherwise, base64 encode the image data and format into 
  # a string suitable for using in html.
  # 
  def to_s
    return data unless data.is_a?(ImageData)
    "data:#{data.content_type};base64,#{::Base64.encode64(data.body)}"
  end
  
end