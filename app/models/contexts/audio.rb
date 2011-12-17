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

Transit::Delivery.configure(:audio) do |context, manager|
  manager.template.audio_tag(context.source.to_s,
    :data => { 
      :context_id   => context.id.to_s
    }).html_safe
end