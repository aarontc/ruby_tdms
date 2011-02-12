module Tdms

  module DataType

    class Base
      attr_accessor :value
      
      def initialize(value=nil)
        @value = value
      end
    end

    class Utf8String < Base
      Id = 0x20
      LengthInBytes = nil

      def self.read_from_stream(tdms_file)
        new(tdms_file.read_utf8_string)
      end
    end
    
    class Int32 < Base
      Id = 0x03
      LengthInBytes = 4
      
      def self.read_from_stream(tdms_file)
        new(tdms_file.read_i32)
      end
    end
    
    class Double < Base
      Id = 0x0A
      LengthInBytes = 8

      def self.read_from_stream(tdms_file)
        new(tdms_file.read_double)
      end
    end

    class Timestamp < Base
      Id = 0x44
      LengthInBytes = 16
      
      def self.read_from_stream(tdms_file)
        new(tdms_file.read_timestamp)
      end
    end

    DataTypesById = {
      Utf8String::Id => Utf8String,
      Int32::Id      => Int32,
      Double::Id     => Double,
      Timestamp::Id  => Timestamp
    }

    def find_by_id(id_byte)
      DataTypesById[id_byte] || raise(ArgumentError, "Don't know type %d" % id_byte)
    end
    module_function :find_by_id

  end

end
