module Enumerable
	def my_each
		for i in (0...self.length)
			yield(self[i])
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

	# todo more....
end


# test my_each
[1,2,3].my_each { |n| puts "Got #{n}" }
#[1,2,3].each { |n| puts "Got #{n}" } # for comparison

# test my_each_with_index
['a','b','c'].my_each_with_index { |item, index| puts "item is #{item} and index is #{index}" }
#['a','b','c'].each_with_index { |item, index| puts "item is #{item} and index is #{index}" } # for comparison

# test select
puts [1,2,3,4].my_select { |n| n % 2 == 0 }.inspect
#puts [1,2,3,4].select { |n| n % 2 == 0 }.inspect # for comparison


