require_relative '../data_types'
require_relative '../channel_enumerator'
require_relative '../string_channel_enumerator'

module RubyTDMS
	module Objects
		class Channel < Base
			attr_reader :chunk_offsets, :chunk_value_count, :data_length, :data_type, :data_type_id, :dimensions, :chunk_length, :raw_data_offset, :value_count, :value_offset


			def initialize(path, document, segment)
				super
				@chunk_offsets = []
				@value_count = 0
			end


			def name
				path.to_a.last
			end


			def as_json
				super.merge({
					name: name,
					data_type: data_type.name.split('::').last,
					dimensions: dimensions,
					values: values.to_a
				})
			end


			# Get all data from the stream to configure ourself with data type, number of values, etc.
			def parse_stream(stream, raw_index)
				@data_type_id = stream.read_u32
				@dimensions = stream.read_u32
				@chunk_value_count = stream.read_u64

				@data_type = DataTypes.find_by_id @data_type_id
				# Get the data length for variable length types (when DataTypes::LENGTH_IN_BYTES is nil)
				@data_length = @data_type::LENGTH_IN_BYTES || stream.read_u64

				# Chunk length is the same as data length for variable length types
				@chunk_length = @data_type::LENGTH_IN_BYTES.nil? ? @data_length : @data_length * @dimensions * @chunk_value_count # Size of the data for this channel in a given chunk.

				super stream
			end


			# When a channel is continued in a new segment, this method is called rather than #parse_stream
			def continue_stream(stream, raw_index, previous_channel)
				@chunk_value_count = previous_channel.chunk_value_count
				@data_length = previous_channel.data_length
				@data_type = previous_channel.data_type
				@data_type_id = previous_channel.data_type_id
				@dimensions = previous_channel.dimensions

				@chunk_length = @data_length * @dimensions * @chunk_value_count # Size of the data for this channel in a given chunk.

				super stream, previous_channel
			end


			# After all channels in a segment have been read, we have to determine our raw data starting offset and
			# the offsets for all individual values, based on the number of chunks in the segment as well as whether
			# the segment is interleaved.
			def calculate_offsets
				previous_channel = nil
				channels = @segment.raw_channels
				me = channels.index self
				previous_channel = channels[me - 1] if me and me > 0

				if @segment.interleaved_data?
					@value_offset = @segment.raw_channels.map(&:data_length).reduce :+
				else
					@value_offset = @data_length
				end

				@raw_data_offset = @segment.raw_data_offset
				if previous_channel
					@raw_data_offset = previous_channel.raw_data_offset
					@raw_data_offset += @segment.interleaved_data? ? previous_channel.data_length : previous_channel.chunk_length
				end

				@segment.chunk_count.times do
					@chunk_offsets << @raw_data_offset + @chunk_offsets.length * @chunk_length
				end
				@value_count = @chunk_value_count * @segment.chunk_count
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
