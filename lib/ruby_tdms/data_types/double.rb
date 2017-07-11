require_relative 'base'

module RubyTDMS
	module DataTypes
		class Double < Base
			ID = 0x0A
			LENGTH_IN_BYTES = 8

			def self.read_from_stream(tdms_file, big_endian)
				if big_endian
					new tdms_file.read_double_be
				else
					new tdms_file.read_double
				end
			end
		end
	end
end
