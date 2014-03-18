json.array!(@pictures) do |picture|
  json.extract! picture, :album_id, :user_id, :caption, :description
  json.url picture_url(picture, format: :json)
end
