require 'sinatra'
require 'sinatra/param'
require 'mongo'
require 'securerandom'

$URL_REGEX = /((([A-Za-z]{3,9}:(?:\/\/)?)(?:[\-;:&=\+\$,\w]+@)?[A-Za-z0-9\.\-]+|(?:www\.|[\-;:&=\+\$,\w]+@)[A-Za-z0-9\.\-]+)((?:\/[\+~%\/\.\w\-_]*)?\??(?:[\-\+=&;%@\.\w_]*)#?(?:[\.\!\/\\\w]*))?)/

client = Mongo::Client.new(ENV['MONGODB_URI'] != nil ? ENV['MONGODB_URI'] : 'mongodb://127.0.0.1:27017/dbase')
db = client.database

submissions = client[:submissions]

helpers Sinatra::Param

helpers do
  def need_params paramsneeded
    paramsneeded.each do |param|
      if params[param] == nil
        halt "MISSING=#{param}"
      end
    end
  end
  def tagify tags
    out = ''
    tags.each do |tag|
      out += "<a href='/?tags=#{tag}'>#{tag}</a> "
    end
    out
  end
  def taglist
    if params['tags'] != nil && params['tags'].kind_of?(Array)
      params['tags'].join ','
    else
      ''
    end
  end
end

get '/?' do
  param :tags, Array
  pt = params['tags']

  start = params['start'] != nil ? params['start'] : 0
  if pt == nil then pt = [] end
    # NOTE: DOES NOT CURRENTLY WORK BECAUSE _ID IS NOT BEING SET AUTO_INCREMENT-WISE
    #  _id: { '$gt': start },
  results = if pt.length > 0 then submissions.find({tags: { '$all': pt }}).limit(10)
  else submissions.find().limit(10) end
  erb :index, :locals => { :r => results }
end

get '/submit?' do
  erb :submit
end

get '/s/:uuid/?' do
  uuidres = submissions.find({ uuid: params['uuid'] });
  if (uuidres.count > 0)
    erb :viewer, :locals => { :s => uuidres.first }
  else
    erb :message, :locals => { :message => "No Such Submission!" }
  end
end

get '/submit/add?' do
  need_params ['image', 'artpage', 'artist']
  param :image, String, format: $URL_REGEX
  param :title, String, default: "Untitled"
  param :artpage, String, format: $URL_REGEX
  param :artist, String, format: $URL_REGEX
  param :tags, Array
  data = {
    image:   params['image'],   # The image URL to be submitted.
    title:   params['title'],   # The title of the piece of art.
    artpage: params['artpage'], # The original source page for the artwork.
    artist:  params['artist'],  # The profile page for the artist.
    tags:    params['tags'],    # The comma-separated list of tags to add.
    uuid:    SecureRandom.hex(10)
  }
  if submissions.find({ image: params['image'] }).count > 0
    "EXISTS"
  else
    submissions.insert_one data
    "DONE=#{data[:uuid]}"
  end
end

get '/about?' do
  erb :about
end
