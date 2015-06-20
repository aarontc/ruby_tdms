require_relative 'channel'
require_relative 'data_types'
require_relative 'path'

module TDMS
	# Stores data and handles for referencing a TDMS stream object
	# TODO: Refactor the Channel object into a subclass of this to also support DAQmx types
	class Object
		attr_reader :channel, :path, :properties


		def initialize
			@properties = []
		end


		def parse_from_file_with_raw_data_offset(file, offset)
			@path = Path.new path: file.read_utf8_string
			@raw_index = file.read_u32

			case @raw_index
				when 0xFFFFFFFF
					# No data stored
				when 0x69120000
					# "DAQmx Format Changing scaler"
					# TODO: Implement support for this
					raise NotImplementedError, 'DAQmx Format Changing scaler support is not implemented'
				when 0x69130000
					# "DAQmx Digital Line scaler"
					# TODO: Implement support for this
					raise NotImplementedError, 'DAQmx Digital Line scaler support is not implemented'
				when 0x00000000
					# Identical to previous segment
				else
					@block_length = @raw_index
					@data_type_id = file.read_u32
					@dimensions = file.read_u32
					@value_count = file.read_u64

					@data_type = DataTypes.find_by_id @data_type_id
					# Get the data length for variable length types (DataTypes::LENGTH_IN_BYTES will be nil)
					@data_length = @data_type::LENGTH_IN_BYTES || file.read_u64

					@channel = Channel.new
					@channel.file = file
					@channel.raw_data_pos = offset
					@channel.path = @path
					@channel.data_type_id = @data_type_id
					@channel.dimension = @dimensions
					@channel.num_values = @value_count
			end

			@properties_length = file.read_u32
			@properties_length.times do
				@properties << file.read_property
			end
		end
	end
end
