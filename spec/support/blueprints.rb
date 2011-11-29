Page.blueprint do
end

Post.blueprint do
  title { "Sample Post Number #{sn}" }
  post_date{ Date.today }
end