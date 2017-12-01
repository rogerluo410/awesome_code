date_formats = {
  normal_date: '%d/%m/%Y',
  hour_ampm: '%I%P'
}

Time::DATE_FORMATS.merge! date_formats
Date::DATE_FORMATS.merge! date_formats
