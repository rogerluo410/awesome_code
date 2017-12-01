RSpec.shared_context "fake FCM" do
  let(:fcm) { double('FCM') }
  let(:fcm_raw_resp) { generate_fcm_raw_resp }

  before do
    allow(FCM).to receive(:new).and_return(fcm)
  end

  def stub_fcm_send_success
    allow(fcm).to receive(:send).and_return(fcm_raw_resp)
  end

  def stub_fcm_send_failure(ex_class, ex_message)
    allow(fcm).to receive(:send).and_raise(ex_class, ex_message)
  end

  def generate_fcm_raw_resp
    {
      body: JSON.generate(
        "multicast_id" => 6610357857968939209,
        "success" => 2,
        "failure" => 1,
        "canonical_ids" => 0,
        "results" => [
          { "message_id" => "0:1473139063575270%c367d972f9fd7ecd" },
          { "message_id" => "0:1473141750969490%c367d972f9fd7ecd" },
          { "error" => "InvalidRegistration" },
        ],
      ),
      headers: {
        "content-type" => ["application/json; charset=UTF-8"],
        "date" => ["Tue, 06 Sep 2016 05:17:43 GMT"],
        "expires" => ["Tue, 06 Sep 2016 05:17:43 GMT"],
        "cache-control" => ["private, max-age=0"],
        "x-content-type-options" => ["nosniff"],
        "x-frame-options" => ["SAMEORIGIN"],
        "x-xss-protection" => ["1; mode=block"],
        "server" => ["GSE"],
        "alt-svc" => ["quic=\":443\"; ma=2592000; v=\"36,35,34,33,32\""],
        "accept-ranges" => ["none"],
        "vary" => ["Accept-Encoding"],
        "connection" => ["close"],
      },
      status_code: 200,
      response: "success",
      canonical_ids: [],
      not_registered_ids: []
    }
  end
end
