require "active_support/all"
require "transit/version"

module Transit
  
  class << self
    attr_accessor :config
    
    ##
    # @see transit/configuration.rb
    # 
    def config
      @config ||= Configuration.new
    end
    
    ##
    # Configure options using a block
    # 
    # @example Configure translation support
    # 
    #   Transit.configure do |config|
    #     config.enable_translations = true
    #   end
    # 
    def configure
      yield config
    end
    
  end # eigen
  
end # Transit

require "transit/error"
require "transit/deliverable"
require "transit/definition"
require "transit/hooks"
require "transit/configuration"
require "transit/extension"
require "transit/extensions/core"
require "transit/delivery"
require "transit/engine"