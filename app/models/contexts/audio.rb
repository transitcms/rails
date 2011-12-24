##
# Context for attaching audio files and data to deliverables
# 
class Audio < MediaContext
end

Transit::Delivery.configure(:audio) do |context, manager|
  manager.template.audio_tag(context.source.to_s,
    :data => { 
      :context_id   => context.id.to_s
    }).html_safe
end