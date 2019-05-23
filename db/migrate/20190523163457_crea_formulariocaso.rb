class CreaFormulariocaso < ActiveRecord::Migration[6.0]
  def change
    create_table :formulariocaso do |t|
      t.integer :dominio_id
    end
    add_foreign_key :formulariocaso, :sipd_dominio, column: :dominio_id
  end
end
