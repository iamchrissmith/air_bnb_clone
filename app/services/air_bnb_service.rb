class AirBnbService

  def initialize
    @conn = Faraday.new('https://api.airbnb.com/v2/')
  end

  def create_properties
    response = @conn.get('search_results?client_id=3092nxybyb0otqw18e8nh5nty&location=CO')
    JSON.parse(response.body, symbolize_names: true)
  end

  def self.create_properties
    service = AirBnbService.new
    service.create_properties
  end



end
