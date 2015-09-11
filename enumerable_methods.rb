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
		if !block_given?
			x = my_select { |v| v != nil and v != false }
			return !x.empty?
		end

		result = false
		for i in (0...self.length)
			result = yield(self[i])			
			break if result == true
		end
		result
	end

	def my_none?
		if !block_given?
			x = my_select { |v| v != nil and v != false }
			return x.empty?
		end
			
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

# test the multiply elements function which calls inspect to do multiplication
#puts multiply_els([2,4,5]).inspect # => 40


