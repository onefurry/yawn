require 'sinatra'
require 'redis'

redis = ''
if (ENV['REDIS_URL'] != nil)
  redis = Redis.new(:url => ENV['REDIS_URL'])
else
  redis = Redis.new()
end

get '/' do
  erb :index
end

get '/submit' do
  erb :submit
end

get '/about' do
  erb :about
end
