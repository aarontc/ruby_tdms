require_relative 'base'

module TDMS
	module DataTypes
		class UInt64 < Base
			ID = 0x08
			LENGTH_IN_BYTES = 8

			def self.read_from_stream(tdms_file)
				new tdms_file.read_u64
			end
		end
	end
end
