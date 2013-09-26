module Metrics
  module Instrumentable

    def self.included(base)
      base.extend ClassMethods
    end

    # Public: See Metrics.instrument.
    #
    # Returns nothing.
    def instrument(*args, &block)
      Metrics.instrument(*args, &block)
    end

    module ClassMethods

      # Internal: Used internally to specify the namespace for method
      # instrumentation.
      #
      # Override this in your class if you need it to be something different.
      #
      # Example
      #
      # module Some
      #   class Namespace
      #     include Metrics::Instrumentable
      #
      #     def long_method; end
      #     instrument :long_method
      #   end
      # end
      #
      # Some::Namespace.metric_namespace
      # # => 'some.namespace'
      #
      # Some::Namespace.new.long_method
      # # => 'source=app measure.some.namespace.long_method=10s'
      #
      # Returns a String namespace for the metric.
      def metric_namespace
        to_s.gsub(/::/, '.').underscore
      end

      # Public: Wraps the method with a call to instrument the duration of the
      # method. Fancy!
      #
      # Example
      #
      #   def some_method
      #     do_something_taxing
      #   end
      #
      #   instrument :some_method
      #   # => 'source=app measure.some_method=10s'
      #
      # Returns nothing.
      def instrument(*methods)
        methods.each do |name|
          visibility = %w[public private protected].find { |visibility| send :"#{visibility}_method_defined?", name }
          method = instance_method(name)
          define_method name do |*args, &block|
            bound_method = method.bind(self)
            instrument [self.class.metric_namespace, name].join('.') do
              bound_method.call(*args, &block)
            end
          end
          send visibility, name
        end
      end

    end
  end
end
