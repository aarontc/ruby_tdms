require_relative 'base'

module RubyTDMS
	module DataTypes
		class UInt8 < Base
			ID = 0x05
			LENGTH_IN_BYTES = 1


			def self.read_from_stream(tdms_file, big_endian)
				new tdms_file.read_u8
			end
		end
	end
end
