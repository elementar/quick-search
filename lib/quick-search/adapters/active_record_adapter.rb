module QuickSearch
  module Adapters
    class ActiveRecordAdapter
      def initialize(cls)
        @cls = cls
      end

      def make_clauses_for_token(s, token, fields)
        s = s.joins calculate_needed_joins(fields)
        s = s.where build_parameterized_condition(fields, :s),
                    s: "%#{token}%"
        s
      end

      def default_quick_search_fields
        @cls.columns.select { |c| c.type == :string }.map(&:name)
      end

      private

      def calculate_needed_joins(a, stack = [], &block)
        case a
          when Hash
            a.map { |k, v| calculate_needed_joins(v, stack + [k], &block) }.compact
          when Array
            a.map { |v| calculate_needed_joins(v, stack, &block) }.compact
          when String, Symbol
            stack.reverse.reduce(nil) { |h, v| h && { v => h } || v }
          else
            raise "Unrecognized input: #{a.inspect} (#{a.class.name})"
        end
      end

      def build_parameterized_condition(f, n, cls = @cls)
        case f
          when Hash
            f.map { |k, v| build_parameterized_condition(v, n, cls.reflect_on_association(k).klass) } * ' or '
          when Array
            f.map { |ff| build_parameterized_condition(ff, n, cls) } * ' or '
          when String, Symbol
            "`#{cls.table_name}`.`#{f}` like :#{n}"
          else
            raise "Unrecognized input: #{f.inspect} (#{f.class.name})"
        end
      end
    end
  end
end