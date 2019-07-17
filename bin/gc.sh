#!/bin/sh
# Revisa errore comunes, ejecuta pruebas de regresión y del sistema y envia a github 

function cableado {
	for n in $*; do 
		echo "Revisando $n"
		grep "^ *gem *.${n}.*, *path:" Gemfile > /dev/null 2> /dev/null
		if (test "$?" = "0") then {
			echo "Gemfile incluye un ${n} cableado al sistema de archivos"
			exit 1;
		} fi;
	done
}

cableado sip mr519_gen heb412_gen cor1440_gen sal7711_gen sal7711_web

grep "^ *gem *.debugger*" Gemfile > /dev/null 2> /dev/null
if (test "$?" = "0") then {
	echo "Gemfile incluye debugger"
	exit 1;
} fi;
grep "^ *gem *.byebug*" Gemfile > /dev/null 2> /dev/null
if (test "$?" = "0") then {
	echo "Gemfile incluye byebug que rbx de travis-ci no quiere"
	exit 1;
} fi;

if (test "$SINAC" != "1") then {
	NOKOGIRI_USE_SYSTEM_LIBRARIES=1 MAKE=gmake make=gmake QMAKE=qmake4 bundle update
	if (test "$?" != "0") then {
		exit 1;
	} fi;
	CXX=c++ yarn upgrade
	if (test "$?" != "0") then {
		exit 1;
	} fi;
} fi;
if (test "$SININS" != "1") then {
	NOKOGIRI_USE_SYSTEM_LIBRARIES=1 MAKE=gmake make=gmake QMAKE=qmake4 bundle install
	if (test "$?" != "0") then {
		exit 1;
	} fi;
	CXX=c++ yarn install
	if (test "$?" != "0") then {
		exit 1;
	} fi;
} fi;
if (test "$SINMIG" != "1") then {
	(bin/rails db:migrate sip:indices db:structure:dump)
	if (test "$?" != "0") then {
		exit 1;
	} fi;
} fi;

RAILS_ENV=test bin/rails db:drop db:setup; RAILS_ENV=test bin/rails db:migrate sip:indices
if (test "$?" != "0") then {
	echo "No puede preparse base de prueba";
	exit 1;
} fi;

CONFIG_HOSTS=127.0.0.1 bin/rails test
if (test "$?" != "0") then {
	echo "No pasaron pruebas de regresión";
	exit 1;
} fi;

RAILS_ENV=test bin/rails db:structure:dump
b=`git branch | grep "^*" | sed -e  "s/^* //g"`
git status -s
if (test "$MENSCONS" = "") then {
	MENSCONS="Actualiza"
} fi;
git commit -m "$MENSCONS" -a
git push origin ${b}
if (test "$?" != "0") then {
	echo "No pudo subirse el cambio a github";
	exit 1;
} fi;

