class QuotationResult
  attr_reader :data

  def initialize(data)
    @data = data
  end

  def id
    data[:id]
  end

  def successful_rates
    data[:rates].select { |r| r[:success] }
  end
end
