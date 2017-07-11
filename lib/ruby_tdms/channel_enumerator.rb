module RubyTDMS
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

			chunk_index = i / @channel.chunk_value_count

			offset = (@channel.raw_data_offset + (@channel.chunk_length * chunk_index)) + (i * @channel.value_offset)
			@channel.stream.seek offset
			@channel.data_type.read_from_stream(@channel.stream, @channel.segment.big_endian?).value
		end
	end
end
