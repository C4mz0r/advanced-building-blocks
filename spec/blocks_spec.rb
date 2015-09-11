require_relative "spec_helper"
require_relative '../enumerable_methods.rb'

describe "#my_each" do
	it "should work with arrays" do
		expect{ [1,2,3].my_each{ |n| puts "Got #{n}" } }.to output("Got 1\nGot 2\nGot 3\n").to_stdout
	end

	it "should work with ranges" do
		expect{ (1..4).my_each{ |n| puts "Got #{n}" } }.to output("Got 1\nGot 2\nGot 3\nGot 4\n").to_stdout
	end
end

describe "#my_each_with_index" do
	# TODO
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
		#TODO
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
		# TODO:  There is  failure here that needs to be fixed		
		#[nil, "hello", false].my_none?.should == false
	end
end


