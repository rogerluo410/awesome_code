class Admin::PharmaciesController < Admin::BaseController
  before_action :set_pharmacy, only: [:show, :edit, :update, :destroy]

  def index
    @pharmacies = Pharmacy.all.page(params[:page])
  end

  def show
  end

  def edit
  end

  def new
    @pharmacy = Pharmacy.new
  end

  def create
    if Pharmacy.create(pharmacy_params)
      flash[:notice] = "Create pharmacy successfully."
      redirect_to admin_pharmacies_path
    else
      render :new
    end
  end

  def update
    if @pharmacy.update(pharmacy_params)
      flash[:notice] = "Update pharmacy successfully."
      redirect_to admin_pharmacies_path
    else
      render :edit
    end
  end

  def destroy
    if @pharmacy.destroy
      flash[:notice] = "Delete pharmacy successfully."
      redirect_to admin_pharmacies_path
    else
      flash[:alert] = "Failed to delete pharmacy."
    end
  end

  private
  def set_pharmacy
    @pharmacy = Pharmacy.find(params[:id])
  end

  def pharmacy_params
    params.required(:pharmacy).permit(:company_name, :category, :street, :suburb, :code, :phone, :website, :mobile, 
      :toll_free, :fax, :abn, :postal_address, :email, :state, :latitude, :longitude)
  end

end
