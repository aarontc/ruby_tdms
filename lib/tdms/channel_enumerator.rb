module TDMS
	class ChannelEnumerator
		include Enumerable

		def initialize(channel)
			@channel = channel
		end


		def size
			@size ||= @channel.num_values
		end


		def each
			0.upto(size - 1) { |i| yield self[i] }
		end


		def [](i)
			if (i < 0) || (i >= size)
				raise RangeError, 'Channel %s has a range of 0 to %d, got invalid index: %d' % [@channel.path, size - 1, i]
			end

			@channel.file.seek @channel.raw_data_pos + (i * @channel.data_type::LENGTH_IN_BYTES)
			@channel.data_type.read_from_stream(@channel.file).value
		end
	end
end
