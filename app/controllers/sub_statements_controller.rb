class SubStatementsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_statement, only: [ :new, :create, :destroy ]
  before_action :set_sub_statement, only: [ :update, :destroy, :show, :edit]
  
  def index
  end

  def new
    # authorize Card
    @sub_statement = @statement.sub_statements.build
  end

  def show
    # authorize @card
  end

  def edit
    # authorize @card
  end

  def create
    @sub_statement = @statement.sub_statements.build(sub_statement_params.merge(status: :registred)) 
    # authorize @card  
    respond_to do |format|
      if @sub_statement.save
        @ammount = @statement.sub_statements.sum(:charge_sum)
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
      if @statement.update(sub_statement_params)
        @ammount = @statement.sub_statements.sum(:charge_sum)
        format.html { redirect_to statement_path(@statement), notice: t('notice.record_edit') }
        format.turbo_stream { flash.now[:warning] = t('notice.record_edit') }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    # authorize @card
    if @sub_statement.destroy
      @ammount = @statement.sub_statements.sum(:charge_sum)
      respond_to do |format|
        format.html { redirect_to statement_path(@statement), notice: t('notice.record_destroy') }
        format.turbo_stream { flash.now[:danger] = t('notice.record_destroy') }
      end
    else
      flash.now[:error] = t('notice.record_destroy_errors')
    end
  end

  private

  def set_statement
    @statement = Statement.find(params[:statement_id])
  end

  def set_sub_statement
    @sub_statement = SubStatement.find(params[:id])
  end

  def sub_statement_params
    params.require(:sub_statement).permit(:card_id, :statement_id, :charge_sum, :comment)
  end

end
