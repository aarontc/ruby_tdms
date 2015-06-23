require_rel 'objects'

module TDMS
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
							# Identical to previous segment
							raise "reused object meta data -- handle this!"
						else
							Objects::Channel.new(path, document, segment).tap { |obj|
								obj.parse_stream stream, raw_index
								document.objects[-1].channels << obj if document.objects[-1]
							}
					end

				end
			end
		end
	end
end
