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
  
  ##
  # Non "removable" contexts cannot be destroyed. This is useful when 
  # building out posts/pages with content that should never be 
  # removed by an end-user.
  # 
  field :removable, :type => Boolean, :default => true
  
  before_destroy :block_removal_of_fixed_contexts
  
  # contexts embed within deliverables
  embedded_in :deliverable, :polymorphic => true
  
  scope :called, lambda{ |name| where(:identifier => name) }
  
  ##
  # Accessor for reading the type of context.
  # 
  def context_type
    self.class.name.to_s
  end
  
  ##
  # Override serialization to ensure the _type is set, as well as adding a normal 
  # 'id' attribute which is helpful when using libraries like Backbone/Spine etc.
  # Although mongoid 3 has support for adding the _type property via configuration 
  # it is set here for ease of use.
  # 
  # This method also ensures the position attribute is always included. 
  # 
  # @param [Hash] options Custom options from as/to_json
  # @return [Hash] A hash used for ActiveModel serialization
  # 
  def serializable_hash(options = {})
    super(options).merge!(
      'position' => self.position,
      '_type'    => self.context_type,
      'id'       => self.id
    )
  end
  
  private
  
  ##
  # If a context is fixed, do not allow it to be removed.
  # 
  def block_removal_of_fixed_contexts
    return true if self.removable?
    false
  end
  
end