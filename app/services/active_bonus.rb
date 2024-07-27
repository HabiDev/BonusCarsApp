class ActiveBonus < ApplicationService

  def initialize(cardNumber)
    @wsdl = 'http://192.168.116.81:8090/SET-Cards/SET/Cards/ExternalSystemCardsProcessing?wsdl'
    @card_number = cardNumber
  end

  def call
    if get_active_bonus[:return].present?
      get_active_bonus[:return][:balance]
    end
  end

  private

  def get_active_bonus
    client = Savon.client(wsdl: @wsdl, headers: { SOAPAction: "" })
    response = client.call(:get_active_bonus_accounts, message: { cardNumber: @card_number })    
    response.to_array(:get_active_bonus_accounts_response).first
  end

  def get_active_bonus_params
    if get_active_bonus[:return].present?
      get_active_bonus[:return][:balance]
    end
  end


end