require_relative 'base'

module TDMS
	module DataTypes
		class SingleWithUnit < Base
			ID = 0x19
			LENGTH_IN_BYTES = 4

			def self.read_from_stream(tdms_file)
				new tdms_file.read_single
			end
		end
	end
end
