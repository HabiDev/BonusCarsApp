class StatementsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_statement, except: [ :index, :new, :create, :import, :import_file]

  def index
    # authorize Card
    @q = Statement.ransack(params[:q])
    # @q.sorts = ['owner_card asc', 'created_at desc'] if @q.sorts.empty?
    @statements = @q.result(disinct: true).includes(:division, :sub_statements)
    # @pagy, @users = pagy(User.all, items: mobile_device? ? 3 : 10) 
  end

  def new
    # authorize Card
    @statement = Statement.new
  end

  def show
    # authorize @card
    @ammount = @statement.sub_statements.sum(:charge_sum)
  end

  def edit
    # authorize @card
  end

  def create
    @statement = Statement.new(statement_params) 
    # authorize @card  
    respond_to do |format|
      if @statement.save
        format.html { redirect_to statement_path(@statement), notice: t('notice.record_create') }
        format.turbo_stream { flash.now[:success] = t('notice.record_create') }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    # authorize @card    
    respond_to do |format|
      if @statement.update(statement_params.merge(status: :registred))
        format.html { redirect_to statements_path, notice: t('notice.record_edit') }
        format.turbo_stream { flash.now[:warning] = t('notice.record_edit') }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def copy
    @statement_copy = Statement.new(item: @statement.item, division: @statement.division, 
                                    ammount: @statement.ammount, status: 0, 
                                    comment: @statement.comment)
    respond_to do |format|
      if @statement_copy.save
        if @statement.sub_statements.present?
          @statement.sub_statements.each do |sub_statement|
            @statement_copy.sub_statements.create!(card: sub_statement.card, charge_sum: sub_statement.charge_sum, comment: sub_statement.comment, status: 0) 
          end
        end
  
        format.turbo_stream { flash.now[:success] = t('notice.copy_record_create') }
      else
        flash.now[:error] = t('notice.copy_record_unsuccess')
      end
    end
  end

  def destroy
    # authorize @card
    if @statement.destroy
      respond_to do |format|
        format.html { redirect_to statements_path, notice: t('notice.record_destroy') }
        format.turbo_stream { flash.now[:danger] = t('notice.record_destroy') }
      end
    else
      flash.now[:error] = t('notice.record_destroy_errors')
    end
  end

  def import
    if params[:statement_id].present? & params[:file].present?
      @statement = Statement.find(params[:statement_id])
      SubStatement.import(params[:file], params[:statement_id])
      @statement.update!(ammount: @statement.sub_statements.sum(:charge_sum))
      flash.now[:notice] = t('notice.record_imported')
    else
      flash.now[:error] = t('notice.record_imported_error')
    end
  end

  def import_file; end

  private

  def set_statement
    @statement = Statement.find(params[:id])
  end

  def statement_params
    params.require(:statement).permit(:item, :division_id, :comment)
  end

end
