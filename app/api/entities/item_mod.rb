module Entities
  class ItemMod < Grape::Entity
    expose :name
    expose :implicit
    expose :hidden
  end
end
