require_relative 'base'

module TDMS
	module DataTypes
		class Int32 < Base
			ID = 0x03
			LENGTH_IN_BYTES = 4

			def self.read_from_stream(tdms_file)
				new tdms_file.read_i32
			end
		end
	end
end
