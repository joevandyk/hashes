require 'rubygems'
require 'bundler'
require 'sequel'

DB = Sequel.connect("postgres://localhost/hashes")

DB.transaction do
  DB.execute "create table foo (id serial primary key, name text not null)"
  DB.execute "create table foos (id serial primary key, name text not null)"

  DB[:foo].insert(:name => 'joe')
  DB[:foos].insert(:name => 'joe foos')
  p DB[:foo].all
  p DB[:foos].all


  raise 'foo'
end
