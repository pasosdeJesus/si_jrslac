#!/bin/sh
# Inicia produccion
if (test "${SECRET_KEY_BASE}" = "") then {
	echo "Definir variable de ambiente SECRET_KEY_BASE"
	exit 1;
} fi;
if (test "${USUARIO_AP}" = "") then {
	echo "Definir usuario con el que se ejecuta en USUARIO_AP"
	exit 1;
} fi;
if (test "${DIRAP}" = "") then {
	echo "Definir directorio con fuentes en DIRAP"
	exit 1;
} fi;

DOAS=`which doas 2> /dev/null`
if (test "$?" != "0") then {
	        DOAS="sudo"
} fi;
$DOAS su ${USUARIO_AP} -c "cd ${DIRAP};  RAILS_ENV=production bin/rails sip:indices; bundle exec rake assets:precompile; echo \"Iniciando unicorn...\"; SECRET_KEY_BASE=${SECRET_KEY_BASE} bundle exec unicorn_rails -c ./config/unicorn.conf.minimal.rb  -E production -D"


  

