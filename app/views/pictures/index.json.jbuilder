json.array!(@pictures) do |picture|
  json.extract! picture, :id, :uid, :data
  json.url picture_url(picture, format: :json)
end
