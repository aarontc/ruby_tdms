require 'coalesce'
require_relative 'objects/channel'
require_relative 'segment'

module TDMS
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


		def objects
			segments.flat_map { |segment| segment.objects }
		end


		# @return [Array<TDMS::Objects::Channel>] The un-aggregated channel objects in the current document.
		def raw_channels
			objects.select { |object| object.is_a? Objects::Channel }
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
