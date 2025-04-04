FactoryBot.define do
  factory :anime do
    title { "タイトルテスト" }
    comment { "コメントテスト" }
    association :user
  end
end