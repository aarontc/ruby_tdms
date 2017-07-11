module RubyTDMS
	class Path
		PATH_MATCHER = /(?:(?<!\\))\//
		RAW_MATCHER = /(?:^|(?<='))\/(?:(?=')|$)/

		# Can initialize with parts, path, or raw. Elements can contain / only in raw or parts forms.
		def initialize(options = {})
			raise ArgumentError, 'Initialize with at most one of +parts+, +path+, or +raw+.' if options.length > 1
			@parts = options[:parts] || []
			self.path = options[:path] if options.has_key? :path
			self.raw = options[:raw] if options.has_key? :raw
		end


		def dump
			to_s
		end


		def hash
			to_s.hash
		end


		def inspect
			"#<#{self.class.name}:#{self.object_id} path=#{path.inspect}>"
		end


		def load(string)
			self.path = string
		end


		def path
			'/' + @parts.map{ |part| part.gsub('/', '\/') }.join('/')
		end


		def path=(value)
			@parts = value._?('').split(PATH_MATCHER).reject { |x| x.length == 0 }.map { |part| decode_part part }
		end


		def raw
			'/' + @parts.map { |part| encode_part part }.join('/')
		end


		def raw=(value)
			@parts = value._?('').split(RAW_MATCHER).reject { |x| x.length == 0 }.map { |part| decode_raw_part part }
		end


		def to_a
			@parts
		end


		def to_s
			path
		end


		def ==(other)
			if other.is_a? String
				self.to_s == other
			elsif other.is_a? self.class
				self.dump == other.dump
			else
				super
			end
		end

		alias eql? ==


		protected

		def decode_part(part)
			part.gsub(/\\\//, '/')
		end


		def decode_raw_part(part)
			part.gsub(/(^'|'$)/, '').gsub(/''/, "'")
		end


		# Pure part representation -> raw encoded representation
		# "my / part's / awesomeness" -> "'my / part''s / awesomeness'"
		def encode_part(part)
			"'#{part.gsub(/'/, "''")}'"
		end
	end

end
