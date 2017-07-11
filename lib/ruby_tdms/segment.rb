require_relative 'object_parser'

module RubyTDMS
	# Implements the TDMS segment, including a Segment factory and stream parser.
	# TODO: Refactor the parser out? Too much coupling between Segment and Document!
	class Segment
		FLAG_META_DATA = 1 << 1
		FLAG_RAW_DATA = 1 << 3
		FLAG_DAQMX_RAW_DATA = 1 << 7
		FLAG_INTERLEAVED_DATA = 1 << 5
		FLAG_BIG_ENDIAN = 1 << 6
		FLAG_NEW_OBJECT_LIST = 1 << 2

		attr_reader :document
		attr_reader :objects, :tag, :version, :length, :meta_data_length, :meta_data_offset, :raw_data_offset, :chunk_count

		def initialize(document)
			@document = document
			@objects = []
		end


		class << self
			def parse_stream(stream, document)
				new(document).tap do |new|
					new.parse_lead_in stream
					document.segments << new # TODO: smelly
					new.parse_meta_data stream if new.meta_data?
				end
			end
		end


		def raw_channels
			objects.select { |object| object.is_a? Objects::Channel }
		end


		# Checks if the segment flags have +flag+ set.
		# @param flag [Fixnum] The flag mask to check, like FLAG_META_DATA or FLAG_RAW_DATA.
		# @return [Boolean] Whether the segment has the flag in question set.
		def flag?(flag)
			!!(@flags & flag == flag)
		end


		def meta_data?
			flag? FLAG_META_DATA
		end


		def raw_data?
			flag? FLAG_RAW_DATA
		end


		def daqmx_data?
			flag? FLAG_DAQMX_RAW_DATA
		end


		def interleaved_data?
			flag? FLAG_INTERLEAVED_DATA
		end


		def big_endian?
			flag? FLAG_BIG_ENDIAN
		end


		def new_object_list?
			flag? FLAG_NEW_OBJECT_LIST
		end


		# protected

		def parse_lead_in(stream)
			@tag = stream.read 4
			@flags = stream.read_u32
			@version = stream.read_u32
			@length = stream.read_u64 # Overall length of segment minus length of lead-in, aka "Next segment offset" in NI docs.
			@meta_data_length = stream.read_u64 # Overall length of meta information, aka "Raw data offset" in NI docs.

			@meta_data_offset = @meta_data_length > 0 ? stream.pos : nil
			@raw_data_offset = stream.pos + @meta_data_length # Stream offset at which raw data for this segment begins.
			@raw_data_length = @length == -1 ? stream.length - @raw_data_offset : @length - @meta_data_length # Number of bytes raw data occupies. NI docs say @length == -1 means the entire file, after lead-in and header, is raw data.
		end


		def parse_meta_data(stream)
			@number_of_objects = stream.read_u32

			@number_of_objects.times do
				object = ObjectParser.parse_stream stream, document, self
				@objects << object
			end


			@chunk_length = raw_channels.map(&:chunk_length).reduce(:+) # Length of an individual data chunk (summation of each object's raw data length)
			@chunk_count = @raw_data_length / @chunk_length
			raw_channels.each { |object| object.calculate_offsets }
		end

	end
end
