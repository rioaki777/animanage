require 'rails_helper'

RSpec.describe "Animes", type: :request do
  let(:user) { create(:user) } # アニメを作成するユーザー
  let(:other_user) { create(:user) } # その他のユーザー
  let!(:anime) { create(:anime, user: user) } # ユーザーに紐づくアニメを作成

  describe "GET /" do
    it "リクエストが成功すること" do
      get root_path # ルートパスへGETリクエストを送信
      expect(response).to have_http_status(:success) # ステータスコード200を確認
    end
  end

  describe "GET /show" do
    it "リクエストが成功すること" do
      get anime_path(anime) # 指定アニメの個別ページへGETリクエストを送信
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /new" do
    context "ログインしている場合" do
      before { sign_in user } # Deviseのユーザーログイン

      it "リクエストが成功すること" do
        get new_anime_path # 登録ページへGETリクエストを送信
        expect(response).to have_http_status(:success)
      end
    end

    context "未ログインの場合" do
      it "ログインページへリダイレクトすること" do
        get new_anime_path # 未ログイン状態で登録ページへアクセス
        expect(response).to redirect_to(new_user_session_path) # ログインページにリダイレクト
      end
    end
  end

  describe "POST /create" do
    before { sign_in user } # Deviseのユーザーログイン

    let(:valid_params) { { anime: { title: "新アニメ", comment: "テストコメント" } } }
    let(:invalid_params) { { anime: { title: "", comment: "テストコメント" } } }

    it "新しいアニメを作成できること" do
      expect {
        post animes_path, params: valid_params # 正常なパラメータでPOSTリクエストを送信
      }.to change(Anime, :count).by(1) # Animeのレコード数が1増えていることを確認
    end

    it "無効なデータの場合、作成されないこと" do
      expect {
        post animes_path, params: invalid_params # 無効なデータでPOSTリクエストを送信
      }.not_to change(Anime, :count) # レコード数が変わらないことを確認
    end
  end

  describe "PATCH /update" do
    before { sign_in user } # Deviseのユーザーログイン

    let(:valid_params) { { anime: { title: "更新後のタイトル" } } }
    let(:invalid_params) { { anime: { title: "" } } }

    it "アニメ情報を更新できること" do
      patch anime_path(anime), params: valid_params # 正常なデータでPATCHリクエスト
      expect(response).to redirect_to(anime_path(anime)) # 更新後に詳細ページへリダイレクト
      expect(anime.reload.title).to eq("更新後のタイトル") # データが更新されていることを確認
    end

    it "無効なデータの場合、更新されないこと" do
      patch anime_path(anime), params: invalid_params # 無効なデータでPATCHリクエスト
      expect(response).to have_http_status(:unprocessable_entity) # HTTPステータス422を確認
    end
  end

  describe "DELETE /destroy" do
    context "アニメの作成者の場合" do
      before { sign_in user } # Deviseのユーザーログイン

      it "アニメ情報を削除できること" do
        expect {
          delete anime_path(anime) # DELETEリクエストを送信
        }.to change(Anime, :count).by(-1) # Animeのレコード数が1減っていることを確認
      end
    end

    context "他のユーザーの場合" do
      before { sign_in other_user } # Deviseのユーザーログイン

      it "アニメ情報を削除できないこと" do
        expect {
          delete anime_path(anime) # 他のユーザーがDELETEリクエストを送信
        }.not_to change(Anime, :count) # レコード数が変わらないことを確認
      end
    end
  end
end