##
# Extends string to create url friendly formatted values.
# Original implemention by Ludo van den Boom
# @see https://github.com/ludo/to_slug
# 
class String
  
  ##
  # Removes all non url-friendly characters and replaces spaces 
  # and underscores with hyphens.
  # 
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