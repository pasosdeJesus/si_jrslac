class AgregaGenero < ActiveRecord::Migration[5.2]
  def up
    add_column :sivel2_gen_victima, :genero, :string, limit: 1, default: 'S'
    execute <<-SQL
      UPDATE sivel2_gen_victima SET genero=sip_persona.sexo 
      FROM sip_persona 
      WHERE id_persona=sip_persona.id;
    SQL
  end

  def down
    drop_column :sivel2_gen_victima, :genero
  end
end
