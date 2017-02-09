json.extract! image, :id, :image, :imageable_id, :imageable_type, :created_at, :updated_at
json.url image_url(image, format: :json)