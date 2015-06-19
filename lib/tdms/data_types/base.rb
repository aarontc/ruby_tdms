module TDMS
	module DataTypes
		class Base
			attr_accessor :value

			def initialize(value = nil)
				@value = value
			end

			class << self
				def subclasses
					ObjectSpace.each_object(singleton_class).select { |klass| klass < self }
				end
			end
		end
	end
end
