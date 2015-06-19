require_relative 'base'

module TDMS
	module DataTypes
		class Int16 < Base
			ID = 0x02
			LENGTH_IN_BYTES = 2

			def self.read_from_stream(tdms_file)
				new tdms_file.read_i16
			end
		end
	end
end
