
require 'rest-client'
require 'digest'
require 'json'



class NocListRetryMax < Exception; end
class Noclist
  attr_accessor :client, :url
  def initialize(client, url, retries=2)
    @client = client
    @url = url
    @max_retries = retries
  end

  def http_retry path, headers={}
    begin
      response = client.get(url + path, headers)
    rescue RestClient::Exception
     @retries ||= 0
     if @retries < @max_retries
       @retries += 1
       retry
     else
       raise NocListRetryMax.new("Maximum retry met")
     end
    end
    response
  end

  def retry_count
    @retries
  end

  def auth_checksum token
    str = token + "/users"
    encoded = str.encode("utf-8")
    Digest::SHA256.hexdigest(encoded)
  end

  def get_token
    resp = http_retry("/auth")
    resp.headers[:badsec_authentication_token]
  end

  def get_user_ids checksum
    http_retry("/users", headers={x_request_checksum: checksum})
  end

  def users
    token = get_token
    checksum = auth_checksum token
    resp = get_user_ids checksum
    resp.body
  end
end

