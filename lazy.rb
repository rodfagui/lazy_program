require 'sinatra'
require 'dm-core'
require 'dm-migrations'
require_relative 'modules/lazy_modules.rb'

include LazyModules

class User
  include DataMapper::Resource
  property :id, Serial
  property :nombre, String
  property :created_at, DateTime
end

configure do
  DataMapper.setup(:default, (ENV["DATABASE_URL"] || "sqlite3://#{Dir.pwd}/lazy.db"))
  DataMapper.finalize.auto_upgrade!
end

get '/' do
	@users = User.all :order => :id.desc
	@title = "Upload"
	erb :upload
end

post '/' do
	u = User.new
	u.nombre = params[:user]
	u.nombre = "Anonymus" if u.nombre.nil? or u.nombre == ""
	u.created_at = Time.now
	u.save

  @filename = params[:file][:filename]
  file = params[:file][:tempfile]

  File.open("#{@filename}", 'wb') do |f|
    f.write(file.read)
  end

  ew = open_lazy(@filename)
  out_lazy(ew, "int.txt")
  nw, aw = organize_days(ew)
  sw = create_lines(aw)
  out_lazy(sw, "out.txt")

	@array_ent = []
	@array_sal = []
	
	File.open("int.txt", "r") do |f|
		f.each_line do |line|
			@array_ent << line
		end
	end

	File.open("out.txt", "r") do |f|
		f.each_line do |line|
			@array_sal << line
		end
	end

  @title = "Show"
	erb :show
end

