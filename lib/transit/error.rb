module Transit
  # @private
  class Error < StandardError #:nodoc:
    BASE_KEY = "transit.errors"
    
    # ##
    # Translate an error message
    # @param [String] key The i18n message key
    # @param [Hash] options Options to pass to the i18n library
    # 
    def translate(key, options)
      ::I18n.translate("#{BASE_KEY}.#{key}", options)
    end
  end
end

    