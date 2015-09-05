# simple bubble sort
def bubble_sort(array)
	for i in (0...array.length)
		for j in (0...array.length-1)
			 swap( array, i, j ) if ( array[j] > array[i] )
		end
	end
	array
end

# helper function to keep the other code clean looking
def swap(array, i, j)
	temp = array[i]
	array[i] = array[j]
	array[j] = temp
end

def bubble_sort_by(array)
	for i in (0...array.length)
		for j in (0...array.length-1)
			if yield( array[i], array[j]) < 0
				swap(array, i, j) 
			end
		end
	end
	array
end

# tests for bubble_sort
#puts bubble_sort([4,3,78,2,0,2]).inspect		# sample data
#puts bubble_sort( Array(1..10) ).inspect		# already ordered
#puts bubble_sort( Array(1..10).reverse! ).inspect	# reversed data


# tests for bubble_sort_by

# sample data
x = bubble_sort_by(["hi","hello","hey"]) do |left,right|
	left.length - right.length
end		
puts x.inspect

# test sort asc
y = bubble_sort_by([4,3,78,2,0,2]) do |left,right|
	left - right
end
puts y.inspect

# test sort desc
z = bubble_sort_by([4,3,78,2,0,2]) do |left,right|
	right - left
end
puts z.inspect

