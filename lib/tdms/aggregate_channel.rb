require_relative 'aggregate_channel_enumerator'

module TDMS
	class AggregateChannel
		def initialize(channels = [])
			@channels = channels
		end

		def path
			@channels[0].path
		end

		def name
			@channels[0].name
		end

		def data_type
			@channels[0].data_type
		end

		def values
			@values ||= AggregateChannelEnumerator.new(@channels)
		end
	end
end
