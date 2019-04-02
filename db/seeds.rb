# encoding: UTF-8

conexion = ActiveRecord::Base.connection();

# De motores y finalmente de este
motor = ['sip', 'cor1440_gen', 'sal7711_gen', 'sal7711_web', 'sivel2_gen', 'sivel2_sjr', nil]
motor.each do |m|
    Sip::carga_semillas_sql(conexion, m, :cambios)
    Sip::carga_semillas_sql(conexion, m, :datos)
end

# jrslac jrslac
conexion.execute("INSERT INTO public.usuario 
	(nusuario, nombre, email, encrypted_password, password, 
  fechacreacion, created_at, updated_at, rol) 
	VALUES ('jrslac', 'jrslac', 'cor1440@localhost', 
  '$2a$10$MJOUqEhO7/bMc0iFT0xjY.gWtyS456v1UyQ8lgFt4TCdP0xsecVAW',
	'', '2014-08-14', '2014-08-14', '2014-08-14', 1);")


