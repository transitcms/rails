##
# Context for attaching video files and data to deliverables
# 
class Video < Context
  
  field :source, :type => String
  belongs_to :asset
  
  def source
    return read_attribute("source") if self.asset_id.nil?
    self.asset.file.url(:original)
  end
  
end

Transit::Delivery.configure(:video) do |context, manager|
  manager.template.content_tag(:div, "", :class =>  "video-player", 
    :data => { 
      :context_id   => context.id, 
      :context_type => "video", 
      :source       => context.source 
    }).html_safe
end