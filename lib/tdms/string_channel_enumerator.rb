module TDMS
	class StringChannelEnumerator
		include Enumerable

		def initialize(channel)
			@channel = channel

			@index_offset = @channel.raw_data_offset
			@data_offset = @index_offset + (4 * @channel.value_count)
		end


		def size
			@size ||= @channel.value_count
		end


		def each
			data_pos = @data_offset

			0.upto(size - 1) do |i|
				index_pos = @index_offset + (4 * i)

				@channel.stream.seek index_pos
				next_data_pos = @data_offset + @channel.stream.read_u32

				length = next_data_pos - data_pos

				@channel.stream.seek data_pos
				yield @channel.stream.read(length)

				data_pos = next_data_pos
			end
		end


		def [](i)
			if (i < 0) || (i >= size)
				raise RangeError, 'Channel %s has a range of 0 to %d, got invalid index: %d' % [@channel.path, size - 1, i]
			end

			inject(0) do |j, value|
				return value if j == i
				j += 1
			end
		end

	end
end
