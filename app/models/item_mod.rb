class ItemMod < ApplicationRecord
  belongs_to :mod
  belongs_to :unique

  scope :implicit, -> { where(implicit: true) }
  scope :regular, -> { where(implicit: false, hidden: false) }

  delegate :name, to: :mod
end
