module TDMS
	class StringChannelEnumerator
		include Enumerable

		def initialize(channel)
			@channel = channel

			@index_pos = @channel.raw_data_pos
			@data_pos = @index_pos + (4 * @channel.num_values)
		end


		def size
			@size ||= @channel.num_values
		end


		def each
			data_pos = @data_pos

			0.upto(size - 1) do |i|
				index_pos = @index_pos + (4 * i)

				@channel.file.seek index_pos
				next_data_pos = @data_pos + @channel.file.read_u32

				length = next_data_pos - data_pos

				@channel.file.seek data_pos
				yield @channel.file.read(length)

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
