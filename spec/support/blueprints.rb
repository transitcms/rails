Page.blueprint do
  name{ "Test Page #{sn}" }
  title{ "Test Page Title #{sn}"}
  slug{ "page-url-#{sn}"}
end

Post.blueprint do
  title { "Sample Post Number #{sn}" }
  post_date{ Date.today }
end

ContentBlock.blueprint do
  name { "Content block #{sn}"}
end

Transit::Menu.blueprint do
  name { "Sample menu #{sn}" }
end