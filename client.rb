#!/usr/bin/env ruby
# frozen_string_literal: true

require 'tttls1.3'

hostname, port = (ARGV[0] || 'localhost:4433').split(':')
request = "GET / HTTP/1.1\r\nHost: #{hostname}\r\nConnection: close\r\n\r\n"
ca_file = hostname == 'localhost' ? "#{__dir__}/fixtures/ca.crt" : nil

settings_2nd = {
  ca_file:,
  alpn: ['http/1.1'],
  sslkeylogfile: '/tmp/sslkeylogfile.log'
}

settings_1st = {
  ca_file:,
  alpn: ['http/1.1'],
  sslkeylogfile: '/tmp/sslkeylogfile.log',
  process_new_session_ticket: lambda do |nst, rms, cs|
    return if Time.now.to_i - nst.timestamp > nst.ticket_lifetime

    settings_2nd[:ticket] = nst.ticket
    settings_2nd[:resumption_master_secret] = rms
    settings_2nd[:psk_cipher_suite] = cs
    settings_2nd[:ticket_nonce] = nst.ticket_nonce
    settings_2nd[:ticket_age_add] = nst.ticket_age_add
    settings_2nd[:ticket_timestamp] = nst.timestamp
  end
}

socket = TCPSocket.new(hostname, port)
client = TTTLS13::Client.new(socket, hostname, **settings_1st)
client.connect
client.write(request)
print client.read until client.eof?
client.close
socket.close

socket = TCPSocket.new(hostname, port)
client = TTTLS13::Client.new(socket, hostname, **settings_2nd)
# :nodoc:
class NoSendEndOfEarlyData
  def serialize
    ''
  end
end
client.instance_eval do
  def send_eoed(_cipher)
    NoSendEndOfEarlyData.new
  end
end
client.early_data(request)
client.connect
print client.read until client.eof?
client.close
socket.close
