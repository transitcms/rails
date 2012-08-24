require 'mongoid'
##
# Adds support for embedding images directly into a document as Base64 strings.
# These images can then be used as data uris inline in html or served via rack handler.
# 
class EmbeddedImage
  attr_reader :data
  
  def mongoize
    ::Base64.encode64(::Marshal.dump(self))
  end
  
  class << self
    ##
    # Called on retrieval from the database.
    # 
    def demongoize(value)
      return self.new unless value
      ::Marshal.load(::Base64.decode64(value)) 
    end
  
    ##
    # Converts the object that was supplied to a criteria and converts it
    # into a database friendly form.
    #
    def evolve(image_data)
      case image_data
      when EmbeddedImage then image_data.mongoize
      else image_data
      end
    end

    ##
    # Called on save to the database.
    # 
    def mongoize(image_data)
      case image_data
      when EmbeddedImage then image_data.mongoize
      else 
        img = EmbeddedImage.new
        img.set_data(image_data)
        img.mongoize
      end
    end
  end  
  
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
  # If the stored data is a string, return it directly.
  # Otherwise, base64 encode the image data and format into 
  # a string suitable for using in html.
  # 
  def to_s
    return data unless data.is_a?(ImageData)
    "data:#{data.content_type};base64,#{::Base64.encode64(data.body)}"
  end
  
end