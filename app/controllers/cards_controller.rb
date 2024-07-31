class CardsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_card, except: [ :index, :new, :create, :get_active_bonus, :import, :import_file ]

  def index
    # authorize Card
    @q = Card.ransack(params[:q])
    @q.sorts = ['owner_card asc', 'release_at desc'] if @q.sorts.empty?
    @cards = @q.result(disinct: true)
    # @pagy, @users = pagy(User.all, items: mobile_device? ? 3 : 10) 
  end

  def new
    # authorize Card
    @card = Card.new
  end

  def show
    # authorize @card
  end

  def edit
    # authorize @card
  end

  def create
    @card = Card.new(card_params) 
    # authorize @card  
    respond_to do |format|
      if @card.save
        format.html { redirect_to cards_path, notice: t('notice.record_create') }
        format.turbo_stream { flash.now[:success] = t('notice.record_create') }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    # authorize @card    
    respond_to do |format|
      if @card.update(card_params)
        format.html { redirect_to cards_path, notice: t('notice.record_edit') }
        format.turbo_stream { flash.now[:warning] = t('notice.record_edit') }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    # authorize @card
    if @card.destroy
      respond_to do |format|
        format.html { redirect_to cards_path, notice: t('notice.record_destroy') }
        format.turbo_stream { flash.now[:danger] = t('notice.record_destroy') }
      end
    else
      flash.now[:error] = t('notice.record_destroy_errors')
    end
  end

  def import
    if params[:file].present?
      Card.import(params[:file])
      flash.now[:notice] = t('notice.record_imported')
    else
      flash.now[:error] = t('notice.record_imported_error')
    end
  end

  def import_file; end

  private

  def set_card
    @card = Card.find(params[:id])
  end

  def card_params
    params.require(:card).permit(:owner_card, :code_card, :release_at, :default_charge_sum)
  end

end
