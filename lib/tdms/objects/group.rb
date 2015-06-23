require_relative 'base'

module TDMS
	module Objects
		class Group < Base
			attr_reader :channels
		end
	end
end
