require 'spec_helper' 

describe Transit::TemplatesController, :type => :controller do
  
  before do
    Transit::TemplatesController
      .any_instance.stub(
        :authenticate_admin! => true
      )
  end
  
  describe 'GET #show' do
    
    before do
      get :show, :id => 'audio'
    end
    
    it 'renders the context template' do
      response.should(
        render_template('audio/show')
      )
    end
  end
  
  describe 'GET #manage' do
    
    before do
      get :manage, :id => 'audio'
    end
    
    it 'renders the manage template' do
      response.should(
        render_template('audio/manage')
      )
    end
  end
end