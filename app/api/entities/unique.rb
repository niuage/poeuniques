module Entities
  class Unique < Grape::Entity
    gt = Proc.new { |attr, threshold| Proc.new { |u, o| u.send(attr) && u.send(attr) > threshold } }
    present = Proc.new { |attr| Proc.new { |u, o| u.send(attr).present? } }

    expose :id, :name, :base_name, :image_url

    expose :item_mods, with: "Entities::ItemMod", as: :mods

    expose :requirements do
      [:int, :dex, :str].each do |req|
        expose :"required_#{req}", as: req, if: gt.(:"required_#{req}", 0)
      end

      expose :level_requirement, as: :level, if: gt.(:level_requirement, 0)
    end

    expose :defense do
      [:armour, :evasion, :energy_shield, :chance_to_block].each do |attr|
        expose attr.to_s.titleize, if: gt.(:"min_#{attr}", 0) do
          expose :"min_#{attr}", as: :min
          expose :"max_#{attr}", as: :max
        end
      end
    end

    expose :offense do
      expose :elemental_damage do
        [:cold, :lightning, :fire].each do |element|
          expose :"#{element}_damage", if: present.(:"#{element}_damage"), as: element
        end
      end
      expose :chaos_damage
      expose :physical_damage
      expose :weapon_range
      expose :attacks_per_second
      expose :critical_strike_chance
    end

    expose :quality

    expose :flavor_text
  end
end
