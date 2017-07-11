module RubyTDMS
	module Objects
		# TDMS object base.
		# All objects hold a collection of Segment references since objects can be striped across segments.
		class Base
			attr_reader :path, :properties, :segment, :stream

			def initialize(path, document, segment)
				@path = path
				@document = document
				@segment = segment
				@stream = document.stream

				@properties = []
			end


			def continue_stream(stream, previous_channel)
				parse_properties stream
			end


			def parse_stream(stream)
				parse_properties stream
			end


			def as_json
				{
					path: path.to_s,
					properties: properties.reduce({}) { |properties, property| properties[property.name.to_s.to_sym] = property.value; properties }
				}
			end



			protected

			def parse_properties(stream)
				@properties_length = stream.read_u32
				@properties_length.times do
					@properties << stream.read_property(@segment.big_endian?)
				end
			end
		end
	end
end
