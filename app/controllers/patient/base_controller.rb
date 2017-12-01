class Patient::BaseController < ApplicationController
  before_action :authenticate_patient!
end
