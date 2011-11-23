##
# A context is the base class for any content or feature that can / is 
# delivered by a deliverable. Each deliverable embeds many contexts within itself.
# 
# Additional context types should subclass Context
# 
class Context
  include Mongoid::Document
  include Mongoid::Timestamps
  
  embedded_in :deliverable, :polymorphic => true
  
end