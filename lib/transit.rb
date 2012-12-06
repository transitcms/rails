require "active_support/all"
require "transit/version"

##
# Base module
# 
module Transit
  extend self
  
  autoload :Interpolations, 'transit/interpolations'
  autoload :Generator,      'transit/generator'
  autoload :Menu,           File.expand_path('../../app/models/transit/menu', __FILE__)

  module Support
  end
  
  include ActiveSupport::Configurable
  config_accessor :template_base_path
  
  ##
  # Paperclip style interpolations
  # 
  def interpolates(key, &block)
    Transit::Interpolations[key] = block
  end
  
  ##
  # Stores a hash which identifies all 
  # registered deliverables within the app.
  # 
  def deliverables
    @deliverables ||= {}
  end
    
  ##
  # Configure options using a block
  # 
  def configure
    yield config
  end
  
end # Transit

require "transit/error"
require "transit/deliverable"
require "transit/definition"
require "transit/hooks"
require "transit/configuration"
require "transit/extension"
require "transit/support/all"
require "transit/delivery"
require "transit/engine"
require "transit/helpers"