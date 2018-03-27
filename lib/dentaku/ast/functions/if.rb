require_relative '../function'

module Dentaku
  module AST
    class If < Function
      attr_reader :predicate, :left, :right

      def initialize(predicate, left, right)
        @predicate = predicate
        @left      = left
        @right     = right
      end

      def value(context = {})
        predicate.value(context) ? left.value(context) : right.value(context)
      end

      def string_value(context = {})
        "IF(#{context[predicate.left.identifier]} #{predicate.operator.to_s} #{predicate.right.value}, #{left.value}, #{right.value})"
      end

      def node_type
        :condition
      end

      def type
        left.type
      end

      def dependencies(context = {})
        # TODO : short-circuit?
        (predicate.dependencies(context) + left.dependencies(context) + right.dependencies(context)).uniq
      end
    end
  end
end

Dentaku::AST::Function.register_class(:if, Dentaku::AST::If)
