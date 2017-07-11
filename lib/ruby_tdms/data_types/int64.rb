require_relative 'base'

module RubyTDMS
	module DataTypes
		class Int64 < Base
			ID = 0x04
			LENGTH_IN_BYTES = 8

			def self.read_from_stream(tdms_file, big_endian)
				if big_endian
					new tdms_file.read_i64_be
				else
					new tdms_file.read_i64
				end
			end
		end
	end
end
