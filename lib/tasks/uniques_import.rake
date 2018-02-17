require 'open-uri'

# UNIQUE_ITEM_TYPES = %w{amulet belt ring quiver body_armour boot glove helmet shield axe bow claw dagger fishing_rod mace stave sword wand life_flask mana_flask hybrid_flask utility_flask jewel map}
UNIQUE_ITEM_TYPES = %w{body_armour bow}

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
end

task import_all_uniques: :environment do
  UNIQUE_ITEM_TYPES.each do |type|
    puts "============ #{type} ============="
    import_uniques!(type)
  end
end
