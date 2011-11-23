class Post
  include Transit::Deliverable
  deliver_as :post
end