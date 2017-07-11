require_rel 'objects'

module RubyTDMS
	class ObjectParser
		class << self
			# Given a +Segment+, parse the next object. If no objects remain, return nil.
			def parse_stream(stream, document, segment)
				path = Path.new raw: stream.read_utf8_string
				raw_index = stream.read_u32

				if path == '/'
					# File object
					Objects::File.new(path, document, segment).tap { |obj| obj.parse_stream stream }
				else
					case raw_index
						when 0xFFFFFFFF
							# No data stored, indicating a group object
							Objects::Group.new(path, document, segment).tap { |obj| obj.parse_stream stream }
						when 0x69120000
							# "DAQmx Format Changing scaler"
							# TODO: Implement support for this
							raise NotImplementedError, 'DAQmx Format Changing scaler support is not implemented'
						when 0x69130000
							# "DAQmx Digital Line scaler"
							# TODO: Implement support for this
							raise NotImplementedError, 'DAQmx Digital Line scaler support is not implemented'
						when 0x00000000
							# Identical to previous segment, so clone the channel object and have it update streaming parameters
							previous_channel = document.objects.reverse.find { |object| object.path == path }
							Objects::Channel.new(path, document, segment).tap { |obj|
								obj.continue_stream stream, raw_index, previous_channel
								group = document.objects.find { |object| object.is_a? Objects::Group and object.path == Path.new(parts: path.to_a[0..-2])}
								group.channels << obj if group
							}
						else
							Objects::Channel.new(path, document, segment).tap { |obj|
								obj.parse_stream stream, raw_index
								group = document.objects.find { |object| object.is_a? Objects::Group and object.path == Path.new(parts: path.to_a[0..-2]) }
								group.channels << obj if group
							}
					end

				end
			end
		end
	end
end
