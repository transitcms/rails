##
# A context is the base class for any content or feature that can / is 
# delivered by a deliverable. Each deliverable embeds many contexts within itself.
# 
# Additional context types should subclass Context
# 
class Context
  include Mongoid::Document
  include Mongoid::Timestamps
  
  if Transit.config.enable_translations
    enable_translation
  end
  
  field :position, :type => Integer
  embedded_in :deliverable, :polymorphic => true
  
  default_scope ascending(:position)
  
end

# Try to remove the mongoid `preload_models` functionality un-necessary
Dir[File.expand_path(".", __FILE__) << "/contexts/*.rb"].each{ |f| require f }