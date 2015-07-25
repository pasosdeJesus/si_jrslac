# encoding: UTF-8

class Ability  < Cor1440Gen::Ability

  BASICAS_PROPIAS = [
    ['', 'poa']
  ]
  @@tablasbasicas = Sip::Ability::BASICAS_PROPIAS + 
    Cor1440Gen::Ability::BASICAS_PROPIAS +
    Sal7711Gen::Ability::BASICAS_PROPIAS + 
    BASICAS_PROPIAS 

  BASICAS_ID_NOAUTO = []
  @@basicas_id_noauto = Sip::Ability::BASICAS_ID_NOAUTO +
    Cor1440Gen::Ability::BASICAS_ID_NOAUTO +
    Sal7711Gen::Ability::BASICAS_ID_NOAUTO + BASICAS_ID_NOAUTO 
  
  NOBASICAS_INDSEQID = []
  @@nobasicas_indice_seq_con_id = Sip::Ability::NOBASICAS_INDSEQID +
    Cor1440Gen::Ability::NOBASICAS_INDSEQID +
    Sal7711Gen::Ability::NOBASICAS_INDSEQID + NOBASICAS_INDSEQID

  BASICAS_PRIO = []
  @@tablasbasicas_prio = Sip::Ability::BASICAS_PRIO +
    Cor1440Gen::Ability::Ability::BASICAS_PRIO +
    Sal7711Gen::Ability::BASICAS_PRIO + BASICAS_PRIO


  # Ver documentacion de este metodo en app/models/ability de sip
  def initialize(usuario)
    # Sin autenticación puede consultarse información geográfica 
    can :read, [Sip::Pais, Sip::Departamento, Sip::Municipio, Sip::Clase]
    if !usuario || usuario.fechadeshabilitacion
      return
    end
    can :contar, Sip::Ubicacion
    can :buscar, Sip::Ubicacion
    can :lista, Sip::Ubicacion
    can :descarga_anexo, Sip::Anexo
    can :nuevo, Cor1440Gen::Actividad
    can :nuevo, Sip::Ubicacion
    if !usuario.nil? && !usuario.rol.nil? then
      case usuario.rol 
      when Ability::ROLSISTACT
        can :read, Cor1440Gen::Actividad
        can :read, Cor1440Gen::Informe
        can :new, Cor1440Gen::Actividad
        can [:update, :create, :destroy], Cor1440Gen::Actividad, 
          oficina: { id: usuario.oficina_id}
      when Ability::ROLCOOR
        can :read, Cor1440Gen::Actividad
        can :new, Cor1440Gen::Actividad
        can [:update, :create, :destroy], Cor1440Gen::Actividad, 
          oficina: { id: usuario.oficina_id}
        can [:new, :update, :create, :destroy], Cor1440Gen::Informe
        can :new, Usuario
        can [:read, :manage], Usuario, oficina: { id: usuario.oficina_id}
      when Ability::ROLINV
        cannot :buscar, Cor1440Gen::Actividad
        can :read, Cor1440Gen::Actividad
      when Ability::ROLADMIN,Ability::ROLDIR
        can :manage, Cor1440Gen::Actividad
        can :manage, Cor1440Gen::Informe
        can :manage, Sal7711Gen::Articulo
        can :manage, Usuario
        can :manage, :tablasbasicas
        @@tablasbasicas.each do |t|
          c = Ability.tb_clase(t)
          can :manage, c
        end
      end
    end
  end

end

