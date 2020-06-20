source 'https://rubygems.org'

gem 'bcrypt'

gem 'bootsnap', '>=1.1.0', require: false

gem 'cancancan'

# Formularios anidados (algunos con ajax)
gem 'cocoon', 
  git: 'https://github.com/vtamara/cocoon.git', branch: 'new_id_with_ajax'
  #path: '../cocoon'

gem 'coffee-rails' , '>= 5.0.0' # CoffeeScript para recuersos .js.coffee y vistas

gem 'devise' , '>= 4.7.2' # Autenticación 

gem 'devise-i18n', '>= 1.9.1'

gem 'jbuilder' # API JSON facil. Ver: https://github.com/rails/jbuilder

gem 'jquery-ui-rails', '>= 6.0.1'

gem 'lazybox' # Dialogo modal

gem 'libxml-ruby'

gem 'odf-report' # Genera ODT

gem 'paperclip' # Maneja adjuntos

gem 'pg' # Postgresql

gem 'prawn' # Generación de PDF

gem 'prawnto_2', '>= 0.3.0', :require => 'prawnto'

gem 'prawn-table'

gem 'puma'

gem 'rails', '~> 6.0.3', '>= 6.0.3.2'

gem 'rails-i18n', '>= 6.0.0'

gem 'redcarpet' # Markdown

gem 'rspreadsheet' # Genera ODS

gem 'rubyzip', '>= 2.0'

gem 'sassc-rails' , '>= 2.1.2' # CSS

gem 'simple_form' , '>= 5.0.2' # Formularios simples 

gem 'twitter_cldr' # ICU con CLDR

gem 'tzinfo' # Zonas horarias

gem 'webpacker', '>= 5.1.1'

gem 'will_paginate' # Listados en páginas


#####
# Motores que se sobrecargan vistas (deben ponerse en orden de apilamiento 
# lógico y no alfabetico como las gemas anteriores)

gem 'sip', # Motor generico
  git: 'https://github.com/pasosdeJesus/sip.git'
  #path: '../sip'

gem 'mr519_gen', # Motor de gestion de formularios y encuestas
  git: 'https://github.com/pasosdeJesus/mr519_gen.git'
  #path: '../mr519_gen'

gem 'heb412_gen',  # Motor de nube y llenado de plantillas
  git: 'https://github.com/pasosdeJesus/heb412_gen.git'
  #path: '../heb412_gen'

gem 'sal7711_gen', # Motor para archivo de prensa
  git: 'https://github.com/pasosdeJesus/sal7711_gen.git'
  #path: '../sal7711_gen'

gem 'sal7711_web', # Motor para archivo de prensa
  git: 'https://github.com/pasosdeJesus/sal7711_web.git'
  #path: '../sal7711_web'

gem 'cor1440_gen',  # Motor de proyectos con marco lógico y actividades 
  git: 'https://github.com/pasosdeJesus/cor1440_gen.git'
   #path: '../cor1440_gen'

gem 'sivel2_gen',  # Motor de casos
  git: 'https://github.com/pasosdeJesus/sivel2_gen.git'
  #path: '../sivel2_gen'

gem 'sivel2_sjr',  # Motor de atención a casos
  git: 'https://github.com/pasosdeJesus/sivel2_sjr.git'
  #path: '../sivel2_sjr'


group :development do

  gem 'colorize'

  gem 'web-console', '>= 4.0.2'

end


group :development, :test do
  
  #gem 'byebug' # Depurar
  
end


group :test do

  gem 'capybara'
  
  gem 'simplecov'

end


group :production do
  
  gem 'unicorn' # Para despliegue

end


