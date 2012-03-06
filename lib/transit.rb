require "active_support/all"
require "transit/version"

##
# Base module
# 
module Transit
  extend self
  
  module Support
  end
  
  include ActiveSupport::Configurable
  
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