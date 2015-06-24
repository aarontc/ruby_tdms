require_relative 'aggregate_channel_enumerator'

module TDMS
	class AggregateChannel
		def initialize(channels = [])
			@channels = channels
		end


		def inspect
			"#<#{self.class.name}:#{self.object_id} path=#{path.inspect}, #{@channels.length} channel(s)>"
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


		def data_type_id
			@channels[0].data_type_id
		end


		def values
			@values ||= AggregateChannelEnumerator.new @channels
		end


		def to_hash
			result = @channels[0].to_hash
			# Iterate over all channel objects and update properties
			result[:properties] = @channels.reduce({}) do |properties, channel|
				channel.properties.each do |property|
					properties[property.name.to_sym] = property.value
				end
				properties
			end
			result[:values] = values.to_a
			result
		end
	end
end
