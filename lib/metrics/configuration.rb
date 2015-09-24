require 'logger'

module Metrics
  class Configuration
    # The driver to use.
    #
    # Drivers are objects that implement the following method:
    #
    #     driver.write(*instrumenters) # => instrumenters written
    #
    # Defaults to Metrics::Drivers::L2Met.new(logger, source).
    attr_accessor :driver

    # The stream source to write to. Defaults to STDOUT.
    attr_accessor :logger

    # The base source for all metrics.
    attr_accessor :source

    def driver
      @driver ||= Metrics::Drivers::L2Met.new(logger, source)
    end

    def logger
      @logger ||= Logger.new(STDOUT).tap { |log| log.formatter = log_formatter }
    end

    def log_formatter
      proc { |severity, datetime, progname, msg| "#{msg}\n" }
    end

    def source
      return @source if defined? @source
      @source = ENV['METRICS_SOURCE'] || ENV['APP_NAME'] || `hostname`.chomp
    end
  end
end
