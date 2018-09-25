# encoding: UTF-8

class Ability  < Cor1440Gen::Ability

  ROLSIST = 7 # Igul a ROLSISTACT

  BASICAS_PROPIAS = [
    ['', 'poa']
  ]
  def tablasbasicas 
    Sip::Ability::BASICAS_PROPIAS + 
      Cor1440Gen::Ability::BASICAS_PROPIAS +
      Sal7711Gen::Ability::BASICAS_PROPIAS + 
      Sivel2Gen::Ability::BASICAS_PROPIAS + 
      Sivel2Sjr::Ability::BASICAS_PROPIAS + 
      BASICAS_PROPIAS - [
        ['Sip', 'grupo'],
        ['Cor1440Gen', 'proyecto']
      ]
  end

  BASICAS_ID_NOAUTO = []
  def basicas_id_noauto 
    Sip::Ability::BASICAS_ID_NOAUTO +
      Cor1440Gen::Ability::BASICAS_ID_NOAUTO +
      Sal7711Gen::Ability::BASICAS_ID_NOAUTO + BASICAS_ID_NOAUTO 
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
      ["Administrador", ROLADMIN], 
      ["Directivo", ROLDIR], 
      ["Sistematizador", ROLSIST]
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
    'Ver documentos en nube. ' # ROLSIST
  ]

  # Autorizaciones con CanCanCan
  def initialize(usuario = nil)
    # Sin autenticación puede consultarse información geográfica 
    can :read, [Sip::Pais, Sip::Departamento, Sip::Municipio, Sip::Clase]
    if !usuario || usuario.fechadeshabilitacion
      return
    end
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
      when Ability::ROLSIST
        can :manage, Cor1440Gen::Actividad
        can :manage, Cor1440Gen::Informe
        can :read, Cor1440Gen::Proyectofinanciero

        can :read, Heb412Gen::Doc
        can :read, Heb412Gen::Plantilladoc
        can :read, Heb412Gen::Plantillahcm
        can :read, Heb412Gen::Plantillahcr

        can :manage, Sivel2Gen::Acto
        can :read, Sivel2Gen::Caso
        can :new, Sivel2Gen::Caso
        can [:update, :create, :destroy, :edit], Sivel2Gen::Caso#,
          #casosjr: { oficina_id: usuario.oficina_id }

      when Ability::ROLADMIN,Ability::ROLDIR
        can :manage, ::Usuario

        can :manage, Cor1440Gen::Actividad
        can :manage, Cor1440Gen::Informe
        can :manage, Cor1440Gen::Proyectofinanciero

        can :manage, Heb412Gen::Doc
        can :manage, Heb412Gen::Plantilladoc
        can :manage, Heb412Gen::Plantillahcm
        can :manage, Heb412Gen::Plantillahcr

        can :manage, Sal7711Gen::Articulo

        can :manage, Sip::Respaldo7z

        can :manage, Sivel2Gen::Caso
        can :manage, Sivel2Gen::Acto

        can :manage, :tablasbasicas
        tablasbasicas.each do |t|
          c = Ability.tb_clase(t)
          can :manage, c
        end
      end
    end
  end

end

