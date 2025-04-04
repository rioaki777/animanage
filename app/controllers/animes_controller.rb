class AnimesController < ApplicationController
  before_action :authenticate_user!, except: [ :show, :index ]

  def index
    # TODO: ページネーションの導入
    @animes = Anime.limit(6).order(created_at: :asc)
  end

  def show
    @anime = Anime.find_by(id: params[:id])
  end

  def new
    @anime = Anime.new
  end

  def create
    @anime = Anime.new(anime_params)
    @anime.user_id = current_user.id
    if @anime.save
      flash[:notice] = "保存しました"
      redirect_to root_path
    else
      flash[:alert] = "保存に失敗しました"
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @anime = Anime.find(params[:id])
  end

  def update
    @anime = Anime.find(params[:id])
    if @anime.update(anime_params)
      redirect_to anime_path(@anime), notice: "アニメ情報を更新しました！"
    else
      flash.now[:alert] = "更新に失敗しました。エラーを確認してください。"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @anime = Anime.find(params[:id])
    if @anime.user != current_user
      redirect_to animes_path, alert: "他のユーザーのアニメ情報は削除できません。"
    else
      if @anime.destroy
        redirect_to root_path, notice: "アニメ情報を削除しました。"
      else
        redirect_to animes_path, alert: "削除に失敗しました。"
      end
    end
  end

  private

  def anime_params
    params.require(:anime).permit(:title, :comment)
  end
end
