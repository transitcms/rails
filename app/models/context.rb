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
  
  include Transit::Extension::Ordering
  
  class_attribute :has_translation_support
  self.has_translation_support = Transit.config.translate
  
  ##
  # Optional identifier for the context, used when you want to 
  # deliver a single context within a portion of a page or post.
  # 
  field :identifier, :type => String, :default => ''
  embedded_in :deliverable, :polymorphic => true
  scope :called, lambda{ |name| where(:identifier => name) }
  
  def context_type
    self.class.name.to_s
  end
  
  def as_json(options = {})
    super(options).merge!(
      'position' => self.position,
      '_type'    => self.context_type,
      'id'       => self.id
    ).tap{ |h| h.delete('_id') }
  end
  
end