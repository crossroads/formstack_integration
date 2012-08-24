module FormstackIntegration

  #
  # Converters take strings from formstack and serialize them into the
  # appropriate ruby object
  #
  module Converters

    #
    # Maps 'true' and 'false' to ruby booleans
    #
    class BooleanConverter
      def initialize(str)
        @str = str
      end
      def convert
        !@str.blank? and @str.downcase == 'true'
      end
    end

    #
    # Maps date strings to ruby Date using Date.parse
    #
    class DateConverter
      def initialize(str)
        @str = str
      end
      def convert
        !@str.blank? ? Date.parse(@str) : nil
      end
    end

    #
    # Maps strings separated with '\\n' to an Array
    #
    class ArrayConverter
      def initialize(str)
        @str = str
      end
      def convert
        !@str.blank? ? @str.split("\n") : []
      end
    end

  end

end
