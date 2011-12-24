module Transit
  module Extension
    module String
      def to_slug
        value = self.mb_chars.normalize(:kd).gsub(/[^\x00-\x7F]/n, '').to_s
        value.gsub!(/[']+/, '')
        value.gsub!(/\W+/, ' ')
        value.strip!
        value.downcase!
        value.gsub!(' ', '-')
        value
      end
    end    
  end
end

require 'mongoid'

class HtmlContent < String
  include ::Mongoid::Fields::Serializable

  def initialize(strval)
    self.concat strval
  end
  
  def deserialize(strval)
    self.replace strval
  end

  def serialize(strval)
    strval
  end
  
end

##
# Adds support for embedding images directly into a document as Base64 strings.
# These images can then be used as data uris inline in html or served via rack handler.
# 
class EmbeddedImage
  include ::Mongoid::Fields::Serializable
  attr_reader :data
  
  class ImageData
    attr_reader :content_type, :body
    def initialize(img)
      @content_type = img.content_type
      @body         = img.read
    end
  end
  
  def set_data(image_data)
    unless image_data.respond_to?(:content_type)
      @data = image_data.to_s
    else
      @data = ImageData.new(image_data)
    end
  end
  
  def deserialize(image_data)
    return self.class.new unless image_data
    ::Marshal.load(::Base64.decode64(image_data)) 
  end

  def serialize(image_data)
    set_data(image_data)
    ::Base64.encode64s(::Marshal.dump(self))
  end
  
  def to_s
    return data unless data.is_a?(ImageData)
    "data:#{data.content_type};base64,#{::Base64.encode64s(data.body)}"
  end
  
end

String.send(:include, Transit::Extension::String)