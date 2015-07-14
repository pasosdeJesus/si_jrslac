# encoding: UTF-8

class Ability  < Cor1440Gen::Ability

  @@tablasbasicas += Sal7711Gen::Ability::BASICAS_NUEVAS + [
    ['', 'poa']
  ]

  @@basicas_seq_con_id += Sal7711Gen::Ability::BASICAS_SID_NUEVAS + [
    ['', 'poa']
  ]

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

