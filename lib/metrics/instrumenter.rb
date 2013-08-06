module Metrics
  # Public: Responsible for sampling a measurement of something.
  #
  # metric - The name of the metric to measure (e.g. rack.request.time)
  #
  # Returns a new Metrics::Instrumenter.
  class Instrumenter
    TIME_UNITS = 'ms'.freeze

    attr_reader :metric

    def self.instrument(*args, &block)
      instrument = new(*args, &block)
      instrument.value
      instrument
    end

    def initialize(metric, *args, &block)
      @metric  = metric
      @options = extract_options!(args)
      @block   = block
      @value   = args.first if args.length > 0
    end

    # Public: Runs the instrumenter.
    #
    # Returns the run time if a block was supplied.
    # Returns the value if the 
    def value
      timing? ? time : @value
    end

    def units
      timing? ? TIME_UNITS : options[:units]
    end

    def source
      options[:source]
    end

  private
    attr_reader :options, :block

    def timing?
      !block.nil?
    end

    def time
      @time ||= begin
        start = Time.now
        block.call
        (Time.now - start) * 1000.0
      end
    end

    def extract_options!(options)
      if options.last.is_a?(Hash)
        options.pop
      else
        {}
      end
    end
  end
end
