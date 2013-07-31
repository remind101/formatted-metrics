require 'active_support/core_ext/module/delegation'

module Metrics

  # Internal: Responsible for handling an ActiveSupport::Notifications message.
  class Handler
    attr_reader :args

    def initialize(*args)
      @args = args
    end

    def handle
      log if trackable?
    end

  private

    delegate :configuration, to: :'Metrics'

    def trackable?
      event.payload[:measure]
    end

    def event
      @event ||= ActiveSupport::Notifications::Event.new(*args)
    end

    def log
      configuration.stream.puts configuration.formatter.new(event).to_s
    end

  end

end
