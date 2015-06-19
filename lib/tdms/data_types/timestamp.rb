require_relative 'base'

module TDMS
	module DataTypes
		class Timestamp < Base
			ID = 0x44
			LENGTH_IN_BYTES = 16

			def self.read_from_stream(tdms_file)
				new tdms_file.read_timestamp
			end
		end
	end
end
