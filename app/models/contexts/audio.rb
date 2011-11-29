##
# Context for attaching audio files and data to deliverables
# 
class Audio < Context
  
  field :source, :type => String
  belongs_to :asset
  
  def source
    return read_attribute("source") if self.asset_id.nil?
    self.asset.file.url(:original)
  end
  
end

# Transit::Delivery.configure(:audio) do |context, template|
#   template.content_tag(:div, "", :class =>  "audio-player", 
#     :data => { 
#       :context_id   => context.id, 
#       :context_type => "audio", 
#       :source       => context.source 
#     }).html_safe
# end