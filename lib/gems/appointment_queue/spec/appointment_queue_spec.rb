require 'spec_helper'

describe AppointmentQueue do
  it 'has a version number' do
    expect(AppointmentQueue::VERSION).not_to be nil
  end

  it 'does something useful' do
    expect(AppointmentQueue::Base).to be(AppointmentQueue::Base)
  end
end
