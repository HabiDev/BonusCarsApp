class ActiveBonus < ApplicationService

  def initialize(cardNumber)
    @result = {}
    @wsdl = 'http://192.168.116.81:8090/SET-Cards/SET/Cards/ExternalSystemCardsProcessing?wsdl'
    @card_number = cardNumber
  end

  def call
    get_active_bonus
  end

  private

  def get_active_bonus 
    if Net::Ping::External.new('192.168.116.81', 7, 1).ping? 
      client = Savon.client(wsdl: @wsdl, headers: { SOAPAction: "" })
      response = client.call(:get_active_bonus_accounts, message: { cardNumber: @card_number })    
      active_bonus = response.to_array(:get_active_bonus_accounts_response).first
      if active_bonus[:return].present?
        @result[:balance] = active_bonus[:return][:balance]
      else
        @result[:balance] = nil
      end
    else
      @result[:error_server] = "E500"
    end
    return @result
  end  
end