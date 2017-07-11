require 'require_all'
require_rel 'data_types'

module RubyTDMS
	module DataTypes
		class << self
			def find_by_id(id)
				TYPES_BY_ID[id] || raise(ArgumentError, "No matching type for ID #{id.inspect}")
			end


			def to_hash
				Base.subclasses.reduce({}) do |result, klass|
					result[klass::ID] = klass
					result
				end
			end
		end

		TYPES_BY_ID = to_hash.freeze
	end
end
