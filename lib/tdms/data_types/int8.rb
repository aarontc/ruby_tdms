require_relative 'base'

module TDMS
	module DataTypes
		class Int8 < Base
			ID = 0x01
			LENGTH_IN_BYTES = 1

			def self.read_from_stream(tdms_file, big_endian)
				new tdms_file.read_i8
			end
		end
	end
end
