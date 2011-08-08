### What's this?

Turbo mode makes reloading code fast and easy.

### Usage

  1. To reload, Ctrl+\ (or kill -SIGQUIT child_pid)
  2. Note that 'exit' doesn't quite work at the moment. Use Ctrl+C to exit.

### Setup

#### Rails

  1. TURBO_MODE=true script/console
    * Files loaded before route initialization won't be reloadable: (e.g. Gemfile, initializers, and any app files referenced during startup)
    * Files not yet loaded will be reloadable (most models, views, and controllers)

#### Not Rails

```ruby
   # a bunch of code that won't be reloadable

  TurboMode.enable! do
    # after_fork hooks:
    # ActiveRecord::Base.clear_all_connections!
  end

  # a bunch of code that will be reloadable
```

#### Configuration

  1. ENV['TURBO_SIGNAL'] - The signal used to request reloads. e.g. TURBO_SIGNAL=HUP


### Things it breaks

  1 SIGQUIT is captured. This breaks the exit method, but provides the reload shortcut Ctrl+\
  2 Let's find out.
