require_relative 'base'

module TDMS
	module Objects
		class File < Base

			def to_hash
				super.reject { |key, value| key == :path }
			end
		end
	end
end
