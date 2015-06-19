require_relative 'channel_enumerator'
require_relative 'data_types'
require_relative 'string_channel_enumerator'

module TDMS
	class Channel < Object
		attr_accessor :file, :path, :data_type_id, :dimension, :num_values, :raw_data_pos

		def data_type
			@data_type ||= DataTypes.find_by_id data_type_id
		end


		def name
			path.channel
		end


		def values
			@values ||= begin
				klass = if data_type::LENGTH_IN_BYTES.nil?
							StringChannelEnumerator
						else
							ChannelEnumerator
						end

				klass.new self
			end
		end


	end
end
