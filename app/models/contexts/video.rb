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

Transit::Delivery.configure(:video) do |context|
  video_tag(context.source.to_s,
    :data => { 
      :context_id   => context.id.to_s
    }).html_safe
end