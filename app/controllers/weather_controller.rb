class WeatherController < ApplicationController

  def index
    @weather = Weather.get_weather(city, state)
  end
end
