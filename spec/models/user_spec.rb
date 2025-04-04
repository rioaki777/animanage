require 'rails_helper'

RSpec.describe User, type: :model do
  let!(:user) { create(:user) }
  let!(:anime) { create(:anime, user: user) }

  context "バリデーションのテスト" do
    it "ユーザー名がある場合、有効である" do
      expect(user).to be_valid
    end

    it "ユーザー名がない場合、無効である" do
      user.name = nil
      expect(user).to be_invalid
      expect(user.errors[:name]).to include("が入力されていません。")
    end

    it "ユーザー名が20文字を超える場合、無効である" do
      user.name = "a" * 21
      expect(user).to be_invalid
      expect(user.errors[:name]).to include("は20文字以下に設定して下さい。")
    end
  end

  context "リレーションのテスト" do
    it '複数のアニメを持つことができる' do
      anime1 = create(:anime, user: user)
      anime2 = create(:anime, user: user)

      expect(user.animes).to include(anime1, anime2)
    end
    
    it '紐づくアニメ情報を取得できる' do
      expect(user.animes.size).to eq(1)
      expect(user.animes.first.title).to eq('タイトルテスト')
      expect(user.animes.first.comment).to eq('コメントテスト')
      expect(user.animes.first.user_id).to eq(user.id)
    end
  end
end