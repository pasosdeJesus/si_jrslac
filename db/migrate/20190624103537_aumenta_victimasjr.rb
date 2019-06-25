# encoding: UTF-8

class AumentaVictimasjr < ActiveRecord::Migration[6.0]
  def change
    add_column :sivel2_sjr_victimasjr, :apellidomaterno, :string, limit: 100
    add_column :sivel2_sjr_victimasjr, :nombrenooficial, :string, limit: 100
    add_column :sivel2_sjr_victimasjr, :descripcionsenas, :string, limit: 1000
    add_column :sivel2_sjr_victimasjr, :dependientes, :integer
    add_column :sivel2_sjr_victimasjr, :razon, :string, limit: 1000
  end
end
