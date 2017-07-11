require_relative 'base'

module RubyTDMS
	module DataTypes
		class Int32 < Base
			ID = 0x03
			LENGTH_IN_BYTES = 4

			def self.read_from_stream(tdms_file, big_endian)
				if big_endian
					new tdms_file.read_i32_be
				else
					new tdms_file.read_i32
				end
			end
		end
	end
end
