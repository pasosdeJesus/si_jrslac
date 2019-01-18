# encoding: UTF-8

conexion = ActiveRecord::Base.connection();

conexion.execute("INSERT INTO sipd_dominio (id, dominio, mandato,
                   created_at, updated_at) VALUES (1, 'si.sjrlac.info',
                     'Tecnología con misión', '2018-11-27', '2018-11-27');")
conexion.execute("INSERT INTO sipd_dominio (id, dominio, mandato,
                   created_at, updated_at) VALUES (2, 'mexico.sjrlac.info',
                     'Tecnología con misión', '2018-11-27', '2018-11-27');")


# De motores y finalmente de este
motor = ['sip', 'cor1440_gen', 'sal7711_gen', 'sal7711_web', 'sivel2_gen', 'sivel2_sjr', nil]
motor.each do |m|
    Sip::carga_semillas_sql(conexion, m, :cambios)
    Sip::carga_semillas_sql(conexion, m, :datos)
end
#sipd sipd
conexion.execute("INSERT INTO usuario 
	(nusuario, email, encrypted_password, password, 
  fechacreacion, created_at, updated_at, rol) 
	VALUES ('sipd', 'sipd@localhost', 
  '$2a$10$tiVS67LKV97VUZ83a3rrkOA.zpBV4HDLvq7L2IfkP2vr6itef4N8O', '',
	'2018-11-28', '2018-11-28', '2018-11-28', 8);")
# jrslac jrslac
conexion.execute("INSERT INTO usuario 
	(nusuario, nombre, email, encrypted_password, password, 
  fechacreacion, created_at, updated_at, rol) 
	VALUES ('jrslac', 'jrslac', 'jrslac@localhost', 
  '$2a$10$jMRQtFukTd/i00nt7RBcCe5rQ.2.0nFeVNjtXvJOPQBmF6la8ft4m',
	'', '2014-08-14', '2014-08-14', '2014-08-14', 1);")
#jrsmex jrsmex
conexion.execute("INSERT INTO usuario 
	(nusuario, nombre, email, encrypted_password, password, 
  fechacreacion, created_at, updated_at, rol) 
	VALUES ('jrsmex', 'jrsmex', 'jrsmex@localhost', 
  '$2a$10$DQK3kXQGCkmiz/HnwertB.kPQwJQ9ZhnMQQvXGGgSiKBJmSsQdeFm',
	'', '2014-08-14', '2014-08-14', '2014-08-14', 1);")



