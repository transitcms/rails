module Transit
  module Extension
    autoload :Attachments, 'transit/extensions/attachments'
    autoload :Translation, 'transit/extensions/translation'
    
    class << self
      
      ##
      # Extensions can be included from other gems or libraries. To enable autoloading of 
      # these extensions, add them with the .add method.
      # 
      def add(name, path = nil)
        path ||= "transit/extensions/#{name.to_s.underscore}"
        self.send(:autoload, name.to_sym, path)
      end
      
    end
    
    module Loader
      ##
      # Deliverables can include a number of other packages and 
      # delivery options. To include them pass them to this method.
      #
      # @param [Array] *args Argument list of packages/extensions to apply to the deliverable 
      #
      def deliver_with(*args)
        args.map(&:to_s).map(&:classify).each do |extname|
          raise Transit::Extension::MissingExtensionError unless Transit::Extension.const_defined?(extname)
          include Transit::Extension.const_get(extname)
        end
      end
      
      alias :add_extension :deliver_with
      
    end
    
    class MissingExtensionError < StandardError
    end
    
  end # Extension
end # Transit