class WeatherService

  def initialize(params)
    @city = params[:city]
    @state = params[:state]
    @token = ENV["WEATHER_KEY"]
    @_conn = Faraday.new("http://api.wunderground.com")
  end

  def find_by_location
    response = conn.get("/api/#{token}/conditions/q/#{state}/#{city}.json")
    JSON.parse(response.body, symbolize_names: true)[:current_observation]
  end

  private
    attr_reader :city, :state, :token

  def conn
    @_conn
  end
end
