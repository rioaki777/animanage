require 'rails_helper'

RSpec.describe "Animes", type: :system do
  let(:user) { create(:user) } # ユーザーを作成
  let!(:anime) { create(:anime, user: user) } # ユーザーに紐づくアニメを作成

  before do
    driven_by(:rack_test) # ヘッドレスモードでブラウザテストを実行
  end

  it "ユーザーがログインしてアニメを登録できる" do
    sign_in user # ユーザーをログイン
    visit new_anime_path # アニメの登録ページへ移動

    fill_in "anime[title]", with: "新アニメ" # タイトル入力
    fill_in "anime[comment]", with: "テストコメント" # コメント入力
    click_button "保存" # フォーム送信

    expect(page).to have_content("保存しました") # フラッシュメッセージ確認
    expect(page).to have_content("新アニメ") # 作成されたアニメのタイトルを確認
  end

  it "ユーザーがアニメを編集できる" do
    sign_in user
    visit edit_anime_path(anime) # 編集ページへ移動

    fill_in "anime[title]", with: "更新後のタイトル" # タイトルを変更
    click_button "更新" # フォーム送信

    expect(page).to have_content("アニメ情報を更新しました！") # 更新成功のメッセージ確認
    expect(page).to have_content("更新後のタイトル") # 更新後のタイトルを確認
  end

  it "ユーザーがアニメを削除できる" do
    sign_in user
    visit anime_path(anime) # 個別ページへ移動
    click_button "削除"

    expect(page).to have_content("アニメ情報を削除しました。") # 削除成功のメッセージ確認
  end
end