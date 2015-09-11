module Enumerable
	def my_each
		# my first solution was using self.length, and I found later that it didn't work if Ranges were passed in
		for i in self
			yield(i)
		end
	end

	def my_each_with_index
		for i in (0...self.length)
			yield(self[i], i)
		end
	end

	# not 100% sure about this one, seems to work with my example but need to check other examples
	def my_select		
		x = []
		self.my_each do |i|			
			x.push(i) if yield(i)
		end
		x
	end

	def my_all?
		result = true
		for i in (0...self.length)
			test = yield(self[i])
			result = false if test == nil or test == false
			break if result == false
		end
		result
	end

	def my_any?
		result = false
		for i in (0...self.length)
			result = yield(self[i])			
			break if result == true
		end
		result
	end

	def my_none?
		#!my_any? {yield}
		return !self.include?(true) if !block_given? 
			
		result = true
		for i in (0...self.length)
			result = !yield(self[i])
			break if result == false
		end
		result
	end

	# wow this one was tricky!
	def my_count(parm = nil, &block)	
		if block_given?
			return (my_select(&block)).length
		elsif !parm.nil?
			return my_select{ |x| x == parm }.length
		else
			return self.length
		end
	end
	
	def my_map
		if !block_given? 
			# not 100% sure here, but tried to make it do similar thing as map when called w/o block
			return Enumerator.new( self, :my_map )
		end

		x = []
		self.my_each do |i|			
			x.push( yield(i) )
		end
		x			
	end

	def my_inject
		
	end

end



# test my_each
[1,2,3].my_each { |n| puts "Got #{n}" }
#[1,2,3].each { |n| puts "Got #{n}" } # for comparison
=begin
# test my_each_with_index
['a','b','c'].my_each_with_index { |item, index| puts "item is #{item} and index is #{index}" }
#['a','b','c'].each_with_index { |item, index| puts "item is #{item} and index is #{index}" } # for comparison

# test my_select
puts [1,2,3,4].my_select { |n| n % 2 == 0 }.inspect
#puts [1,2,3,4].select { |n| n % 2 == 0 }.inspect # for comparison

# test my_all?
#puts [1,2,3].all? { |n| n > 0 }
puts [1,2,3].my_all? { |n| n > 0 }.to_s + " - should have got true"
puts [1,2,3].my_all? { |n| n > 1 }.to_s + " - should have got false"

# test my_any?
puts [1,2,3].my_any? { |n| n == 2 }.to_s + " - should have got true"
puts [1,2,3].my_any? { |n| n == 4 }.to_s + " - should have got false"

# test my_none?
puts [1,2,3].my_none? { |n| n == 0 }.to_s + " - should have got true"
puts [1,2,3].my_none? { |n| n == 3 }.to_s + " - should have got false"
puts [1].my_none? { |n| n == 1 }.to_s + " - should have got false"
# test my_none? without blocks (this is a valid case for none? method)
puts [true].my_none?.to_s + " - should give false"
puts [nil, false].my_none?.to_s + " - should give true"

# test my_count
puts [1,3].my_count.to_s + " - should give 2"
puts [1,2,3,2,4].my_count{ |x| x % 2 == 0 }.to_s + " - should give 3"
puts [1,1,1,1,2].my_count(1).to_s + " - should give 4"

=end

#test my_map
puts [1,2,3,4].my_map{|i| i*i}.inspect
puts (1..4).my_map{|i| i*i}.inspect

# test my_map without block given
e = (1..4).my_map
puts e.inspect
puts e.select { |obj| obj.is_a?(Integer) }.inspect


