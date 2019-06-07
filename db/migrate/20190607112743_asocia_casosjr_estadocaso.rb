class AsociaCasosjrEstadocaso < ActiveRecord::Migration[6.0]
  def change
    add_column :sivel2_sjr_casosjr, :estadocaso_id, :integer, null: false, default: 1
    add_foreign_key :sivel2_sjr_casosjr, :estadocaso
  end
end
