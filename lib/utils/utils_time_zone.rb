class UtilsTimeZone
  def self.valid_timezone?(identifier)
    self.all.select { |zone| zone[:identifier] == identifier }.present?
  end

  def self.all
    [{:identifier => "Australia/Perth", :name => "(GMT+8:00) Perth" },
     {:identifier => "Australia/Eucla", :name => "(GMT+8:45) Eucla" },
     {:identifier => "Australia/Adelaide", :name => "(GMT+9:30) Adelaide" },
     {:identifier => "Australia/Broken_Hill", :name => "(GMT+9:30) Broken Hill" },
     {:identifier => "Australia/Darwin", :name => "(GMT+9:30) Darwin" },
     {:identifier => "Australia/Brisbane", :name => "(GMT+10:00) Brisbane" },
     {:identifier => "Australia/Currie", :name => "(GMT+10:00) Currie" },
     {:identifier => "Australia/Hobart", :name => "(GMT+10:00) Hobart" },
     {:identifier => "Australia/Lindeman", :name => "(GMT+10:00) Lindeman" },
     {:identifier => "Australia/Melbourne", :name => "(GMT+10:00) Melbourne" },
     {:identifier => "Australia/Sydney", :name => "(GMT+10:00) Sydney" },
     {:identifier => "Australia/Lord_Howe", :name => "(GMT+10:30) Lord Howe" }]
  end

  def self.identifiers
    self.all.map { |zone| zone[:identifier] }
  end
end
