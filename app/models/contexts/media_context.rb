##
# Base context for media data such as audio or video
# 
class MediaContext < Context
  include Mongoid::Document
  
  field :source,     :type => String
  field :media_type, :type => String
  
  belongs_to :asset
  
  ##
  # Returns the url source of the included media. 
  # If an attached asset is found, it returns the paperclip 
  # generated url, otherwise the `source` attribute is returned.
  # 
  def source
    return read_attribute("source") if self.asset_id.nil?
    self.asset.file.url(:original)
  end
  
end