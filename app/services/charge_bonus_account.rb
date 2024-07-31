class ChargeBonusAccount < ApplicationService

  def initialize(cardNumber,chargeSum)
    @result = {}
    @wsdl = 'http://192.168.116.81:8090/SET-Cards/SET/Cards/ExternalSystemCardsProcessing?wsdl'
    @card_number = cardNumber
    @shopNum = '150'
    @cashNum = '1'
    @shiftNum = '1' 
    @checkNum = '1'
    @chargeSum = chargeSum * 100
    @activatingDate = (Date.current).to_s
    @expirationDate = ((3.year.since).to_date).to_s
  end

  def call
    get_charge_bonus
  end

  private

  def get_charge_bonus
    if Net::Ping::External.new('192.168.116.81', 7, 1).ping? 
      client = Savon.client(wsdl: @wsdl, headers: { SOAPAction: "" })
      response = client.call(:charge_on_bonus_account, message: { cardNumber: @card_number, 
                                                                  shopNum: @shopNum,
                                                                  cashNum: @cashNum,
                                                                  shiftNum: @shiftNum, 
                                                                  checkNum: @checkNum,
                                                                  chargeSum: @chargeSum,
                                                                  activatingDate: @activatingDate,
                                                                  expirationDate: @expirationDate })    
      charge_bonus = response.to_array(:charge_on_bonus_account_response).first
      if charge_bonus[:return].present?
        @result = charge_bonus[:return]
      else
        @result = nil
      end
    else
      @result[:error_server] = "E500"
    end
    return @result
  end 
end