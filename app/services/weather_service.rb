class WeatherService

  def initialize(params)
    @city = params[:city].parameterize(separator: '_')
    @state = params[:state]
    @token = ENV["WEATHER_KEY"]
    @_conn = Faraday.new("http://api.wunderground.com")
  end

  def find_by_location
    @response = conn.get("/api/#{token}/conditions/q/#{state}/#{city}.json")
  end

  private
    attr_reader :city, :state, :token, :response

  def parse
    JSON.parse(response.body, symbolize_names: true)[:current_observation]
  end

  def conn
    @_conn
  end
end
