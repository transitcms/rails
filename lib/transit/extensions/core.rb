module Transit
  module Extension
    module String
      def to_slug
        value = self.mb_chars.normalize(:kd).gsub(/[^\x00-\x7F]/n, '').to_s
        value.gsub!(/[']+/, '')
        value.gsub!(/\W+/, ' ')
        value.strip!
        value.downcase!
        value.gsub!(' ', '-')
        value
      end
    end    
  end
end

class HtmlContent < String
  include Mongoid::Fields::Serializable

  def initialize(strval)
    self.concat strval
  end
  
  def deserialize(strval)
    self.replace strval
  end

  def serialize(strval)
    strval
  end
  
end

String.send(:include, Transit::Extension::String)