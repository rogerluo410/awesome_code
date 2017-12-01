RSpec.describe 'get notifications from api' do
  describe 'get /v1/user' do
    let(:patient) { create(:patient) }
    let(:notification1) { create(:notification, user_id: patient.id, is_read: false, n_type: '') }
    let(:notification2) { create(:notification, user_id: patient.id, is_read: false, n_type: '') }

    describe 'schema match' do
      it 'retrun correct schema' do
        get '/v1/notifications', headers: token_headers(patient)

        expect(response).to have_http_status(200)
        expect(response).to match_api_schema(:notification, layout: :notification_paginated_list)
      end
    end

    describe '#index' do
      context 'with no params' do
        it 'will return two notifications' do
          notification1
          notification2

          get '/v1/notifications', headers: token_headers(patient)

          expect(json['data'].count).to eq(2)
        end
      end

      context 'with params cursor' do
        it 'will retrun notification decide by cursors' do
          notification1
          notification2

          get '/v1/notifications', headers: token_headers(patient), params: {next_cursor: notification1.id}

          expect(json['data'].count).to eq(1)
          expect(json['data'].first['id']).to eq(notification1.id)
        end
      end
    end

    describe '#mark_read' do
      context 'with correct params' do
        it 'will retrun is read true' do
          notification1

          patch "/v1/notifications/#{notification1.id}/mark_read", headers: token_headers(patient)

          notification1.reload
          expect(notification1.is_read).to eq(true)
          expect(json['data']['badge']).to eq(0)
        end
      end
    end
  end
end
