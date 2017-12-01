Gem.find_files("appointment_queue/*.rb").each { |path| require path }
require "appointment_queue/version"

module AppointmentQueue
  # Your code goes here...
end
