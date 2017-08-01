class Admin::PropertiesController < Admin::BaseController

  def index
    @properties = Property.all
  end

  def update
    @property = Property.find(params[:id])

    if params[:status] == "active"
      @property.update_attributes(status: :active)
      @property.save
    end
    redirect_to admin_properties_path
  end

end
