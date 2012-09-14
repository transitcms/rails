require 'spec_helper'

describe 'TableData' do
  
  let(:table) do
    TableData.new
  end
  
  it 'embeds many rows' do
    table.respond_to?(:rows)
      .should be_true
  end
  
  it 'embeds rows as an array' do
    table.rows 
      .should be_a(Array)
  end
  
end