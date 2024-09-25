class AddDivisionToMissions < ActiveRecord::Migration[7.0]
  def change
    add_reference :missions, :division, foreign_key: true, default: 0
  end
end
