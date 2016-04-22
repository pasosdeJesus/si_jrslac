
Sip.setup do |config|
      config.ruta_anexos = "/var/www/resbase/cor1440/"
      config.ruta_volcados = "/var/www/resbase/cor1440_sjrlac/"
      # En heroku los anexos son super-temporales
      if ENV["HEROKU_POSTGRESQL_MAUVE_URL"]
        config.ruta_anexos = "#{Rails.root}/tmp/"
      end
      config.titulo = "Cor1440 SJR " + Cor1440Gen::VERSION
end
