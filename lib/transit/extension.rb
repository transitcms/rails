module Transit
  ##
  # Adds support for defining extensions to be utilized by deliverables.
  # These are useful for providing global methods or functionality that can
  # easily be used within any deliverable resource. Sure.. you could just write 
  # modules and include them, but this way is so much more Railsesque ;)
  # 
  module Extension
    autoload :Attachments,   'transit/extensions/attachments'
    autoload :Translations,  'transit/extensions/translations'
    autoload :ContentBlocks, 'transit/extensions/content_blocks'
    autoload :Publishing,    'transit/extensions/publishing'
    
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
    
    ##
    # Methods included by each deliverable to provide 
    # extension loading functionality
    # 
    # @author brent
    module Loader
      ##
      # Deliverables can include a number of other packages and 
      # delivery options. To include them pass them to this method.
      #
      # @param [Array] *args Argument list of packages/extensions to apply to the deliverable 
      # 
      # @example Deliver a resource with attachments
      #   deliver_with :attachments
      #
      def deliver_with(*args)
        options = args.extract_options!.symbolize_keys!
        [args, options.keys].flatten.compact.each do |arg|
          extname = arg.to_s.camelize
          unless Transit::Extension.const_defined?(extname)
            raise Transit::Extension::MissingExtensionError.new("The extension #{extname} could not be found.")
          end
          include Transit::Extension.const_get(extname)
        end
      end
      
      alias :add_extension :deliver_with
      
    end
    
    ##
    # Raised when an extension is requested that does not exist.
    # 
    class MissingExtensionError < ::Transit::Error    
    end
    
  end # Extension
end # Transit