require 'coalesce'
require_relative 'objects/channel'
require_relative 'segment'

module TDMS
	class Document
		#attr_reader :segments, :channels, :file
		attr_reader :segments, :stream

		def initialize(stream)
			@segments = []
			@stream = stream

			parse_segments
#			build_aggregates
		end


		def channels
			objects.select { |object| object.is_a? Objects::Channel }
		end


		def objects
			segments.flat_map { |segment| segment.objects }
		end



		protected

		def parse_segments
			until stream.eof?
				segment = Segment.parse_stream(stream, self)
				break if segment.nil?
				@segments << segment
				next_segment_offset = segment.meta_data_offset._?(segment.raw_data_offset) + segment.length
				stream.seek next_segment_offset
			end
		end

		# def build_aggregates
		# 	@channels = []
		#
		# 	channels_by_path = {}
		# 	segments.each do |segment|
		# 		segment.objects.select { |o| o.channel }.each do |ch|
		# 			(channels_by_path[ch.channel.path.to_s] ||= []) << ch
		# 		end
		# 	end
		#
		# 	channels_by_path.each do |path, channels|
		# 		@channels << AggregateChannel.new(channels)
		# 	end
		# end
	end

end
