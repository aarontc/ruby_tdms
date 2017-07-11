require_relative 'base'

module RubyTDMS
	module Objects
		class File < Base

			def as_json
				super.reject { |key, value| key == :path }
			end
		end
	end
end
