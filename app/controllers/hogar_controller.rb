# encoding: UTF-8

class HogarController < Sivel2Gen::HogarController

  def tablasbasicas
    #authorize! :manage, :tablasbasicas
    @ntablas = {}
    ab = ::Ability.new
    ab.tablasbasicas.each { |t|
      puts t[1]
      k = Ability::tb_clase(t)
      if can? :index, k
        n = k.human_attribute_name(t[1].pluralize.capitalize) 
        r = "admin/#{t[1].pluralize}"
        @ntablas[n] = r
      end
    } 
    @ntablasor = @ntablas.keys.localize(:es).sort.to_a
    render layout: 'application'
  end

end
