Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  ### Health check ###
  # /health-check
  get '/health-check', to: 'health_check#index'

  ### Committee prototype ###
  scope '/committee-prototype', as: 'committees_prototype' do
    get '/',        to: 'committee_prototype#index'
    get '/current', to: 'committee_prototype#current'
  end

  scope '/committee-prototype', as: 'committee_prototype' do
    scope '/:committee_id' do
      get '/', to: 'committee_prototype#show'

      scope '/inquiries' do
        get '/', to: 'committee_prototype/inquiries#index'
        get '/:inquiry_id', to: 'committee_prototype/inquiries#show'
      end
    end
  end
end
