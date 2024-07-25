class ChargeBonusAccount < ApplicationService

  def initialize(cardNumber, shopNum, cashNum, shiftNum, checkNum, chargeSum, 
                 activatingDate, expirationDate)

    @wsdl = 'http://192.168.116.81:8090/SET-Cards/SET/Cards/ExternalSystemCardsProcessing?wsdl'
    @card_number = cardNumber
    @shopNum = shopNum
    @cashNum = cashNum
    @shiftNum = shiftNum 
    @checkNum = checkNum
    @chargeSum = chargeSum
    @activatingDate = activatingDate
    @expirationDate = expirationDate
  end

  def call
    get_carge_bonus
  end

  private

  def get_carge_bonus
    client = Savon.client(wsdl: @wsdl, headers: { SOAPAction: "" })
    response = client.call(:charge_on_bonus_account, message: { cardNumber: @card_number, 
                                                                shopNum: @shopNum,
                                                                cashNum: @cashNum,
                                                                shiftNum: @shiftNum, 
                                                                checkNum: @checkNum,
                                                                chargeSum: @chargeSum,
                                                                activatingDate: @activatingDate,
                                                                expirationDate: @expirationDate })    
    response.to_array(:charge_on_bonus_account_response).first
  end


end