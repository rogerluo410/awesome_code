module Api
  module V1
    module Patients
      class PharmaciesController < BaseController
        include PaginationHelper
        def index
          params[:q] ||= {}
          params[:q] ||= current_user.address.try(:postcode)
          params[:q] ||= current_user.address.try(:street_address)

          search_results = SearchPharmacies.call(params).search
          pharmacies_ = search_results.page(params[:page]).per(10).records
          pharmacies = search_results.results.map{|x| x._source}

          render json: { data: pharmacies, meta: pagination_info(pharmacies_) }
        end
      end
    end
  end
end
