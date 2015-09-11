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

	# Modify your #my_map method to take a proc instead.
	def my_mappy(my_proc)
		x = []
			self.my_each do |i|			
				x.push( my_proc.call(i) )
			end
		x	
	end

	# Modify your #my_map method to take either a proc or a block, executing the block only if both are supplied
	# (in which case it would execute both the block AND the proc).
	def my_mappy_block_and_proc(my_proc)

		x = []

		self.my_each do |i|
			x.push (my_proc.call(block_given? ? yield(i) : i))
		end

		x
	end

	def my_inject
		m = self[0]
		copy = self.clone # create a copy otherwise shift will mess up the original
		copy.shift
		copy.my_each do |n|
			m = yield(m,n)
		end
		m
	end

end

def multiply_els(array)
	return array.my_inject{|product,n| product*n}
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

# test my_inject
my_array = [1,2,4]
puts my_array.my_inject{|sum, n| sum+n}.inspect
puts my_array.inspect #ensure array not modified

# test the multiply elements function which calls inspect to do multiplication
puts multiply_els([2,4,5]).inspect # => 40

#test my_map_with_proc
cube_it = Proc.new do |v|
	v*v*v
end

puts [1,2,3].my_mappy(cube_it).inspect # => [1, 8, 27]

puts [1,2,3].my_mappy_block_and_proc(cube_it).inspect + " expect [1, 8, 27]" #call w/o block
puts [1,2,3].my_mappy_block_and_proc(cube_it){ |x| x + 1 }.inspect + " expect [8, 27, 64]"

#puts [1,2,3].map(cube_it){ |x| x+1 }.inspect

