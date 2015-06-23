require_relative 'object_parser'

module TDMS
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
		attr_reader :objects, :tag, :version, :length, :meta_data_length, :meta_data_offset, :raw_data_offset

		def initialize(document)
			@document = document
			@objects = []
		end


		class << self
			def parse_stream(stream, document)
				new(document).tap do |new|
					new.parse_lead_in stream
					new.parse_meta_data stream if new.meta_data?
				end
			end
		end




		# Checks if the segment flags have +flag+ set.
		# @param flag [Fixnum] The flag mask to check, like FLAG_META_DATA or FLAG_RAW_DATA.
		# @return [Boolean] Whether the segment has the flag in question set.
		def flag?(flag)
			!!(@flags & flag)
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
			@length = stream.read_u64 # Overall length of segment minus length of lead-in
			@meta_data_length = stream.read_u64 # Overall length of meta information

			@meta_data_offset = @meta_data_length > 0 ? stream.pos : nil
			@raw_data_offset = stream.pos + @meta_data_length
		end


		def parse_meta_data(stream)
			@number_of_objects = stream.read_u32

			@number_of_objects.times do
				object = ObjectParser.parse_stream stream, document, self
				@objects << object
			end
		end

	end
end
