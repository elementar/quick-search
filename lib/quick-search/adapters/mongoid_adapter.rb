module QuickSearch
  module Adapters
    class MongoidAdapter
      def initialize(cls)
        @cls = cls
      end

      def make_clauses_for_token(s, token, fields)
        s.and '$or' => fields.map { |f| { to_field_name(f) => /#{Regexp.escape token}/i } }
      end

      def default_quick_search_fields
        @cls.fields.select { |_, f| f.type == String }.map(&:first)
      end

      private

      def to_field_name(f)
        case f
          when Hash
            head = f.first
            "#{head.first}.#{to_field_name(head.last)}"
          when String, Symbol
            f
          else
            raise "Unrecognized input: #{f}"
        end
      end
    end
  end
end