
require 'rest-client'
require 'digest'
require 'json'

require_relative "./retry.rb"

class Noclist
  attr_accessor :client, :url
  def initialize(client, url, retries=3)
    @client = client
    @url = url
    @max_retries = retries
  end

  def auth_checksum token
    str = token + "/users"
    encoded = str.encode("utf-8")
    Digest::SHA256.hexdigest(encoded)
  end

  def get_token
    resp = Retry.http(@max_retries.times) do
      client.get(url + "/auth")
    end
    resp.headers[:badsec_authentication_token]
  end

  def get_user_ids checksum
    Retry.http(@max_retries.times) do
      client.get(url + "/users", headers={x_request_checksum: checksum})
    end
  end

  def users
    token = get_token
    checksum = auth_checksum token
    resp = get_user_ids checksum
    resp.body
  end
end

