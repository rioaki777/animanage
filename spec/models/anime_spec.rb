require 'rails_helper'

RSpec.describe Anime, type: :model do
  let!(:anime) { create(:anime) }

  context "バリデーションのテスト" do
    it "タイトルとコメントがある場合、有効である" do
      expect(anime).to be_valid
    end

    it "タイトルがない場合、無効である" do
      anime.title = nil
      expect(anime).to be_invalid
      expect(anime.errors[:title]).to include("が入力されていません。")
    end

    it "タイトルが50文字を超える場合、無効である" do
      anime.title = "a" * 51
      expect(anime).to be_invalid
      expect(anime.errors[:title]).to include("は50文字以下に設定して下さい。")
    end

    it "コメントがない場合、無効である" do
      anime.comment = nil
      expect(anime).to be_invalid
      expect(anime.errors[:comment]).to include("が入力されていません。")
    end

    it "コメントが500文字を超える場合、無効である" do
      anime.comment = "a" * 501
      expect(anime).to be_invalid
      expect(anime.errors[:comment]).to include("は500文字以下に設定して下さい。")
    end
  end
end