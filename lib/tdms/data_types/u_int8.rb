require_relative 'base'

module TDMS
	module DataTypes
		class UInt8 < Base
			ID = 0x05
			LENGTH_IN_BYTES = 1

			def self.read_from_stream(tdms_file)
				new tdms_file.read_u8
			end
		end
	end
end
