RSpec.describe 'Search Doctors' do
  let(:params) { {date: '2016-6-7', from: '02', to: '03', page: 0, tz: 'Australia/Perth'} }
  let(:doctor) { create(:doctor, local_timezone: 'Australia/Sydney') }

  before do
    allow(Doctor.__elasticsearch__).to receive_message_chain(:search, :page, :records, :to_a).and_return([doctor])
  end

  subject { SearchDoctors.call(params).search }

  context 'ElasticSearch Engine' do
    it 'success' do
      expect(subject.records.to_a.size).to eq(1)
      expect(subject.records.to_a[0]).to eq(doctor)
    end
  end
end