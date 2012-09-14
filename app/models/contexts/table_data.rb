##
# Creates tabular data which can be rendered as an html table.
# 
class TableData < Context
  
  field :headings, :type => Array, :default => []
  embeds_many :rows, :class_name => 'TableData::Row'
  
  accepts_nested_attributes_for :rows, :allow_destroy => true
  
  class Row
    include Mongoid::Document
    include Transit::Extension::Ordering
    
    field :columns, :type => Array, :default => []
    embedded_in :table
  end
  
end