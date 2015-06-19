require_relative 'base'

module TDMS
	module DataTypes
		class String < Base
			ID = 0x20
			LENGTH_IN_BYTES = nil

			def self.read_from_stream(tdms_file)
				new tdms_file.read_utf8_string
			end
		end
	end
end
