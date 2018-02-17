class CreateUniques < ActiveRecord::Migration[5.1]
  def change
    create_table :uniques do |t|
      t.string :name
      t.string :base_name
      t.string :type

      # Requirements
      t.integer :required_int
      t.integer :required_dex
      t.integer :required_str
      t.integer :level_requirement

      # Defense
      t.integer :min_chance_to_block
      t.integer :max_chance_to_block

      t.integer :min_armour
      t.integer :max_armour

      t.integer :min_evasion
      t.integer :max_evasion

      t.integer :min_energy_shield
      t.integer :max_energy_shield

      # maps
      t.integer :map_tier

      # jewels
      t.integer :jewel_radius
      t.integer :jewel_limit

      # flasks
      t.integer :flask_min_life
      t.integer :flask_max_life

      t.integer :flask_min_mana
      t.integer :flask_max_mana

      t.float :flask_min_duration
      t.float :flask_max_duration

      t.integer :flask_min_usage
      t.integer :flask_max_usage

      t.integer :flask_capacity

      t.string :flask_buff_effect

      # Damage
      t.string :physical_damage
      t.string :lightning_damage
      t.string :fire_damage
      t.string :cold_damage
      t.string :chaos_damage

      # DPS
      t.float :min_total_dps
      t.float :max_total_dps

      t.float :min_phys_dps
      t.float :max_phys_dps

      t.float :min_chaos_dps
      t.float :max_chaos_dps

      t.float :min_ele_dps
      t.float :max_ele_dps

      # Offense
      t.string :critical_strike_chance

      t.string :attacks_per_second

      t.integer :weapon_range

      # Misc
      t.integer :quality

      t.string :image_url

      t.string :version

      t.text :flavor_text

      t.timestamps
    end
  end
end
