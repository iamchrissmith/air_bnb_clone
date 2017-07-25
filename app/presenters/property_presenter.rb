class PropertyPresenter
  attr_reader :properties, :cities, :number_of_guests, :check_in, :check_out, :params

  def initialize(params)
    @params = params
  end

  def set_attributes
    if all_search_params
      @properties = Property.search_city_dates_guests(params[:city], params[:check_in].to_date, params[:check_out].to_date, params[:guests]).paginate(:page => params[:page], :per_page => 20)
    elsif city_and_guest_search_params
      @properties = Property.search_city_guests(params[:city], params[:guests]).paginate(:page => params[:page], :per_page => 20)
    elsif date_and_guest_search_params
      @properties = Property.search_dates_guests(params[:check_in].to_date, params[:check_out].to_date, params[:guests]).paginate(:page => params[:page], :per_page => 20)
    elsif date_and_city_search_params
      @properties = Property.search_dates_city(params[:check_in].to_date, params[:check_out].to_date, params[:city]).paginate(:page => params[:page], :per_page => 20)
    elsif date_search_params
      @properties = Property.search_dates(params[:check_in].to_date, params[:check_out].to_date).paginate(:page => params[:page], :per_page => 20)
    elsif city_search_param
      @properties = Property.search_city(params[:city]).paginate(:page => params[:page], :per_page => 20)
    elsif guest_search_param
      @properties = Property.search_guests(params[:guests]).paginate(:page => params[:page], :per_page => 20)
    else
      @properties = Property.all.paginate(:page => params[:page], :per_page => 20)
    end
    set_date
    set_num_guests
    set_cities
  end

  def any_search_param?
    city_search_param || guest_search_param || date_search_params
  end

  private
    def set_date
      if date_search_params
        @check_in = params[:check_in].to_date
        @check_out = params[:check_out].to_date
      end
    end

    def set_num_guests
      @number_of_guests = params[:guests] if guest_search_param
    end

    def set_cities
      @cities = @properties.pluck(:city).uniq
    end

    def all_search_params
      city_search_param && guest_search_param && date_search_params
    end

    def city_and_guest_search_params
      city_search_param && guest_search_param
    end

    def date_and_guest_search_params
      date_search_params && guest_search_param
    end

    def date_and_city_search_params
      date_search_params && city_search_param
    end

    def date_search_params
      params[:check_in].present? && params[:check_out].present?
    end

    def city_search_param
      params[:city].present?
    end

    def guest_search_param
      params[:guests].present?
    end
end