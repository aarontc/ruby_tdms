module TDMS
	class ChannelEnumerator
		include Enumerable

		def initialize(channel)
			@channel = channel
		end


		def size
			@size ||= @channel.value_count
		end


		def each
			0.upto(size - 1) { |i| yield self[i] }
		end


		def [](i)
			if (i < 0) || (i >= size)
				raise RangeError, 'Channel %s has a range of 0 to %d, got invalid index: %d' % [@channel.path, size - 1, i]
			end

			@channel.stream.seek @channel.raw_data_offset + (i * @channel.data_type::LENGTH_IN_BYTES)
			@channel.data_type.read_from_stream(@channel.stream).value
		end
	end
end
