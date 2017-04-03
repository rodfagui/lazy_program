def open_lazy(filename)
	array = []
	File.open(filename, "r") do |f|
	  f.each_line do |line|
	    array << line.to_i
	  end
	end

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

def out_lazy (array)
	File.open("out.txt", "w+") do |f|
	  array.each {|element| f.puts(element)}
	end
end

filename = 'lazy_loading_example_input.txt'
tw, aw = open_lazy(filename)
sw = create_lines(aw)
out_lazy(sw)


