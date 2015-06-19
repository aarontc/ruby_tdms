require_relative 'base'

module TDMS
	module DataTypes
		class Int64 < Base
			ID = 0x04
			LENGTH_IN_BYTES = 8

			def self.read_from_stream(tdms_file)
				new(tdms_file.read_i64)
			end
		end
	end
end
