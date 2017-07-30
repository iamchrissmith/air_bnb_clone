class Api::V1::Properties::SearchController < ApiController

  def index
    render json: Property.search(params), status: 200
  end

end