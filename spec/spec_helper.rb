require 'bundler/setup'
Bundler.require

Metrics.configuration.driver = Metrics::Drivers::L2Met.new(Logger.new('/dev/null'), 'app')
