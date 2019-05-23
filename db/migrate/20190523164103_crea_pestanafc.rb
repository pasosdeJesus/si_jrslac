class CreaPestanafc < ActiveRecord::Migration[6.0]
  def change
    create_table :pestanafc do |t|
      t.integer :formulariocaso_id
      t.string :titulo, limit: 63
      t.string :parcial, limit: 63
    end
    add_foreign_key :pestanafc, :formulariocaso
  end
end
