class CancelChargeBonusAccount < ApplicationService

  def initialize(cardNumber, cancelSum)
    @result = {}
    @wsdl = 'http://192.168.116.81:8090/SET-Cards/SET/Cards/ExternalSystemCardsProcessing?wsdl'
    @card_number = cardNumber
    @shopNum = '150'
    @cashNum = '1'
    @shiftNum = '1' 
    @checkNum = '1'
    @cancelSum = cancelSum * 100    
  end

  def call
    get_cancel_carge_bonus
  end

  private

  def get_cancel_carge_bonus
    if Net::Ping::External.new('192.168.116.81', 7, 1).ping?
      client = Savon.client(wsdl: @wsdl, headers: { SOAPAction: "" })
      response = client.call(:cancel_charge_on_bonus_account, message: { cardNumber: @card_number, 
                                                                  shopNum: @shopNum,
                                                                  cashNum: @cashNum,
                                                                  shiftNum: @shiftNum, 
                                                                  checkNum: @checkNum,
                                                                  cancelSum: @cancelSum })                                                         
      cancel_bonus = response.to_array(:cancel_charge_on_bonus_account_response).first
      if cancel_bonus[:return].present?
        @result[:return] = cancel_bonus[:return]
      else
        @result[:return] = nil
      end
    else
      @result[:error_server] = "E500"
    end
    return @result
  end
end