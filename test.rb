require 'rubygems'
require 'bundler'
require 'sequel'
require 'amqp'
require 'json'

DB = Sequel.connect("postgres://localhost/hashes")

#DB.execute "create table foo (id serial primary key, name text not null)"
#DB.execute "create table foos (id serial primary key, name text not null)"

EventMachine.run do
  connection = AMQP.connect :host => '127.0.0.1'

  channel = AMQP::Channel.new(connection)
  queue = channel.queue('test.db.insert')
  exchange = channel.direct('')

  queue.subscribe do |payload|
    puts "received message #{ payload }. Disconnecting..."
    DB[:foo].insert(JSON.parse(payload))
    puts DB[:foo].all
  end

  10.times do |i|
    exchange.publish({:name => "blah #{ i }"}.to_json, :routing_key => queue.name)
  end
end
