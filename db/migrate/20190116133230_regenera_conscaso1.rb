class RegeneraConscaso1 < ActiveRecord::Migration[5.2]
  def up
    execute <<-SQL
      DROP VIEW sivel2_gen_conscaso1 CASCADE;
    SQL
  end

  def down
  end
end
