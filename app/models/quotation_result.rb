# app/models/quotation_result.rb
class QuotationResult
  attr_reader :data

  def initialize(data)
    @data = data
  end

  def successful_rates
    data[:rates].select { |r| r[:success] == true }
  end
end
