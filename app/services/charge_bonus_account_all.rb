class ChargeBonusAccountAll < ApplicationService

  def initialize

    @wsdl = 'http://192.168.116.81:8090/SET-Cards/SET/Cards/ExternalSystemCardsProcessing?wsdl'
    # @chargeSum = chargeSum
  end

  def call
    Card.all.each do |card|
      @card_number = card.card_number
      @chargeSum = card.charge_sum
      get_carge_bonus
    end
  end

  private

  def get_carge_bonus
    client = Savon.client(wsdl: @wsdl, headers: { SOAPAction: "" })
    @shopNum = '150'
    @cashNum = '1'
    @shiftNum = '1'
    @checkNum = '1'
    @activatingDate = (Date.current).to_s
    @expirationDate = ((3.year.since).to_date).to_s

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