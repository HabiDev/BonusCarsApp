class CancelChargeBonusAccount < ApplicationService

  def initialize(cardNumber, shopNum, cashNum, shiftNum, checkNum, cancelSum)

    @wsdl = 'http://192.168.116.81:8090/SET-Cards/SET/Cards/ExternalSystemCardsProcessing?wsdl'
    @card_number = cardNumber
    @shopNum = shopNum
    @cashNum = cashNum
    @shiftNum = shiftNum 
    @checkNum = checkNum
    @cancelSum = cancelSum    
  end

  def call
    get_cancel_carge_bonus
  end

  private

  def get_cancel_carge_bonus
    client = Savon.client(wsdl: @wsdl, headers: { SOAPAction: "" })
    response = client.call(:cancel_charge_on_bonus_account, message: { cardNumber: @card_number, 
                                                                shopNum: @shopNum,
                                                                cashNum: @cashNum,
                                                                shiftNum: @shiftNum, 
                                                                checkNum: @checkNum,
                                                                cancelSum: @cancelSum })    
    response.to_array(:cancel_charge_on_bonus_account_response).first
  end


end