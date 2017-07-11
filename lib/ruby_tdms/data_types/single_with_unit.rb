require_relative 'base'

module RubyTDMS
	module DataTypes
		class SingleWithUnit < Base
			ID = 0x19
			LENGTH_IN_BYTES = 4

			def self.read_from_stream(tdms_file, big_endian)
				if big_endian
					new tdms_file.read_single_be
				else
					new tdms_file.read_single
				end
			end
		end
	end
end
