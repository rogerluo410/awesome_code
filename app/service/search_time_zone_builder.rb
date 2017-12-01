class SearchTimeZoneBuilder
  def initialize(from, to)
    @from = from
    @to = to
  end

  def call
    results = []

    UtilsTimeZone.identifiers.each do |tz|
      start_time = @from.in_time_zone(tz)
      end_time = @to.in_time_zone(tz)

      start_time_str = start_time.strftime("%H:%M")
      end_time_str = end_time.strftime("%H:%M")

      week_day_start =  start_time.strftime("%A").downcase
      week_day_end =  end_time.strftime("%A").downcase

      if week_day_start == week_day_end
        results << search_builder(start_time_str, end_time_str, week_day_start, tz)
      else
        results << search_builder(start_time_str, '23:59', week_day_start, tz)
        results << search_builder('00:00', end_time_str, week_day_end, tz)
      end
    end

    {
      or: results
    }
  end

  def search_builder(start_time_str, end_time_str, week_day, tz)
    {"and": [
      {"nested":
        {"path": "appointment_settings",
          "filter": {
            "and": [{
              "and": [
                {"range": {
                  "appointment_settings.start_time": {"lte": end_time_str, "gte": "00:00"}
                  }
                },
                {"term":
                  {"appointment_settings.week_day": week_day}
                }
              ]},
              {
              "and": [
                {"range": {
                  "appointment_settings.end_time": {"gte": start_time_str, "lte": "23:59"}
                  }
                },
                {"term":
                  {"appointment_settings.week_day": week_day}
                }
              ]}
            ]
          }
        }
      },
      {"term":
        {"local_timezone": tz}
      }
    ]
  }
  end
end