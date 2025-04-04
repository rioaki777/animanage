User.find_or_create_by(email: "test1@example.com") do |user|
  user.name = "testuser"
  user.password = "password"
end

4.times do |i|
  Anime.find_or_create_by(title: "アニメ#{i + 1}", user: User.first) do |anime|
    anime.comment = "これはサンプルのアニメコメント#{i + 1}"
  end
end

puts "サンプルデータを作成しました！"
