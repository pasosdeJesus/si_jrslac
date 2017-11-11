
Rails.application.routes.draw do

  devise_scope :usuario do
    get 'sign_out' => 'devise/sessions#destroy'

    # El siguiente para superar mala generación del action en el formulario
    # cuando se autentica mal (genera 
    # /puntomontaje/puntomontaje/usuarios/sign_in )
    if (Rails.configuration.relative_url_root != '/') 
      ruta = File.join(Rails.configuration.relative_url_root, 
                       'usuarios/sign_in')
      post ruta, to: 'devise/sessions#create'
    end
  end
  devise_for :usuarios, :skip => [:registrations], module: :devise
    as :usuario do
          get 'usuarios/edit' => 'devise/registrations#edit', 
            :as => 'editar_registro_usuario'    
          put 'usuarios/:id' => 'devise/registrations#update', 
            :as => 'registro_usuario'            
  end
  resources :usuarios, path_names: { new: 'nuevo', edit: 'edita' } 

  get "/actividadespf/" => "cor1440_gen/proyectosfinancieros#actividadespf", 
    as: :actividadespf
  get "/informes/:id/impreso" => "cor1440_gen/informes#impreso", 
    as: :impresion

  resources :objetivospf, only: [:new, :destroy]
  resources :resultadospf, only: [:new, :destroy]
  resources :indicadorespf, only: [:new, :destroy]
  resources :actividadespf, only: [:new, :destroy]

  namespace :admin do
    ab = ::Ability.new
    ab.tablasbasicas.each do |t|
      if (t[0] == "") 
        c = t[1].pluralize
        resources c.to_sym, 
          path_names: { new: 'nueva', edit: 'edita' }
      end
    end
  end
  
  root 'sip/hogar#index'
  mount Sip::Engine, at: "/", as: 'sip'
  mount Cor1440Gen::Engine, at: "/", as: 'cor1440_gen'
  mount Sal7711Gen::Engine, at: "/", as: 'sal7711_gen'
  mount Sal7711Web::Engine, at: "/", as: 'sal7711_web'
  mount Heb412Gen::Engine,  at: "/", as: 'heb412_gen'
end
