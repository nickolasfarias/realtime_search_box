MovieInfo.destroy_all

1500.times do
  MovieInfo.create(
    title: Faker::Movie.title,
    quote: Faker::Movie.quote
  )

  # 192 max because of title uniqueness
end
