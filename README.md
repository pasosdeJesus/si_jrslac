# SI JRSLAC
[![Estado Construcción](https://api.travis-ci.org/pasosdeJesus/si_jrslac.svg?branch=master)](https://travis-ci.org/pasosdeJesus/si_jrslac) [![Clima del Código](https://codeclimate.com/github/pasosdeJesus/si_jrslac/badges/gpa.svg)](https://codeclimate.com/github/pasosdeJesus/si_jrslac) [![Cobertura de Pruebas](https://codeclimate.com/github/pasosdeJesus/si_jrslac/badges/coverage.svg)](https://codeclimate.com/github/pasosdeJesus/si_jrslac) [![security](https://hakiri.io/github/pasosdeJesus/si_jrslac/master.svg)](https://hakiri.io/github/pasosdeJesus/si_jrslac/master) [![Dependencias](https://gemnasium.com/pasosdeJesus/si_jrslac.svg)](https://gemnasium.com/pasosdeJesus/si_jrslac) 

Proyectos, actividades, casos, seguimiento y monitoreo en JRS LAC.


### Requerimientos
* Ruby version >= 2.5
* PostgreSQL >= 10.5 con extensión unaccent disponible
* Recomendado sobre adJ 6.3 (que incluye todos los componentes mencionados).  
  Las siguientes instrucciones suponen que opera en este ambiente.

### Arquitectura
Es una aplicación que se basa en el motor `sivel2_sjr` https://github.com/pasosdeJesus/sivel2_sjr que a su vez emplea los motores:
- `cor1440_gen` Motor para proyectos y actividades https://github.com/pasosdeJesus/cor1440_gen
- `heb412_gen` Motor para gestionar nube y generación de reportes en hojas de cálculo y documentos https://github.com/pasosdeJesus/heb412_gen
- `sal7711_web` Archivo de noticias https://github.com/pasosdeJesus/sal7711_web

Todos estos a su vez emplean:
- `sip` Motor genérico estilo Pasos de Jesús https://github.com/pasosdeJesus/sip
cor1440_gen

### Configuracion, uso, desarrollo

Puede seguir las mismas instrucciones de sivel2:
  https://github.com/pasosdeJesus/sivel2/blob/master/README.md


Los cambios son:

* Al iniciar una nueva aplicación se crea usuario sjrlac con clave
  sjrlac


