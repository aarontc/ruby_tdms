require_relative 'base'

module TDMS
	module Objects
		class Group < Base
			attr_reader :channels

			def initialize(*args)
				super
				@channels = []
			end
		end
	end
end
