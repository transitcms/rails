require 'transit/delivery'
##
# A context is the base class for any content or feature that can / is 
# delivered by a deliverable. Each deliverable embeds many contexts within itself.
# 
# Additional context types should subclass Context
# 
class Context
  include Mongoid::Document
  include Mongoid::Timestamps
  
  class_attribute :has_translation_support
  self.has_translation_support = Transit.config.translate
  
  after_create :set_default_position
  
  field :position, :type => Integer
  embedded_in :deliverable, :polymorphic => true
  
  default_scope ascending(:position)
  
  ##
  # On create, new contexts are added to the bottom of the 'stack'.
  # Contexts are always output in ascending order by their position.
  # 
  def set_default_position
    self.set('position', self._parent.contexts.count.to_i)
  end
  
end