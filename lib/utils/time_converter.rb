class TimeConverter
  def self.dateStringToDateTime(strDate, timezone, hourTime = nil)
    return Time.now unless UtilsTimeZone.valid_timezone?(timezone) && strDate.present?

    begin
      Date.parse(strDate)
    rescue ArgumentError
      return Time.now
    end

    strDate.to_datetime.in_time_zone(timezone).change(hour: hourTime)
  end
end
