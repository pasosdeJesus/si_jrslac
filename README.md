# Cor1440
[![Estado Construcción](https://api.travis-ci.org/pasosdeJesus/cor1440_sjrlac.svg?branch=master)](https://travis-ci.org/pasosdeJesus/cor1440_sjrlac) [![Clima del Código](https://codeclimate.com/github/pasosdeJesus/cor1440_sjrlac/badges/gpa.svg)](https://codeclimate.com/github/pasosdeJesus/cor1440_sjrlac) [![Cobertura de Pruebas](https://codeclimate.com/github/pasosdeJesus/cor1440_sjrlac/badges/coverage.svg)](https://codeclimate.com/github/pasosdeJesus/cor1440_sjrlac) [![security](https://hakiri.io/github/pasosdeJesus/cor1440_sjrlac/master.svg)](https://hakiri.io/github/pasosdeJesus/cor1440_sjrlac/master) [![Dependencias](https://gemnasium.com/pasosdeJesus/cor1440_sjrlac.svg)](https://gemnasium.com/pasosdeJesus/cor1440_sjrlac) 

Sistema para planeación y seguimiento de actividades e informes en el SJR.

### Requerimientos
* Ruby version >= 2.1
* PostgreSQL >= 9.3 con extensión unaccent disponible
* Recomendado sobre adJ 5.6 (que incluye todos los componentes mencionados).  
  Las siguientes instrucciones suponen que opera en este ambiente.

### Arquitectura
Es una aplicación que emplea el motor genérico estilo Pasos de Jesús ```sip```
 https://github.com/pasosdeJesus/sip
y el motor cor1440_gen
 https://github.com/pasosdeJesus/cor1440_gen

### Configuracion, uso, desarrollo

Puede seguir las mismas instrucciones de sivel2:

Los cambios son:

* Al iniciar una nueva aplicación se crea usuario sjrlac con clave
  sjrlac


