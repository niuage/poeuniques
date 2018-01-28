class CreateItemMods < ActiveRecord::Migration[5.1]
  def change
    create_table :item_mods do |t|
      t.belongs_to :mod
      t.belongs_to :unique

      t.string :min_value
      t.string :max_value

      t.boolean :implicit, default: false
      t.boolean :hidden, default: false

      t.timestamps
    end
  end
end
