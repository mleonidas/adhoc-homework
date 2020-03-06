require 'json'
require_relative '../lib/noclist'
require "pry"
require 'optparse'




client = RestClient
url = "http://127.0.0.1:8888"

ARGV.options do | opts |
  opts.on("-u", "--url=val", String) { |val| url = val }
  opts.parse!
end



begin
  users = Noclist.new(client, url).users
  puts JSON.pretty_generate(users.lines.map(&:chomp))
rescue NocListRetryMax
  exit 127
end
