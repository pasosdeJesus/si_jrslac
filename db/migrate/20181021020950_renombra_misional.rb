class RenombraMisional < ActiveRecord::Migration[5.2]
  def up
    execute <<-SQL
      UPDATE cor1440_gen_proyectofinanciero SET nombre='PLAN TRIENAL 2018-2022' WHERE id=10;
    SQL
  end
end
