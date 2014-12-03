module QuickSearch
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    # Defines the fields that will be available to the quick search.
    # If a hash is used on ActiveRecord, an +inner join+ will be made.
    def quick_search_fields(*fields)
      @quick_search_fields = fields
    end

    # Adds an expression to the quick search. Several expressions can be added, but only the first one
    # that matches the search token will be ran.
    # @param [Regexp] rx A regular expression, in which to test the quick search tokens.
    # @param [Proc] proc The proc to run when the token matches. It will receive the +MatchData+ as parameter.
    def quick_search_expression(rx, proc)
      (@quick_search_expressions ||= {})[rx] = proc
    end

    # Performs a quick search.
    def quick_search(search)
      adapter = create_adapter # fail fast, if the adapter can not be created

      relation = adapter.prepare_relation(all)

      (search || '').split(/\s+/).each do |token|
        next unless token.present?

        if exprs = eval_expressions(relation, token)
          relation = exprs
          next
        end

        relation = adapter.make_clauses_for_token(relation, token)
      end
      relation
    end

    private

    def create_adapter
      @adapter_class ||= begin
        if defined?(ActiveRecord) && defined?(ActiveRecord::Base) && self < ActiveRecord::Base
          require 'quick-search/adapters/active_record_adapter'
          Adapters::ActiveRecordAdapter
        elsif defined?(Mongoid) && defined?(Mongoid::Document) && self < Mongoid::Document
          require 'quick-search/adapters/mongoid_adapter'
          Adapters::MongoidAdapter
        else
          raise UnsupportedAdapter.new self.name
        end
      end

      @adapter_class.new(self, @quick_search_fields)
    end

    # Evaluates the expressions defined by #quick_search_expression.
    # @return [Object] the new query, or +nil+ if there's no expression matching the token.
    def eval_expressions(s, token)
      return nil if @quick_search_expressions.blank?
      @quick_search_expressions.each do |rx, proc|
        if m = (/\A(?:#{rx})\z/.match(token))
          s = s.instance_exec(m, &proc)
          return s
        end
      end
      nil
    end
  end

  class UnsupportedAdapter < RuntimeError
    DEFAULT_MESSAGE = 'QuickSearch could not find an adapter for your class: %s'

    def initialize(cls, *args)
      super(sprintf(DEFAULT_MESSAGE, cls), *args)
    end
  end
end
