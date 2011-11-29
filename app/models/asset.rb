##
# An asset is an uploaded file that may belong to one or more deliverables.
# 
#
require 'paperclip'
require 'mime/types'

class Asset
  include Mongoid::Document
  include Mongoid::Timestamps
  include Paperclip::Glue
  
  has_attached_file :file, Transit.config.assets.to_hash
  
  field :name,              :type => String
  field :file_file_name,    :type => String
  field :file_content_type, :type => String
  field :file_updated_at,   :type => Time
  field :file_fingerprint,  :type => String
  field :file_file_size,    :type => Integer
  field :file_type,         :type => String
  
  validates_attachment_presence :file
  
  before_save   :set_default_name
  before_create :set_default_file_type
  
  def image?
    !!(self.file_content_type =~ %r{^(image|(x-)?application)/(x-png|pjpeg|jpeg|jpg|png|gif)$})
  end
  
  def video?
    !!(self.file_content_type =~ %r{^(video)/.*$})
  end
  
  def audio?
    !!(self.file_content_type =~ %r{^(audio)/.*$})
  end
  
  ##
  # Loops through all paperclip processing styles and generates 
  # an array of urls for the attachment.
  # 
  def urls
    return { :original => file.url(:original) } unless image?
    file.styles.keys.inject({}) do |hash, style|
      hash.merge!(style => file.url(style))
    end
  end
  
  ##
  # Convenience method to return the created_at time in a date format.
  # 
  def timestamp
    self.created_at.strftime("%B %d, %Y")
  end
  
  private
  
  ##
  # Allow assigning a name attribute to an asset for easier identification
  # 
  def set_default_name
    self.name = self.file_file_name.to_s
  end
  
  def set_default_file_type
    self.file_type = ::MIME::Types.type_for(self.file_file_name.to_s).first.media_type
  end
  
end