class Doctor::BaseController < ApplicationController
  before_action :authenticate_doctor!
end
