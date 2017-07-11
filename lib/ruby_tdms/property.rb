module RubyTDMS
	class Property
		attr_accessor :name
		attr_accessor :data # TDMS::DataTypes::Base

		def initialize(name = nil, data = nil)
			@name = name
			@data = data
		end


		def value
			data.value
		end
	end
end
