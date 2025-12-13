class Admin::LeaguesController < Admin::BaseController
  before_action :set_league, only: [:edit, :update, :destroy]

  def index
    @leagues = League.all.order(created_at: :desc)
  end

  def new
    @league = League.new
  end

  def create
    @league = League.new(league_params)
    if @league.save
      redirect_to admin_leagues_path, notice: "League created successfully."
    else
      render :new
    end
  end

  def edit; end

  def update
    if @league.update(league_params)
      redirect_to admin_leagues_path, notice: "League updated successfully."
    else
      render :edit
    end
  end

  def destroy
    @league.destroy
    redirect_to admin_leagues_path, notice: "League deleted."
  end

  private

  def require_admin
    redirect_to root_path, alert: "Not authorized" unless current_user.admin?
  end

  def set_league
    @league = League.find(params[:id])
  end

  def league_params
    params.require(:league).permit(:name, :music_league_id, :url)
  end
end
