module Metrics
  class Configuration
    # The stream source to write to. Defaults to STDOUT.
    attr_accessor :stream

    # The base source for all metrics.
    attr_accessor :source

    # The formatter to use. Only needs to be a class that responds to `to_s`.
    # Defaults to Metrics::Formatter.
    attr_accessor :formatter

    def stream
      @stream ||= STDOUT
    end

    def source
      @source ||= ENV['METRICS_SOURCE'] || ENV['APP_NAME'] || `hostname`.chomp.underscore
    end

    def formatter
      @formatter ||= Metrics::Formatter
    end
  end
end