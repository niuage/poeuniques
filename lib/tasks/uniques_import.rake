# UNIQUE_ITEM_TYPES = %w{amulet belt ring quiver body_armour boot glove helmet shield axe bow claw dagger fishing_rod mace stave sword wand life_flask mana_flask hybrid_flask utility_flask jewel map}
UNIQUE_ITEM_TYPES = %w{bow}

def import_uniques!(type)
  plural_type = type.pluralize
  wiki_path = "List_of_unique_#{plural_type}"
  constant_name = "unique_#{plural_type}".upcase
  file_path = "config/initializers/items/unique_#{plural_type}.rb"

  listing = Nokogiri::HTML(open("https://pathofexile.gamepedia.com/#{wiki_path}"))

  blings = []

  listing.css(".wikitable tr").each_with_index do |tr, i|
    tds = tr.css("td")
    next if tds.empty?

    begin
      Import::Unique.for(type).parse(tds)
    rescue => e
      puts "#{e.message} || type: #{type} || i"
    end
  end

  #   nameTd = tds[0]
  #   map_tier = tds[1].text().to_i - 67 if type == "map"

  #   item_type = type.match(/flask/i) ? "flask" : type

  #   img = nameTd.css("img")

  #   image_url = ""
  #   if img.present?
  #     image_url = img.attr("src").value.gsub(/\?version.*/, '')
  #     image_url = prepend_gamepedia_root_url(image_url)
  #   end

  #   bling = {
  #     name: nameTd.css("a").first.text(),
  #     image_url: image_url,
  #     base_name: "",
  #     rarity: "unique",
  #     item_type: item_type
  #   }

  #   bling.merge!(map_tier: map_tier) if type == "map"

  #   blings << bling

  #   puts bling
  #   sleep(0.3)
  # end

  # File.open(Rails.root.join(file_path).to_s, "w+") do |f|
  #   f.write("#{constant_name} = ")
  #   f.write JSON.pretty_generate(blings.as_json)
  # end
end

task import_all_uniques: :environment do
  UNIQUE_ITEM_TYPES.each do |type|
    puts "============ #{type} ============="
    import_uniques!(type)
  end
end
