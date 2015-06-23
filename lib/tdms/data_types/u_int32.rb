require_relative 'base'

module TDMS
	module DataTypes
		class UInt32 < Base
			ID = 0x07
			LENGTH_IN_BYTES = 4

			def self.read_from_stream(tdms_file, big_endian)
				if big_endian
					new tdms_file.read_u32_be
				else
					new tdms_file.read_u32
				end
			end
		end
	end
end
