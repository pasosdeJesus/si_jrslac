# encoding: UTF-8

class Ability  < Sipd::Ability

  ROLDIR = 3
  ROLOP = 7 # Igual a ROLSISTACT
  ROLSUPERADMIN = 8
  ROLDESARROLLADOR = 9

  BASICAS_PROPIAS = [
    ['', 'factorvulnerabilidad'],
    ['', 'poa']
  ]
  def tablasbasicas 
    Sip::Ability::BASICAS_PROPIAS + 
      Cor1440Gen::Ability::BASICAS_PROPIAS +
      Sal7711Gen::Ability::BASICAS_PROPIAS + 
      Sivel2Gen::Ability::BASICAS_PROPIAS + 
      Sivel2Sjr::Ability::BASICAS_PROPIAS + 
      BASICAS_PROPIAS - [
        ['Cor1440Gen', 'proyecto'],
        ['Sivel2Sjr', 'ayudaestado'],
        ['Sivel2Sjr', 'clasifdesp'],
        ['Sivel2Sjr', 'declaroante']
      ]
  end

  BASICAS_ID_NOAUTO = []
  def basicas_id_noauto 
    Sip::Ability::BASICAS_ID_NOAUTO +
      Sivel2Gen::Ability::BASICAS_ID_NOAUTO + 
      Sivel2Sjr::Ability::BASICAS_ID_NOAUTO + 
      Cor1440Gen::Ability::BASICAS_ID_NOAUTO +
      Sal7711Gen::Ability::BASICAS_ID_NOAUTO + 
      BASICAS_ID_NOAUTO 
  end

  NOBASICAS_INDSEQID = []
  def nobasicas_indice_seq_con_id 
    Sip::Ability::NOBASICAS_INDSEQID +
      Cor1440Gen::Ability::NOBASICAS_INDSEQID +
      Sal7711Gen::Ability::NOBASICAS_INDSEQID + 
      Sivel2Gen::Ability::NOBASICAS_INDSEQID + 
      Sivel2Sjr::Ability::NOBASICAS_INDSEQID + 
      NOBASICAS_INDSEQID
  end

  BASICAS_PRIO = []
  def tablasbasicas_prio 
    Sip::Ability::BASICAS_PRIO +
      Cor1440Gen::Ability::BASICAS_PRIO +
      Sivel2Gen::Ability::BASICAS_PRIO +
      Sivel2Sjr::Ability::BASICAS_PRIO +
      Sal7711Gen::Ability::BASICAS_PRIO + BASICAS_PRIO
  end

  ROLES = [
      ["Desarrollador", ROLDESARROLLADOR], 
      ["Superadministrador", ROLSUPERADMIN], 
      ["Administrador", ROLADMIN], 
      ["Directivo", ROLDIR], 
      ["Operador", ROLOP]
  ]

  ROLES_CA = [
    'Administrar actividades e informes. ' +
    'Administrar convenios financiados. ' +
    'Administrar artículos del archivo de prensa. ' +
    'Administrar documentos en nube. ' +
    'Administrar usuarios. ' + 
    'Administrar respaldos. ' + 
    'Administrar tablas básicas. ', #ROLADMIN, 1

    '', # 2
 
    'Administrar actividades e informes. ' +
    'Administrar convenios financiados. ' +
    'Administrar artículos del archivo de prensa. ' +
    'Administrar documentos en nube. ' +
    'Administrar usuarios. ' + 
    'Administrar respaldos. ' + 
    'Administrar tablas básicas. ', #ROLDIR, 3

    '', # 4
    '', # 5
    '', # 6

    'Administrar actividades. ' +
    'Ver convenios financiados. ' +
    'Ver artículos del archivo de prensa. ' +
    'Ver documentos en nube. ', # ROLOP
    'Los mismos de los administradores en cualquier dominio. ' +
    'Crear copias de respaldo cifradas. ' +
    'Administrar usuarios de cualquier dominio. ' +
    'Administrar datos de tablas basicas de cualquier dominio. ' +
    'Administrar actores sociales y personas de cualquier dominio. ', #8
    'Los mismos del superadministrador' #9
  ]

  # Autorizaciones con CanCanCan
  def initialize(usuario = nil)
    # Sin autenticación puede consultarse información geográfica 
    can :read, [Sip::Pais, Sip::Departamento, Sip::Municipio, Sip::Clase]
    if !usuario || usuario.fechadeshabilitacion
      return
    end
    can :read, Sip::Actorsocial, dominio: { id: usuario.dominio_ids}
    can :read, Sip::Persona, dominio: { id: usuario.dominio_ids}
    can :contar, Sip::Ubicacion
    can :buscar, Sip::Ubicacion
    can :lista, Sip::Ubicacion

    can :contar, Sivel2Gen::Caso
    can :buscar, Sivel2Gen::Caso
    can :lista, Sivel2Gen::Caso
    can :nuevo, Sivel2Gen::Presponsable
    can :nuevo, Sivel2Gen::Victima

    can :nuevo, Sivel2Sjr::Desplazamiento
    can :nuevo, Sivel2Sjr::Respuesta

    if !usuario.nil? && !usuario.rol.nil? then
      can :descarga_anexo, Sip::Anexo
      can :nuevo, Cor1440Gen::Actividad
      can :nuevo, Sip::Ubicacion
      case usuario.rol 
      when Ability::ROLOP
        can :manage, Cor1440Gen::Actividad
        can :manage, Cor1440Gen::Informe
        can :read, Cor1440Gen::Proyectofinanciero

        can :read, Heb412Gen::Doc
        can :read, Heb412Gen::Plantilladoc
        can :read, Heb412Gen::Plantillahcm
        can :read, Heb412Gen::Plantillahcr
        
        can :manage, Sal7711Gen::Articulo

        can :new, Sip::Actorsocial
        can [:read, :create, :edit, :update], Sip::Actorsocial, 
          dominio: { id: usuario.dominio_ids}
        # Restricciones para nuevos/editar en modelo y controlador
        can :new, Sip::Persona
        can [:read, :create, :edit, :update], Sip::Persona, 
          dominio: { id: usuario.dominio_ids}
        # Restricciones para nuevos/editar en modelo y controlador

        can :manage, Sivel2Gen::Acto
        can :manage, Sivel2Gen::Caso
        can :manage, Sivel2Sjr::Casosjr
        #can :new, Sivel2Gen::Caso
        #can [:update, :create, :destroy, :edit], Sivel2Gen::Caso#,
          #casosjr: { oficina_id: usuario.oficina_id }

      when Ability::ROLADMIN,Ability::ROLDIR
        can :menu, ::Usuario
        can :new, ::Usuario
        can :manage, ::Usuario, dominio: { id: usuario.dominio_ids}

       
        can :manage, Cor1440Gen::Actividad
        can :manage, Cor1440Gen::Informe
        can :manage, Cor1440Gen::Proyectofinanciero

        can :manage, Heb412Gen::Doc
        can :manage, Heb412Gen::Plantilladoc
        can :manage, Heb412Gen::Plantillahcm
        can :manage, Heb412Gen::Plantillahcr

        can :manage, Sal7711Gen::Articulo

        can :new, Sip::Actorsocial
        can :manage, Sip::Actorsocial, dominio: { id: usuario.dominio_ids}
        # Las restricciones para nuevos y edición en modelo con validate
        # y en controlador con validaciones
        can :new, Sip::Grupo
        can :manage, Sip::Grupo, dominio: { id: usuario.dominio_ids}
        can :new, Sip::Persona
        can :manage, Sip::Persona, dominio: { id: usuario.dominio_ids}
        # Las restricciones para nuevos y edición en modelo con validate
        # y en controlador con validaciones

        can :read, Sipd::Dominio

        can :manage, Sivel2Gen::Caso
        can :manage, Sivel2Gen::Acto

        can :manage, :tablasbasicas
        t = tablasbasicas - [['Sip', 'grupo']]
        t.each do |t|
          c = Ability.tb_clase(t)
          can :manage, c
        end

      when Ability::ROLSUPERADMIN, Ability::ROLDESARROLLADOR
        can :manage, ::Usuario

        can :manage, Cor1440Gen::Actividad
        can :manage, Cor1440Gen::Informe
        can :manage, Cor1440Gen::Proyectofinanciero

        can :manage, Heb412Gen::Doc
        can :manage, Heb412Gen::Plantilladoc
        can :manage, Heb412Gen::Plantillahcm
        can :manage, Heb412Gen::Plantillahcr

        can :manage, Sal7711Gen::Articulo

        can :manage, Sip::Actorsocial
        can :manage, Sip::Persona

        can :manage, Sivel2Gen::Caso
        can :manage, Sivel2Gen::Acto

        can :manage, :tablasbasicas
        tablasbasicas.each do |t|
          c = Ability.tb_clase(t)
          can :manage, c
        end
        can :manage, Sipd::Dominio
        can :manage, Sip::Respaldo7z
      end
    end
  end

end

