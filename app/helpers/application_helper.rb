module ApplicationHelper
  def nav_users_active?(nav)
    case nav.to_s.to_sym
    when :doctors
      params[:controller] == 'admin/doctors'
    when :patients
      params[:controller] == 'admin/patients'
    when :admins
      params[:controller] == 'admin/admins'
    else
      false
    end
  end

  def admin_nav?(nav)
    case nav.to_s.to_sym
    when :users
      %w(admin/doctors admin/patients admin/admins).include? params[:controller]
    when :commissions
      params[:controller] == 'admin/commissions'
    when :pharmacies
      params[:controller] == 'admin/pharmacies'
    when :refunds
      params[:controller] == 'admin/refunds'
    else
      false
    end
  end

  def resource_name
    :patient
  end

  def resource
    @resource ||= Patient.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:patient]
  end
end
