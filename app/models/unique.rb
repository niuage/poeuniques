class Unique < ApplicationRecord
  self.inheritance_column = :_type_disabled

  has_many :item_mods
  has_many :mods, through: :item_mods
end
