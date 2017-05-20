class HomeController < ApplicationController

  def index
    @featured_properties = Property.limit(4).order("RANDOM()")
  end

end
