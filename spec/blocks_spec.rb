require_relative "spec_helper"
require_relative '../enumerable_methods.rb'

describe "My Enumeration Functions" do

	before :all do
		# used in a few tests so make it common
		@cube_it = Proc.new do |v|
			v*v*v	
		end
	end

	describe "#my_each" do
	
		it "should work with arrays" do
			expect{ [1,2,3].my_each{ |n| puts "Got #{n}" } }.to output("Got 1\nGot 2\nGot 3\n").to_stdout
		end

		it "should work with ranges" do
			expect{ (1..4).my_each{ |n| puts "Got #{n}" } }.to output("Got 1\nGot 2\nGot 3\nGot 4\n").to_stdout
		end

	end

	describe "#my_each_with_index" do

		it "should give both item and index" do

			expected_result =  "item is a and index is 0\n"
			expected_result += "item is b and index is 1\n"
			expected_result += "item is c and index is 2\n"

			expect{ ['a','b','c'].my_each_with_index do |item, index|
				puts "item is #{item} and index is #{index}" 
			end }.to output(expected_result).to_stdout

		end

		it "should work with words" do # apidock example
			hash = Hash.new
			%w(cat dog wombat).my_each_with_index {|item, index|
			  hash[item] = index
			}
			
			hash.should == {"cat"=>0, "dog"=>1, "wombat"=>2}
		end

		# TODO:  Currently fails because my_each_with_index is calling length.
		#it "should work with ranges" do
		#	
		#	expected_result =  "item is 1 and index is 0\n"
		#	expected_result += "item is 2 and index is 1\n"
		#	expected_result += "item is 3 and index is 2\n"

		#	expect{ (1..3).my_each_with_index do |item, index|
		#		puts "item is #{item} and index is #{index}" 
		#	end }.to output(expected_result).to_stdout
		#end
	end

	describe "#my_select" do

		it "should select specific values" do
			[1,2,3,4].my_select{ |n| n % 2 == 0 }.should == [2,4]
		end

		it "should select specific values (range test)" do
			(1..4).my_select{ |n| n % 2 == 0 }.should == [2,4]
		end

		it "should return an enumerable if there is no block given" do
			# TODO
		end

	end

	describe "#my_all?" do
		it "should return true if true for all items" do
			[1,2,3].my_all?{|n| n > 0}.should == true
		end

		it "should return false if it is false for at least one item" do
			[1,2,3].my_all?{|n| n > 1}.should == false
		end
	end

	describe "#my_any?" do

		it "should return true if any item is true" do
			[1,2,3].my_any?{|n| n == 3 }.should == true
		end

		it "should return false if no item is true" do
			[1,2,3].my_any?{|n| n == 4 }.should == false
		end

		it "should return true if no block is given and at least one of the members is not false or nil" do
			[nil, true, 99].my_any?.should == true
			[nil, 1, 99].my_any?.should == true
			[0].my_any?.should == true # 0 is considered "truthy" in Ruby
		end

		it "should return false if no block is given and the only members it has are false or nil" do
			[nil, false, nil].my_any?.should == false
		end

	end

	describe "#my_none?" do

		it "should return true if the block never returns true for any of the elements" do
			%w{ant bear cat}.my_none? { |word| word.length == 5 }.should == true
		end

		it "should return false if the block returns true for one of the elements" do
			[1,2,3].my_none? { |n| n == 3 }.should == false
		end

		it "should return true if no block is given and none of the collection members are true" do
			[].my_none?.should == true
			[nil].my_none?.should == true
			[nil, false].my_none?.should == true
		end

		it "should return false if no block is given and some collection member is true" do				
			[nil, "hello", false].my_none?.should == false
		end

	end

	describe "#my_count?" do
	
		it "should count number of items in the collection if no block is given" do
			[1,3].my_count.should == 2
		end
	
		it "should count the number of matches given the block" do
			[1,2,3,2,4].my_count{ |x| x % 2 == 0 }.should == 3
		end

		it "should count the number of times a specified value occurs" do
			[1,1,1,1,2].my_count(1).should == 4
		end

	end

	describe "#my_inject" do
		it "should not modify the original array" do
			my_array = [1,2,4]
			my_array.my_inject{|sum, n| sum+n}.should == 7
			my_array.should == [1,2,4]
		end

		it "should work for multiplication" do
			array = [2,4,5]
			array.my_inject{|product,n| product*n}.should == 40
		end
	end

	describe "#multiply_els" do
		it "should multiply array of elements" do
			multiply_els([10,3,-1,0.5]).should == -15
		end
	end

	describe "#my_map" do
		it "should work for arrays" do
			[1,2,3,4].my_map{|i| i*i}.should == [1,4,9,16]
		end

		it "should work for ranges" do
			(1..4).my_map{|i| i*i}.should == [1,4,9,16]
		end

		it "should return an enumerable if no block is given" do
			(1..4).my_map.inspect.should == "#<Enumerator: 1..4:my_map>"
		end

	end

	describe "#my_mappy (i.e. version of my_map that takes a proc)" do
	
		it "should map values according to the proc" do
			[1,2,3].my_mappy(@cube_it).should == [1,8,27]
		end

	end

	describe "#my_mappy_block_and_proc (i.e. version of my_map that takes a block and a proc)" do

		it "should call the proc if no block is specified" do
			[1,2,3].my_mappy_block_and_proc(@cube_it).should == [1,8,27]
		end

		# Note:  The exercise didn't really give an example of how this would work, so I took it to mean
		# that we could do something like use the block to transform an input first, and then the proc to work
		# upon that transformation.
		it "should call both block and proc if both are specified" do
			[1,2,3].my_mappy_block_and_proc(@cube_it){ |x| x + 1 }.should == [8,27,64]
		end

	end

end
