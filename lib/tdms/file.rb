require_relative 'streaming'

module TDMS
	class File < ::File
		include Streaming

		class << self
			def parse(filename)
				Document.new open(filename, 'rb')
			end
		end
	end
end
