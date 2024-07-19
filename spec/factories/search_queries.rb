FactoryBot.define do
  factory :search_query do
    query { "MyString" }
    user_ip { "127.0.0.1" }
    is_full_query { false }
  end
end
