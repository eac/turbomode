module TurboMode
  extend self

  module TurboRails

    def self.enable!
      Rails::Initializer.class_eval do
        def initialize_routing_with_turbo_mode
          initialize_routing_without_turbo_mode
          TurboMode.enable! do
            ActiveRecord::Base.clear_all_connections!
          end
        end
        alias_method_chain :initialize_routing, :turbo_mode
      end
    end

  end

  TurboRails.enable! if ENV['TURBO_MODE'] && ENV['RAILS_ENV']

  SIGNAL = ENV['TURBO_SIGNAL'] || 'QUIT'

  attr_accessor :after_fork

  def reload!
    Process.kill(SIGNAL, 0)
  end

  def enable!(&block)
    self.after_fork = block if block_given?
    fork!

    if parent?
      listen
      enable!
    else
      forked!
    end
  end

  def fork!
    puts "#{Process.pid}: forking"
    @child_id = fork
  end

  def parent?
    !@child_id.nil?
  end

  def listen
    puts "#{Process.pid}: listening"

    Signal.trap(SIGNAL) do
      puts 'Press enter to continue'
    end

    Process.wait2
  end

  def forked!
    puts "Turbo mode enabled (child pid #{Process.pid})"
    $SHARED_FEATURES = $".dup
    Signal.trap(SIGNAL) do
      puts "#{Process.pid}: stopped"
      exit!
    end

    after_fork.call if after_fork
  end

end
