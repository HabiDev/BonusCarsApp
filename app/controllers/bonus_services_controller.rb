class BonusServicesController < ApplicationController
  before_action :authenticate_user!

  def get_card_active_bonus
    @updating = false 
    @card = Card.find(params[:card_id])     
    current_bonus = ActiveBonus.call(@card.code_card)

    if current_bonus[:error_server].present?
      flash.now[:error] = t("notice.#{current_bonus[:error_server]}")
    elsif current_bonus[:balance].present?
      if @card.update(balance: current_bonus[:balance])
        flash.now[:notice] = t('notice.balance_refresh')
        @updating = true
      else
        flash.now[:error] = t('notice.record_update_errors') 
      end
    else
      flash.now[:error] = t('notice.card_not_found')
    end 

  end

  def get_statement_bonus 
    @statement = Statement.find(params[:statement_id])
    @sub_statements = @statement&.sub_statements
    errors_count = 0

    if !server_available?('192.168.116.81') 
      flash.now[:error] = t('notice.E500')      
    elsif @sub_statements.present? 
      errors_count = charge_bonus(@sub_statements)
      respond_to do |format|
        if @statement.update(statement_at: DateTime.now, status: errors_count > 0 ? 2 : 1)
          format.turbo_stream { errors_count > 0 ? flash.now[:error] = t('notice.statement_success_errors', count: errors_count) : flash.now[:notice] = t('notice.statement_success') }
        else
          format.turbo_stream { flash.now[:error] = t('notice.statement_unsuccess') }
        end
      end
    else
      flash.now[:error] = t('notice.sub_statement_not_present')
    end
  end

  def get_cancel_statement_bonus
    @statement = Statement.find(params[:statement_id])
    @sub_statements = @statement&.sub_statements
    errors_count = 0

    if !server_available?('192.168.116.81') 
      flash.now[:error] = t('notice.E500')      
    elsif @sub_statements.present? 
      errors_count = cancel_charge_bonus(@sub_statements)
      respond_to do |format|
        if @statement.update(statement_at: DateTime.now, status: errors_count > 0 ? 2 : 5)
          format.turbo_stream { errors_count > 0 ? flash.now[:error] = t('notice.statement_success_errors', count: errors_count) : flash.now[:notice] = t('notice.statement_success') }
        else
          format.turbo_stream { flash.now[:error] = t('notice.statement_unsuccess') }
        end
      end
    else
      flash.now[:error] = t('notice.sub_statement_not_present')
    end
  end

  private

  def charge_bonus(resourses)
    errors_count = 0
    resourses.each do |resource|

      next if resource.success?
      
      before_balance = ActiveBonus.call(resource.card.code_card)
      charge_bonus = ChargeBonusAccount.call(resource.card.code_card, resource.charge_sum)  
      after_balance = ActiveBonus.call(resource.card.code_card)

      if charge_bonus[:error_server].present? || !charge_bonus[:error_code] == "0"
        error_text = t("notice.#{charge_bonus[:error_server]}") || t("bonus_charge_errors.#{charge_bonus[:error_text]}")
        resource.update!(balance_before: before_balance[:balance], balance_after: after_balance[:balance], status: 2, error_text: error_text)
        errors_count += 1
      else 
        resource.update!(balance_before: before_balance[:balance], balance_after: after_balance[:balance], status: 1)
      end
    end
    return errors_count
  end

  def cancel_charge_bonus(resourses)
    errors_count = 0
    resourses.each do |resource|

      next unless resource.success?
      
      before_balance = ActiveBonus.call(resource.card.code_card)
      cancel_charge_bonus = CancelChargeBonusAccount.call(resource.card.code_card, resource.charge_sum)  
      after_balance = ActiveBonus.call(resource.card.code_card)

      if cancel_charge_bonus[:error_server].present? || !cancel_charge_bonus[:error_code] == "0"
        error_text = t("notice.#{cancel_charge_bonus[:error_server]}") || t("bonus_charge_errors.#{cancel_charge_bonus[:error_text]}")
        resource.update!(balance_before: before_balance[:balance], balance_after: after_balance[:balance], status: 2, error_text: "Ошибка отмены: #{error_text}")
        errors_count += 1
      else 
        resource.update!(balance_before: before_balance[:balance], balance_after: after_balance[:balance], status: 5)
      end
    end
    return errors_count
  end

  def server_available?(server)
    Net::Ping::External.new(server, 7, 1).ping?
  end

end





