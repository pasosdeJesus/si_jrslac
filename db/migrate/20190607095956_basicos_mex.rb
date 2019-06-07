# encoding: utf-8

class BasicosMex < ActiveRecord::Migration[6.0]
  def up
    execute <<-SQL
      UPDATE pestanafc
        SET parcial='basicos_mex' WHERE parcial='basicos'
        AND formulariocaso_id=1;
    SQL
  end

  def down
    execute <<-SQL
      UPDATE pestanafc
        SET parcial='basicos' WHERE parcial='basicos_mex'
        AND formulariocaso_id=1;
    SQL
  end
end
