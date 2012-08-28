require 'spec_helper' 

describe Transit::ContextsController, :type => :controller do 
  
  before do
    Transit::ContextsController
      .any_instance.stub(
        :authenticate_admin! => true
      )
    Transit.config
      .authentication_method = method
  end
  
  let!(:page) do
    Page.make!
  end
  
  let!(:method) do
    :authenticate_admin!
  end
  
  def do_request(name, options = {})
    get name, {
      :deliverable    => 'Page', 
      :deliverable_id => page.id,
      :format => :json
    }.merge!(options)
  end
  
  describe 'running authentication methods' do
    
    context 'when the method is configured' do
      
      it 'calls the method' do
        controller.should_receive(method)
          .once
        do_request(:index)
      end 
    end
    
    context 'when the method is nil' do
      
      let!(:method) do
        nil
      end
      
      it 'the before_filter returns true' do
        controller.send(:run_authentication_method)
          .should be_true
      end 
    end
  end
  
  describe 'finding deliverables' do
    
    context 'when the deliverable is found' do
      
      before do
        do_request(:index)
      end
      
      it 'assigns it to the deliverable method' do
        controller.deliverable
          .should be_a(Page)
      end
    end
    
    context 'when the deliverable is not found' do
      
      before do
        do_request(:index,
          :deliverable_id => 0
        )
      end
      
      it 'renders a 404' do
        response.code.to_i
          .should eq 404
      end
    end
  end
end