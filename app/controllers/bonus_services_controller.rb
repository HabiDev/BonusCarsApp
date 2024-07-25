class BonusServicesController < ApplicationController
  before_action :authenticate_user!

  def get_card_active_bonus
    @card = Card.find(params[:card_id])
    current_bonus = ActiveBonus.call(@card.code_card)
    if current_bonus.present?
      respond_to do |format|
        if @card.update(balance: current_bonus)
          # format.html { redirect_to cards_path, notice: t('notice.record_edit') }
          format.turbo_stream { flash.now[:notice] = t('notice.balance_refresh') }
        else
          # format.html { render :edit, status: :unprocessable_entity }
          format.turbo_stream { flash.now[:error] = t('notice.record_update_errors') }
        end
      end
    else
      flash.now[:error] = t('notice.card_not_found')
    end
  end

  def get_balance_before_active_bonus   
    @sub_statement = SubStatement.find(params[:sub_statement_id])
    @statement =  @sub_statement.statement
    bonus_before = ActiveBonus.call(@sub_statement.card.code_card)
    if bonus_before.present?
      respond_to do |format|
        if @sub_statement.update(balance_before:  bonus_before)
          format.turbo_stream { flash.now[:notice] = t('notice.balance_refresh') }
        else
          format.turbo_stream { flash.now[:error] = t('notice.record_update_errors') }
        end
      end
    else
      flash.now[:error] = t('notice.card_not_found')
    end
  end
  
end
