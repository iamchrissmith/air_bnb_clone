module FairBnb
  module ReservationApiHelpers
    def revenue_by_month(params)
      raw_revenue = calculate_revenue_by_location(params[:city])
      raw_revenue.reduce(Hash.new(0)) do |t, (k, v)|
        key = k.dup.prepend("01-").to_date.strftime("%b-%Y")
        t[key] = "$#{'%.2f' % v.to_f.round(2)}"; t
      end
    end

    def calculate_revenue_by_location(city)
      return joins(:property)
        .where('properties.city = ?', city)
        .group("TO_CHAR(start_date, 'MM-YYYY')")
        .sum(:total_price) unless city.nil?
      group("TO_CHAR(start_date, 'MM-YYYY')").sum(:total_price)
    end

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

    def highest_revenue_cities(params)
      Property.select("properties.city, SUM(reservations.total_price) AS revenue")
        .joins(:reservations)
        .where(reservations: {start_date: "#{params[:year]}-#{params[:month]}-01"})
        .group("properties.city")
        .order("revenue DESC", "properties.city ASC")
        .limit(params[:limit])
        .map(&:city)
    end

    def by_state
      Property.select("properties.state, COUNT(properties.id) AS total")
        .group(:state)
        .order(state: :asc)
    end
  end
end
