module V1
  class Uniques < Grape::API
    resource :uniques do
      desc "/uniques"
      get do
        uniques = Unique.all.includes(item_mods: :mod)

        present :uniques, uniques, with: Entities::Unique
        present :total_count, uniques.count
      end
    end
  end
end

