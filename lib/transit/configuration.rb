module Transit
  class Configuration
    include ActiveSupport::Configurable
    config_accessor :enable_translations, :assets
    
    def initialize
      self.enable_translations = false
      self.assets = ::ActiveSupport::OrderedOptions.new({ 
        :styles  => {},
        :storage => :filesystem,
        :path    => ":rails_root/public/system/assets/:id/:style.:extension",
        :url     => "/system/assets/:id/:style.:extension"
      })
    end
    
  end
end