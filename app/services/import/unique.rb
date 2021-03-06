module Import
  class Unique
    attr_accessor :tds, :type

    attr_accessor :item

    def initialize(type)
      self.type = type
      self.item = ::Unique.new
    end

    def self.for(type)
      # switch

      klass = self

      self.new(type)
    end

    def parse(tds)
      self.tds = tds

      item.assign_attributes({
        name: item_name,
        base_name: base_name,
        type: type
      })

      parse_requirements

      parse_mods

      parse_img

      parse_flavor_text

      item.save
    end

    def parse_img
      item.image_url = popup.css("img").first["src"].gsub(/\?version.*/, "")
    end

    def parse_flavor_text
      item.flavor_text = popup.xpath(".//*[contains(@class,'-flavour')]/text()").map(&:text).map(&:squish).join("|||")
    end

    def get_mods(mod_group)
      mods = mod_group.children.reduce([[]]) do |memo, child|
        if child.name == "br"
          memo.push []
        else
          memo.last.push child
        end

        memo
      end

      mods.map { |mod_group| mod_group.map(&:text).join(" ").squish }
    end

    def parse_mods
      mod_groups = popup.xpath(".//*[contains(@class,'-mod')]")

      if mod_groups.length == 2
        mod = Mod.where(name: get_mods(mod_groups.first).first).first_or_create
        item.item_mods.build(mod: mod, implicit: true)
      end

      mods = get_mods(mod_groups.last)

      mods.each do |mod|
        mod = Mod.where(name: mod).first_or_create
        item.item_mods.build(mod: mod)
      end
    end

    def parse_requirements
      requirements = popup.css(".item-stats .group > em").map { |em| em.text.squish }
      return if requirements.empty?

      requirements.each do |req|
         requirement_matchers.each do |matcher, item_transform|
          if (matches = req.match(matcher))
            item_transform.call(matches)
            break
          end
        end
      end

      [:cold, :lightning, :fire].each do |element|
        element_value = popup.css(".item-stats .group > em.-#{element}").try(:text)
        if element_value.present?
          item.send(:"#{element}_damage=", element_value)
        end
      end

      # removes the .group spans that contain requirements to make it easier to
      # get the mods afterwards
      delete_requirement_groups
    end

    private

    def delete_requirement_groups
      popup.xpath(".//span[contains(@class,'group')][em]").remove
    end

    def item_name
      children = header.children
      raise "Cant find item name" unless children.length == 3

      children.first.text.squish
    end

    def base_name
      children = header.children
      raise "Cant find base name" unless children.length == 3

      children.last.text.squish
    end

    def header
      popup.css(".header.-double")
    end

    def popup
      tds.first.css(".c-item-hoverbox__display")
    end

    def requirement_matchers
      float = "[0-9]*\\.?[0-9]+"

      range = "(?<min>#{float})|()"

      @requirement_matchers ||= {
        # Quality: +20%
        /Quality: \+(?<q>\d+)%/i => ->(matches) { item.quality = matches[:q] },

        # Requires 12 Str, 12 Dex, 100 Int
        /Requires (Level (?<level>\d+)(, )?)?((?<str>\d+) Str,? ?)?((?<dex>\d+) Dex,? ?)?((?<int>\d+) Int,? ?)?/i => ->(matches) do
          [:str, :dex, :int].each { |attr| item.send(:"required_#{attr}=", matches[attr].to_i) }
          item.level_requirement = matches[:level].to_i
        end,

        # Ex:
        # Armour: (100 to 200)
        # Energy Shield: (100 to 200)
        # Evasion: 100
        /(?<type>Armour|Energy Shield|Evasion|Chance to Block): ((?<min>\d+)|(\((?<min>\d+) to (?<max>\d+)\)))/i => ->(matches) do
          type = matches[:type].downcase.gsub(" ", "_")
          item.send(:"min_#{type}=", matches[:min])
          item.send(:"max_#{type}=", (matches[:max] || matches[:min]).to_i)
        end,

        /Physical Damage: (?<phys>.*)/i => ->(matches) { item.physical_damage = matches[:phys] },

        /Chaos Damage: (?<chaos>.*)/i => ->(matches) { item.chaos_damage = matches[:chaos] },

        /Attacks per Second: (?<aps>.*)/i => ->(matches) { item.attacks_per_second = matches[:aps] },

        /Critical Strike Chance: (?<csc>.*)/i => ->(matches) { item.critical_strike_chance = matches[:csc] },

        /Weapon Range: (?<range>\d+)/i => ->(matches) { item.weapon_range = matches[:range] },

        /Radius: .* (?<radius>\d+)/i => ->(matches) { item.jewel_radius = matches[:radius] },

        /Limited to: (?<limit>\d+)/i => ->(matches) { item.jewel_limit = matches[:limit] },

        /Recovers ((?<min>\d+)|((?<min>\d+) to (?<max>\d+))) (?<type>mana|life) over ((?<min_duration>\d+(\.\d+)?)|((?<min_duration>\d+(\.\d+)?) to (?<max_duration>\d+(\.\d+)?)))/ => ->(matches) do
          type = matches[:type]
        end,

        /Lasts ((?<min>\d+(\.\d+)?)|((?<min>\d+(\.\d+)?) to (?<max>\d+(\.\d+)?)))/ => ->(matches) do
          item.min_flask_duration = matches[:min].to_f
          item.max_flask_duration = (matches[:max] || matches[:min]).to_f
        end,
      }
    end
  end
end
