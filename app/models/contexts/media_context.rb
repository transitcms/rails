##
# Base context for media data such as audio or video
# 
class MediaContext
  field :source, :type => String
  belongs_to :asset
  
  def source
    return read_attribute("source") if self.asset_id.nil?
    self.asset.file.url(:original)
  end
end