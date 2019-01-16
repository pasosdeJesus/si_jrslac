class AmpliaChequeoOrientacionsexual < ActiveRecord::Migration[5.2]
  def up
    execute <<-SQL
      ALTER TABLE sivel2_gen_victima DROP CONSTRAINT "victima_orientacionsexual_check";
    SQL
  end
  def down
  end
end
