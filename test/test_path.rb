require_relative 'test_helper'

class TestPath < Minitest::Test
	# Ensures the split works properly
	def test_raw_split
		input = "/'root'/'other/thing'/'it/''/s whatever'/'and/then/there''s/both!'/'stuff'/'whatever'"

		expected = ['root', 'other/thing', "it/'/s whatever", "and/then/there's/both!", 'stuff', 'whatever']
		uut = RubyTDMS::Path.new raw: input
		actual = uut.to_a
		assert_equal expected, actual
	end


	def test_raw_split_ending_slash
		# This shouldn't happen in TDMS, but make sure we handle it correctly

		input = "/'root'/'other/thing'/'it/''/s whatever'/'and/then/there''s/both!'/'stuff'/'whatever'/"

		expected = ['root', 'other/thing', "it/'/s whatever", "and/then/there's/both!", 'stuff', 'whatever']
		uut = RubyTDMS::Path.new raw: input
		actual = uut.to_a
		assert_equal expected, actual
	end


	def test_raw
		input = "/'root'/'other/thing'/'it/''/s whatever'/'and/then/there''s/both!'/'stuff'/'whatever'"
		uut = RubyTDMS::Path.new raw: input
		actual = uut.raw
		assert_equal input, actual
	end


	def test_path
		input = "/'root'/'other/thing'/'it/''/s whatever'/'and/then/there''s/both!'/'stuff'/'whatever'/"

		expected = "/root/other\\/thing/it\\/'\\/s whatever/and\\/then\\/there's\\/both!/stuff/whatever"
		uut = RubyTDMS::Path.new raw: input
		actual = uut.path
		assert_equal expected, actual
	end


	def test_path_split
		input = "/root/other\\/thing/it\\/'\\/s whatever/and\\/then\\/there's\\/both!/stuff/whatever"

		expected = ['root', 'other/thing', "it/'/s whatever", "and/then/there's/both!", 'stuff', 'whatever']
		uut = RubyTDMS::Path.new path: input
		actual = uut.to_a
		assert_equal expected, actual
	end


	def test_raw_from_path
		expected = "/'root'/'other/thing'/'it/''/s whatever'/'and/then/there''s/both!'/'stuff'/'whatever'"

		input = "/root/other\\/thing/it\\/'\\/s whatever/and\\/then\\/there's\\/both!/stuff/whatever"
		uut = RubyTDMS::Path.new path: input
		actual = uut.raw
		assert_equal expected, actual
	end
end
