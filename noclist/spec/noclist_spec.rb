require "noclist"
require "rest-client"
require "webmock"

describe Noclist do
  let(:client) { RestClient }
  let(:url) { "http://localhost:8888" }
  let(:noclist) { Noclist.new(client, url) }


  describe "#initialize" do

    context "when parameters are passed in" do

      it "should take and set parameters" do
        expect(noclist.url).to eq(url)
        expect(noclist.client).to eq(client)
      end
    end
  end

  describe "#get_token" do
    context "gets an auth token" do
      it "should return an authentication token" do

        response = instance_double(RestClient::Response,
                                   body: 'somethinghere'.to_json,
                                   headers: {badsec_authentication_token: "supersecret"})

        allow(RestClient::Request).to receive(:execute).and_return(response)
        expect(noclist.get_token).to eq("supersecret")
      end

      it "should retry 3 times then exit" do
        expect(RestClient::Request).to receive(:execute).exactly(3).times
          .and_raise(RestClient::Exception)

        expect{noclist.get_token}.to  raise_error(RestClient::Exception)
      end



      it "should fail 2 times then succeed" do
        response = instance_double(RestClient::Response,
                                   body: 'somethinghere'.to_json,
                                   headers: {badsec_authentication_token: "supersecret"})

        expect(RestClient::Request).to receive(:execute).exactly(2).times
          .and_raise(RestClient::Exception)

        expect(RestClient::Request).to receive(:execute).and_return(response)
        expect(noclist.get_token).to eq("supersecret")
      end
    end
  end

  describe "#auth_checksum" do
    context  do
      it "sha256 hexdigests the string" do
        token = "supersecret"
        local_digest = Digest::SHA256.hexdigest(token + "/users")
        expect(noclist.auth_checksum(token)).to eq local_digest
      end
    end
  end


end
