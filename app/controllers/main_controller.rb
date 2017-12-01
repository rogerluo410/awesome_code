class MainController < ApplicationController
  layout :false
  def home
    respond_to do |format|
      format.html
      format.any { render status: 404, json: "not found" }
    end
  end
end
