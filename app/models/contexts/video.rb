##
# Context for attaching video files and data to deliverables
# 
class Video < MediaContext
  field :poster, :type => EmbeddedImage
  
  ##
  # Returns a boolean value representing whether or not a 
  # poster has been created for this context.
  # @return [Boolean] Whether a poster exists
  # 
  def poster?
    !read_attribute('poster').nil?
  end
  
end