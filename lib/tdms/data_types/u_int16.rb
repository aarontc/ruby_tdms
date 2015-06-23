require_relative 'base'

module TDMS
	module DataTypes
		class UInt16 < Base
			ID = 0x06
			LENGTH_IN_BYTES = 2

			def self.read_from_stream(tdms_file, big_endian)
				if big_endian
					new tdms_file.read_u16_be
				else
					new tdms_file.read_u16
				end
			end
		end
	end
end
