module Transit
  module Helpers
    autoload :Delivery, 'transit/helpers/delivery'
    autoload :Pages,    'transit/helpers/pages'
    
    class << self
    
      ##
      # Takes an options array and adds any additional 
      # classes passed to args. If a :class key exists, it 
      # is updated. If not, it is added unless the result is
      # an empty string. 
      # 
      def merge_tag_classes(*args)
        opts    = args.extract_options!
        klasses = (opts.delete(:class) || "").split(" ")
        klasses = [klasses, args].flatten.compact.reject{ |c| c.to_s.blank? }.map(&:strip).uniq
        return opts if klasses.empty?
        opts.merge(:class => klasses.join(" "))
      end
    end
    
  end
end