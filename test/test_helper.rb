require 'minitest/autorun'

require_relative '../lib/tdms'

class Minitest::Test

	def fixture_filename(fixture_name)
		File.dirname(__FILE__) + "/fixtures/#{fixture_name}.tdms"
	end

end

