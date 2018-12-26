source 'https://rubygems.org'

# Rails (internacionalización)
gem "rails", '~> 5.2.1'

gem "rails-i18n"

gem 'bootsnap', '>=1.1.0', require: false

gem 'bigdecimal'

# Color en terminal
gem 'colorize'

gem 'puma'

# CSS
gem 'sass'
gem "sass-rails"
gem "font-awesome-rails"

# Cuadros de selección para búsquedas
gem 'chosen-rails'

# Dialogo modal
gem 'lazybox'

# Generación de PDF
gem "prawn"
gem "prawnto_2",  :require => "prawnto"
gem "prawn-table"

# Plantilla ODT
gem "odf-report"


# Plantilla ODS
gem 'rspreadsheet'
gem 'libxml-ruby'
gem 'rubyzip', '~> 1.2'  # Por odf-report al pasar a 1.2 con zip-zip genera mal documento

gem 'redcarpet'
# Postgresql
gem "pg"#, '~> 0.21'

# Maneja variables de ambiente (como claves y secretos) en .env
#gem "foreman"

# API JSON facil. Ver: https://github.com/rails/jbuilder
gem "jbuilder"

# Uglifier comprime recursos Javascript
gem "uglifier"

# CoffeeScript para recuersos .js.coffee y vistas
gem "coffee-rails"

# jquery como librería JavaScript
gem "jquery-rails"

gem "jquery-ui-rails"

# Seguir enlaces más rápido. Ver: https://github.com/rails/turbolinks
gem "turbolinks"

# Ambiente de CSS
gem "twitter-bootstrap-rails"
gem "bootstrap-datepicker-rails"

# Formularios simples 
gem "simple_form"

# Formularios anidados (algunos con ajax)
gem "cocoon", git: "https://github.com/vtamara/cocoon.git", branch: 'new_id_with_ajax'

# Autenticación y roles
gem "devise"
gem "devise-i18n"
gem "cancancan"
gem "bcrypt"

# Listados en páginas
gem "will_paginate"

# ICU con CLDR
gem 'twitter_cldr'

# Maneja adjuntos
gem "paperclip"

# Zonas horarias
gem "tzinfo"

# Motor generico
gem 'sip', git: "https://github.com/pasosdeJesus/sip.git"
#gem 'sip', path: '../sip'

# Motor Cor1440_gen
gem 'sivel2_sjr', git: "https://github.com/pasosdeJesus/sivel2_sjr.git"
#gem "sivel2_sjr", path: '../sivel2_sjr'

  # Motor Cor1440_gen
gem 'sivel2_gen', git: "https://github.com/pasosdeJesus/sivel2_gen.git"
#gem "sivel2_gen", path: '../sivel2_gen'

# Motor Cor1440_gen
gem 'cor1440_gen', git: "https://github.com/pasosdeJesus/cor1440_gen.git"
#gem "cor1440_gen", path: '../cor1440_gen'

# Motor Sal7711_gen
gem 'sal7711_gen', git: "https://github.com/pasosdeJesus/sal7711_gen.git"
#gem "sal7711_gen", path: '../sal7711_gen'

# Motor Sal7711_web
gem 'sal7711_web', git: "https://github.com/pasosdeJesus/sal7711_web.git"
#gem "sal7711_web", path: '../sal7711_web'

# Motor Heb412_gen
gem 'heb412_gen', git: "https://github.com/pasosdeJesus/heb412_gen.git"
#gem 'heb412_gen', path: '../heb412_gen'

# Los siguientes son para desarrollo o para pruebas con generadores
group :development do

  # Consola irb en páginas con excepciones o usando <%= console %> en vistas
  gem 'web-console'
end

group :development, :test do
  # Depurar
  #gem 'byebug'
end

# Los siguientes son para pruebas y no tiene generadores requeridos en desarrollo
group :test do
  
  # Envia resultados de pruebas desde travis a codeclimate
  #gem "codeclimate-test-reporter", require: nil

  # Acelera ejecutando en fondo.  https://github.com/jonleighton/spring
  gem "spring"

  gem 'connection_pool'
  gem 'minitest-reporters'
  gem 'minitest-rails-capybara'
  gem 'poltergeist'
  # Pruebas de regresión que no requieren javascript
  gem 'simplecov'


  # https://www.relishapp.com/womply/rails-style-guide/docs/developing-rails-applications/bundler
  # Lanza programas para examinar resultados
  gem "launchy"

end


group :production do
  # Para despliegue
  gem "unicorn"

  # Requerido por heroku para usar stdout como bitacora
  gem "rails_12factor"
end


