#!/usr/bin/ruby -w
#
#   task api tests
#

class TaskTests < Test::Unit::TestCase

    def setup 
    end

    def teardown 
    end

	def test_010_initialization 
		assert_kind_of( Class, FGDB::Task )
		assert_kind_of( FGDB::Object, FGDB::Task )
		test = nil
		assert_nothing_raised { test = FGDB::Task.new() }
		assert_kind_of( FGDB::Task, test )
	end

	def test_020_basicfunctions
	
		assert_respond_to( task, :hours )
		assert_respond_to( task, :hours= )
		assert_respond_to( task, :type )
		assert_respond_to( task, :type= )
		assert_respond_to( task, :date )
		assert_respond_to( task, :date= )
		# need to test the type functions
		# need to test the date functions
	
	end
		
end
