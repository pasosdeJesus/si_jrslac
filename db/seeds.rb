# encoding: UTF-8

conexion = ActiveRecord::Base.connection();

# De motores y finalmente de este
motor = ['sip', 'cor1440_gen', 'sal7711_gen', 'sal7711_web', nil]
motor.each do |m|
    Sip::carga_semillas_sql(conexion, m, :cambios)
    Sip::carga_semillas_sql(conexion, m, :datos)
end

# cor1440, cor1440
conexion.execute("INSERT INTO usuario 
	(nusuario, nombre, email, encrypted_password, password, 
  fechacreacion, created_at, updated_at, rol) 
	VALUES ('sjrlac', 'sjrlac', 'cor1440@localhost', 
	'$2a$10$jMRQtFukTd/i00nt7RBcCe5rQ.2.0nFeVNjtXvJOPQBmF6la8ft4m',
	'', '2014-08-14', '2014-08-14', '2014-08-14', 1);")


