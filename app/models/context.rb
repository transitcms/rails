##
# A context is the base class for any content or feature that can / is 
# delivered by a deliverable. Each deliverable embeds many contexts within itself.
# 
# Additional context types should subclass Context
# 

require 'transit/delivery'
class Context
  include Mongoid::Document
  include Mongoid::Timestamps
  
  after_create :set_default_position
  
  field :position, :type => Integer
  embedded_in :deliverable, :polymorphic => true
  
  default_scope ascending(:position)
  
  def set_default_position
    self.set('position', self._parent.contexts.count.to_i)
  end
  
end

# Try to render the mongoid `preload_models` functionality un-necessary
#Dir[File.expand_path(".", __FILE__) << "/contexts/*.rb"].each{ |f| require f }