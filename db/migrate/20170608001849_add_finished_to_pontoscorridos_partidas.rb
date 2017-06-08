class AddFinishedToPontoscorridosPartidas < ActiveRecord::Migration[5.0]
  def change
    add_column :pontoscorridos_partidas, :finished, :boolean
  end
end
