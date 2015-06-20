require_relative 'object'

module TDMS
	class Segment
		FLAG_META_DATA = 1 << 1
		FLAG_RAW_DATA = 1 << 3
		FLAG_DAQMX_RAW_DATA = 1 << 7
		FLAG_INTERLEAVED_DATA = 1 << 5
		FLAG_BIG_ENDIAN = 1 << 6
		FLAG_NEW_OBJECT_LIST = 1 << 2

		attr_accessor :prev_segment
		attr_reader :objects, :tag, :version, :length, :meta_data_length, :meta_data_offset, :raw_data_offset

		def initialize
			@objects = []
		end


		def parse_lead_in(file)
			@tag = file.read 4
			@flags = file.read_u32
			@version = file.read_u32
			@length = file.read_u64 # Overall length of segment minus length of lead-in
			@meta_data_length = file.read_u64 # Overall length of meta information

			@meta_data_offset = @meta_data_length > 0 ? file.pos : nil
			@raw_data_offset = file.pos + @meta_data_length
		end


		def parse_meta_data(file)
			@number_of_objects = file.read_u32

			@number_of_objects.times do
				@objects << TDMS::Object.new.tap{|o|o.parse_from_file_with_raw_data_offset(file, @raw_data_offset)}
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
	end
end
