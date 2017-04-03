require 'sinatra'
require 'dm-core'
require 'dm-migrations'

def open_lazy(filename)
	array = []
	File.open(filename, "r") do |f|
	  f.each_line do |line|
	    array << line.to_i
	  end
	end
	array
end

def organize_days(array)
	t = array.shift

	array3 = []
	while true
		array2 = []
		ni = array.shift
		
		ni.times do
			array2 << array.shift 
		end
		
		array3 << array2
	
		break if array == [] 
	end

	return t, array3
end

def calculate_cycles(d1)
	d3 = []

	while true
		d1.sort! { |x,y| y <=> x }
		
		a = d1.shift
		d2 = []
		d2 << a

		if a > 50.0
			ciclos = 0 
		elsif (50.0/a).ceil <= 2
			ciclos = 1
		else
			ciclos = (50.0/a).ceil - 1
		end

		d1.sort!
		ciclos.times do		
			d2 << d1.shift 
		end

		if d1 == []
			d3 << d2
			break
		end

		d1.sort! { |x,y| y <=> x }

		if d1.length >= (50.0/d1[0]).ceil
			d3 << d2
		else
			d2 += d1
			d3 << d2
			d1 = []
			break
		end
	end
	return d3.length	
end

def create_lines (array)
	str = []
	array.each_with_index do |value, index|
		str << "Case ##{index + 1}: #{calculate_cycles(value)}"
	end
	str
end

def out_lazy (array, filename)
	File.open(filename, "w+") do |f|
	  array.each {|element| f.puts(element)}
	end
end

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

