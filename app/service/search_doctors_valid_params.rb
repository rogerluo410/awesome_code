class SearchDoctorsValidParams
  include Serviceable

  validate :validate_params!

  def initialize(params)
    @params = params
  end

  def call
    valid?
    set_from
    set_to
    from_lt_to

    params
  end

  private

  attr_reader :params, :date, :from, :to, :specialty_id

  HOUR_REG = /\A[0-1][0-9]|[2][0-3]\z/

  def validate_params!
    unless UtilsTimeZone.valid_timezone?(params[:tz])
      fail! 'timezone not valid'
    end

    fail! 'Date can not be blank.' if params[:date].blank?

    begin
      Date.parse(params[:date])
    rescue ArgumentError
      fail! 'date must be a valid date'
    end

    if params[:from].present?
      fail! 'from must be a valid hour' if (params[:from] !~ HOUR_REG)
    end

    if params[:to].present?
      return if params[:to].to_s == 'end_of_day'
      fail! 'to must be a valid hour' if (params[:to] !~ HOUR_REG)
    else
      fail! 'to must be present'
    end
  end

  def from_lt_to
    if params[:from] >= params[:to]
      fail! 'from must little than to'
    end
  end

  def accurate_time
    params[:date].to_datetime.in_time_zone(params[:tz])
  end

  def set_from
    if params[:from].present?
      params[:from] = accurate_time.change(hour: params[:from].to_i)
    else
      params[:from] = set_default_from_time
    end
  end

  def set_default_from_time
    if accurate_time.today?
      Time.current.in_time_zone(params[:tz])
    else
      accurate_time.change(hour: 00)
    end
  end

  def set_to
    if params[:to].to_s == 'end_of_day'
      params[:to] = accurate_time.end_of_day
    else
      params[:to] = accurate_time.change(hour: params[:to].to_i)
    end
  end
end
