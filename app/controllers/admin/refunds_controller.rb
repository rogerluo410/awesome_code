class Admin::RefundsController < Admin::BaseController
  before_action :set_refund_request, only: [:update, :edit]

  def index
    @refund_requests = RefundRequest.all.page(params[:page])
  end

  def update
    if @refund_request.update(refund_request_params)
      flash[:notice] = "Update refund request successfully."
      redirect_to admin_refunds_path
    else
      render :edit
    end
  end

  def edit
  end

  private

  def set_refund_request
    @refund_request = RefundRequest.find(params[:id])
  end

  def refund_request_params
    params.required(:refund_request).permit(:status, :reason)
  end

end
