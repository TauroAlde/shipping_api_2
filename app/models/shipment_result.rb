class ShipmentResult
  attr_reader :data

  def initialize(data)
    @data = data
  end

  def id
    data[:id]
  end

  def label_url
    data[:label_url]
  end

  def success?
    data[:status] == "success"
  end
end
