require_relative 'base'

module TDMS
	module DataTypes
		class Boolean < Base
			ID = 0x21
			LENGTH_IN_BYTES = 1

			def self.read_from_stream(tdms_file)
				new tdms_file.read_bool
			end
		end
	end
end
