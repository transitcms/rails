require 'spec_helper' 

describe 'TransitController', :type => :controller do 
  
  controller(TransitController) do
    def index
      render text: ''
    end
  end
  
  before do
    TransitController
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
  
  describe 'running authentication methods' do
    
    context 'when the method is configured' do
      
      it 'calls the method' do
        controller.should_receive(method)
          .once
        get :index, :format => :json
      end 
    end
    
    context 'when the method is nil' do
      
      let!(:method) do
        nil
      end
      
      it 'the before_filter returns true' do
        controller.send(
          :run_authentication_method
        ).should be_true
      end 
    end
  end
end