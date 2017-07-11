require_relative 'test_helper'

class ReadType0aDoubleTest < Minitest::Test
	def test_reads_one_double_channel_in_one_segment
		filename = fixture_filename 'type_0a_double_one_segment'
		doc = RubyTDMS::File.parse filename

		assert_equal 1, doc.segments.size
		assert_equal 1, doc.channels.size
		assert_equal 1, doc.groups.size
		assert_equal 1, doc.groups[0].channels.size
		assert_equal RubyTDMS::DataTypes::Double::ID, doc.channels[0].data_type_id

		chan = doc.channels.find { |ch| ch.path == '/double_group/double_channel' }
		assert_equal 5, chan.values.size

		expected = [-2.02, -1.01, 0, 1.01, 2.02]
		assert_equal expected, chan.values.to_a
	end


	def test_reads_two_double_channels_in_one_segment
		filename = fixture_filename 'type_0a_double_two_channels_one_segment'
		doc = RubyTDMS::File.parse filename

		assert_equal 1, doc.segments.size
		assert_equal 2, doc.channels.size
		assert_equal RubyTDMS::DataTypes::Double::ID, doc.channels[0].data_type_id
		assert_equal RubyTDMS::DataTypes::Double::ID, doc.channels[1].data_type_id

		chan = doc.channels.find { |ch| ch.path == '/double_group/double_channel_a' }
		assert_equal 5, chan.values.size
		expected = [-2.02, -1.01, 0, 1.01, 2.02]
		assert_equal expected, chan.values.to_a

		chan = doc.channels.find { |ch| ch.path == '/double_group/double_channel_b' }
		assert_equal 5, chan.values.size
		expected = [2.02, 1.01, 0, -1.01, -2.02]
		assert_equal expected, chan.values.to_a
	end


	def test_reads_one_double_channel_across_three_segments
		filename = fixture_filename 'type_0a_double_three_segments'
		doc = RubyTDMS::File.parse filename

		assert_equal 3, doc.segments.size
		assert_equal 1, doc.channels.size
		assert_equal 1, doc.segments[1].objects.size
		assert_equal 1, doc.segments[2].objects.size
		assert_equal RubyTDMS::DataTypes::Double::ID, doc.channels[0].data_type_id
		assert_equal RubyTDMS::DataTypes::Double::ID, doc.segments[1].objects[0].data_type_id
		assert_equal RubyTDMS::DataTypes::Double::ID, doc.segments[2].objects[0].data_type_id

		chan = doc.channels.find { |ch| ch.path == '/double_group/double_channel' }
		assert_equal 15, chan.values.size
		expected = [-2.02, -1.01, 0.0, 1.01, 2.02,
			-2.02, -1.01, 0.0, 1.01, 2.02,
			-2.02, -1.01, 0.0, 1.01, 2.02]
		assert_equal expected, chan.values.to_a
	end
end
