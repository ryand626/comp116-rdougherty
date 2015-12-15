class AddAttackTypeToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :attack_type, :string
  end
end
