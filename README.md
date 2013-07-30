# Formatted Metrics

Easily produce metrics that can be consumed by [l2met](https://github.com/ryandotsmith/l2met).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'formatted-metrics'
```

## Usage

### Rails

You're done!

### Rack

Call `Metrics.setup` when you app boots.

### Instrument

Use `Metrics.instrument` to instrument events to STDOUT.

```ruby
Metrics.instrument 'rack.request' do
  @app.call(env)
end
# => 'source=app measure.rack.request=50ms'

Metrics.instrument 'workers.busy', 10, units: 'workers'
# => 'source=app measure.workers.busy=10workers'

Metrics.instrument 'sidekiq.queue', source: 'background' do
  yield
end
# => 'source=app.background measure.sidekiq.queue=500ms'
```

## TODO

* Add Rack middleware for outputting rack performance metrics.
* Instrument some default rails stuff.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
