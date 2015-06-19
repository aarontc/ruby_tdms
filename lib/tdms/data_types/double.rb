require_relative 'base'

module TDMS
	module DataTypes
		class Double < Base
			ID = 0x0A
			LENGTH_IN_BYTES = 8

			def self.read_from_stream(tdms_file)
				new tdms_file.read_double
			end
		end
	end
end
