class AmpliaAslegal < ActiveRecord::Migration[5.2]
  def change
    add_column :sivel2_sjr_aslegal, :nivel, :string, limit: 1
  end
end
