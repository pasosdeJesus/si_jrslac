source 'https://rubygems.org'

gem 'bcrypt'

gem 'bootsnap', '>=1.1.0', require: false

gem 'bootstrap-datepicker-rails'

gem 'cancancan'

gem 'chosen-rails', git: 'https://github.com/vtamara/chosen-rails.git', branch: 'several-fixes' # Cuadros de selección para búsquedas

# Formularios anidados (algunos con ajax)
gem 'cocoon', git: 'https://github.com/vtamara/cocoon.git', branch: 'new_id_with_ajax'
#gem 'cocoon', path: '../cocoon'

gem 'coffee-rails' # CoffeeScript para recuersos .js.coffee y vistas

# Color en terminal
gem 'colorize'

gem 'devise' # Autenticación 

gem 'devise-i18n'

gem 'font-awesome-rails'

gem 'jbuilder' # API JSON facil. Ver: https://github.com/rails/jbuilder

gem 'jquery-rails' # jquery como librería JavaScript

gem 'jquery-ui-rails'

gem 'lazybox' # Dialogo modal

gem 'libxml-ruby'

gem 'odf-report' # Genera ODT

gem 'paperclip' # Maneja adjuntos

gem 'pg' # Postgresql

gem 'pick-a-color-rails' # Facilita elegir colores en tema

gem 'prawn' # Generación de PDF

gem 'prawnto_2',  :require => 'prawnto'

gem 'prawn-table'

gem 'puma'

gem 'rails', '~> 6.0.0.rc1' 

gem 'rails-i18n'

gem 'redcarpet' # Markdown

gem 'rspreadsheet' # Genera ODS

gem 'rubyzip', '>= 2.0'

gem 'sass-rails' # CSS

gem 'simple_form' # Formularios simples 

gem 'tiny-color-rails'

gem 'turbolinks' # Seguir enlaces más rápido. 

gem 'twitter-bootstrap-rails' # Ambiente de CSS

gem 'twitter_cldr' # ICU con CLDR

gem 'tzinfo' # Zonas horarias

gem 'uglifier' # Uglifier comprime recursos Javascript

gem 'webpacker'

gem 'will_paginate' # Listados en páginas


#####
# Motores que se sobrecargan vistas (deben ponerse en orden de apilamiento 
# lógico y no alfabetico como las gemas anteriores)

gem 'sip', # Motor generico
  git: 'https://github.com/pasosdeJesus/sip.git'
#gem 'sip', path: '../sip'

gem 'mr519_gen', # Motor de gestion de formularios y encuestas
  git: 'https://github.com/pasosdeJesus/mr519_gen.git'
#gem 'mr519_gen', path: '../mr519_gen'

gem 'heb412_gen',  # Motor de nube y llenado de plantillas
  git: 'https://github.com/pasosdeJesus/heb412_gen.git'
#gem 'heb412_gen', path: '../heb412_gen'

gem 'sal7711_gen', # Motor para archivo de prensa
  git: 'https://github.com/pasosdeJesus/sal7711_gen.git'
#gem 'sal7711_gen', path: '../sal7711_gen'

gem 'sal7711_web', # Motor para archivo de prensa
  git: 'https://github.com/pasosdeJesus/sal7711_web.git'
#gem 'sal7711_web', path: '../sal7711_web'

gem 'cor1440_gen',  # Motor de proyectos con marco lógico y actividades 
  git: 'https://github.com/pasosdeJesus/cor1440_gen.git'
#gem 'cor1440_gen', path: '../cor1440_gen'

gem 'sivel2_gen',  # Motor de casos
  git: 'https://github.com/pasosdeJesus/sivel2_gen.git'
#gem 'sivel2_gen', path: '../sivel2_gen'

gem 'sivel2_sjr',  # Motor de atención a casos
  git: 'https://github.com/pasosdeJesus/sivel2_sjr.git'
#gem 'sivel2_sjr', path: '../sivel2_sjr'


group :development do

  gem 'web-console'

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


