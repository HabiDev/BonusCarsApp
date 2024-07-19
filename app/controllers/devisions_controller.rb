class DivisionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_division, except: [ :index, :new, :create]

  def index
    # authorize Card
    # @q = Card.ransack(params[:q])
    # @q.sorts = ['owner_card asc', 'created_at desc'] if @q.sorts.empty?
    @division = Division.all
    # @pagy, @users = pagy(User.all, items: mobile_device? ? 3 : 10) 
  end

  def new
    # authorize Card
    @division = Division.new
  end

  def show
    # authorize @card
  end

  def edit
    # authorize @card
  end

  def create
    @division = Devision.new(division_params) 
    # authorize @card  
    respond_to do |format|
      if @division.save
        format.html { redirect_to divisions_path, notice: t('notice.record_create') }
        format.turbo_stream { flash.now[:success] = t('notice.record_create') }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    # authorize @card    
    respond_to do |format|
      if @division.update(division_params)
        format.html { redirect_to divisions_path, notice: t('notice.record_edit') }
        format.turbo_stream { flash.now[:warning] = t('notice.record_edit') }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    # authorize @card
    if @division.destroy
      respond_to do |format|
        format.html { redirect_to divisions_path, notice: t('notice.record_destroy') }
        format.turbo_stream { flash.now[:danger] = t('notice.record_destroy') }
      end
    else
      flash.now[:error] = t('notice.record_destroy_errors')
    end
  end

  private

  def set_division
    @division = Division.find(params[:id])
  end

  def division_params
    params.require(:division).permit(:name)
  end

end
