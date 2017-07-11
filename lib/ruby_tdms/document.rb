require 'coalesce'
require_relative 'objects/channel'
require_relative 'segment'

module RubyTDMS
	class Document
		#attr_reader :segments, :channels, :file
		attr_reader :segments, :stream


		def initialize(stream)
			@channel_aggregates = []
			@segments = []
			@stream = stream

			parse_segments
			build_aggregates
		end


		def channels
			@channel_aggregates
		end


		def groups
			objects.select { |object| object.is_a? Objects::Group }
		end


		def objects
			segments.flat_map { |segment| segment.objects }
		end


		# @return [Array<TDMS::Objects::Channel>] The un-aggregated channel objects in the current document.
		def raw_channels
			objects.select { |object| object.is_a? Objects::Channel }
		end


		# Returns a hash representation of the entire TDMS document, looking vaguely like:
		# {
		# file : [
		# 	properties: {}
		# ],
		# 	groups : [
		# 	{
		# 		path: '/Time Domain',
		# 		properties: {}
		#
		# 	}
		# ],
		# 	channels : [
		# 	{
		# 		path: '/Time Domain/Current Phase A',
		# 		name: 'Current Phase A',
		# 		properties: { 'wf_start': 2015-05-23 05:22:22 },
		# 		values: [
		# 			1,
		# 			2,
		# 			3,
		# 			4,
		# 			5
		# 		]
		# 	}
		# ]
		# }
		def as_json
			{
				file: objects.find { |object| object.is_a? Objects::File }.as_json,
				groups: objects.select { |object| object.is_a? Objects::Group }.map(&:as_json),
				channels: channels.map(&:as_json)
			}
		end


		protected

		def parse_segments
			until stream.eof?
				segment = Segment.parse_stream(stream, self)
				break if segment.nil?
				#@segments << segment
				next_segment_offset = segment.meta_data_offset._?(segment.raw_data_offset) + segment.length
				stream.seek next_segment_offset
			end
		end


		def build_aggregates
			channels_by_path =
				raw_channels.reduce({}) do |hash, channel|
					hash[channel.path] ||= []
					hash[channel.path] << channel
					hash
				end

			channels_by_path.each_pair do |path, channels|
				@channel_aggregates << AggregateChannel.new(channels)
			end
		end
	end

end
