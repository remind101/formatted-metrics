require 'active_support/core_ext/module/delegation'
require 'active_support/core_ext/string/inflections'

module Metrics

  # Internal: Responsible for taking an event and formatting it to be consumed
  # by l2met.
  #
  # Example
  #
  #   Formatter.new(event).to_s
  #   # => "source=my-app measure.rack.request=50ms"
  #
  # Returns a Metrics::Formatter.to_s
  class Formatter
    DEFAULT_UNITS = 'ms'.freeze

    # An object that conforms to the same public interface as
    # ActiveSupport::Notifications::Event
    attr_reader :event

    def initialize(event)
      @event = event
    end

    def to_s
      "source=#{source} measure.#{event_name}=#{value}"
    end

  private

    delegate :name, :payload, :duration, to: :event, prefix: true
    delegate :configuration, to: :'Metrics'

    def value
      case measurement = event_payload[:measure]
      when true
        [event_duration, DEFAULT_UNITS].join('')
      else
        if units = event_payload[:units]
          [measurement, units].join('')
        else
          measurement
        end
      end
    end

    def source
      [configuration.source, Array(event_payload[:source])].flatten.join('.')
    end
  end

end
