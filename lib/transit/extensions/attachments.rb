module Transit
  module Extension
    ##
    # Provides mostly convenience methods for attaching files via paperclip
    # 
    module Attachments
      
      extend ActiveSupport::Concern
      
      included do
        require 'paperclip'
        include Paperclip::Glue
      end
      
      ##
      # Class level methods and functionality
      #
      module ClassMethods
        ##
        # Shortcut to paperclip's has_attached_file method which 
        # also defines the proper fields. Maybe one day paperclip will 
        # stop being ActiveRecord focused since it works fine with other orms *hint* :)
        # 
        def attach(name, options)
          has_attached_file name, options
          field :"#{name.to_s}_file_name",    :type => String
          field :"#{name.to_s}_content_type", :type => String
          field :"#{name.to_s}_updated_at",   :type => Time
          field :"#{name.to_s}_fingerprint",  :type => String
          field :"#{name.to_s}_file_size",    :type => Integer
        end
        
      end
      
    end # Attachments
  end # Extension
end # Transit