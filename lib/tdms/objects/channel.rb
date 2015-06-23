require_relative '../data_types'
require_relative '../channel_enumerator'
require_relative '../string_channel_enumerator'

module TDMS
	module Objects
		class Channel < Base
			attr_reader :data_type, :data_type_id, :dimensions, :raw_data_offset, :value_count


			def name
				path.to_a.last
			end


			def parse_stream(stream, raw_index)
				@block_length = raw_index
				@data_type_id = stream.read_u32
				@dimensions = stream.read_u32
				@value_count = stream.read_u64

				@data_type = DataTypes.find_by_id @data_type_id
				# Get the data length for variable length types (when DataTypes::LENGTH_IN_BYTES is nil)
				@data_length = @data_type::LENGTH_IN_BYTES || stream.read_u64

				@raw_data_offset = @segment.raw_data_offset

				super stream
			end


			def values
				@values ||= begin
					klass = if @data_type::LENGTH_IN_BYTES.nil?
								StringChannelEnumerator
							else
								ChannelEnumerator
							end

					klass.new self
				end
			end
		end
	end
end
