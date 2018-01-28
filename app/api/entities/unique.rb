module Entities
  class Unique < Grape::Entity
    expose :id
    expose :name
    expose :base_name
    expose :image_url
  end
end
