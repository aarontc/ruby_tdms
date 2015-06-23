module TDMS
	module Objects
		# TDMS object base.
		# All objects hold a collection of Segment references since objects can be striped across segments.
		class Base
			attr_reader :path, :properties, :segments, :stream

			def initialize(path, document, segment)
				@path = path
				@document = document
				@segment = segment
				@stream = document.stream

				@properties = []
			end


			def parse_stream(stream)
				@properties_length = stream.read_u32
				@properties_length.times do
					@properties << stream.read_property
				end
			end
		end
	end
end
