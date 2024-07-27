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

  def get_statement_bonus   
    @statement = Statement.find(params[:statement_id])
    @sub_statements = @statement.sub_statements
    errors_count = 0

    if @sub_statements.present?
      
      @sub_statements.each do |sub_statement|

        before_balance = ActiveBonus.call(sub_statement.card.code_card)
        charge_bonus = ChargeBonusAccount.call(sub_statement.card.code_card, sub_statement.charge_sum)
        after_balance = ActiveBonus.call(sub_statement.card.code_card)
        
        if charge_bonus[:error_code] == "0"
          sub_statement.update!(balance_before: before_balance, balance_after: after_balance, status: 1)
        else
          error_text = t("bonus_charge_errors.#{charge_bonus[:error_text]}")
          sub_statement.update!(balance_before: before_balance, balance_after: after_balance, status: 3, error_text: error_text)
          errors_count += 1
        end
      end

      if @statement.update(statement_at: DateTime.now, status: errors_count > 0 ? 2 : 1)
        respond_to do |format|
          # format.turbo_stream { flash.now[:notice] =  errors_count > 0 ? t('notice.statement_success_errors', errors: errors_count) : t('notice.statement_success') }
          format.turbo_stream { flash.now[:notice] = t('notice.statement_success') }
        end
      else
        format.turbo_stream { flash.now[:error] = t('notice.statement_unsuccess') }
      end

    else
      flash.now[:error] = t('notice.sub_statement_not_present')
    end
  end
  
end
