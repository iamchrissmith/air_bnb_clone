module FairBnb
  module ReservationApiHelpers
  end
  module PropertyApiHelpers
    def most_guests(params)
      params[:limit] = 10 if params[:limit].nil?
      unless params[:city].nil?
        where(city: params[:city]).order_by_guests(params[:limit])
      else
        order_by_guests(params[:limit])
      end
    end

    def order_by_guests(x)
      order('number_of_guests DESC').limit(x)
    end

    def most_expensive(params)
      params[:limit] = 10 if params[:limit].nil?
      unless params[:city].nil?
        where(city: params[:city]).order_by_price(params[:limit])
      else
        order_by_price(params[:limit])
      end
    end

    def order_by_price(x)
      order('price_per_night DESC').limit(x)
    end
  end
end
