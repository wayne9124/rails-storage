require 'mqtt'

MQTT::Client.connect('test.mosquitto.org') do |c|
  c.publish('message', 'abc')
end
