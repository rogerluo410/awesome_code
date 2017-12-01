RSpec.describe Survey do
  it "#reason" do
    survey = Survey.new(reason_id: 1)
    expect(survey.reason).to eq('Prescription Refil')

    # Test when reason_id is nil
    survey = Survey.new
    expect(survey.reason).to be nil

    # Test when reason_id is invalid
    survey = Survey.new(reason_id: 1000)
    expect(survey.reason).to be nil
  end
end
