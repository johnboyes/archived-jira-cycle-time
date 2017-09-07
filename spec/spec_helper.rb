require 'rake'
require 'simplecov'

SimpleCov.start

def delete_csv_file
  File.delete(CSV_EXPORT_PATH) if File.exist?(CSV_EXPORT_PATH)
end

# fix for RSpec/Rake bug - see https://github.com/rspec/rspec-core/issues/2314#issuecomment-241253384
module Rake
  class Application
    def handle_options
      options.rakelib = ['rakelib']
      options.trace_output = $stderr
      option_parser
    end

    def option_parser
      OptionParser.new do |opts|
        opts.banner = "#{Rake.application.name} [-f rakefile] {options} targets..."
        opts.separator ''
        opts.separator 'Options are ...'
        print_on_tail(opts)
        standard_rake_options.each { |args| opts.on(*args) }
        opts.environment('RAKEOPT')
      end.parse(sanitise_command_line_arguments(ARGV))
    end

    def print_on_tail(opts)
      opts.on_tail('-h', '--help', '-H', 'Display this help message.') do
        puts opts
        exit
      end
    end

    # This is the fix - we don't want the command line arguments to be parsed when running Rake in RSpec
    def sanitise_command_line_arguments(_args)
      []
    end
  end
end

RSpec.configure do |config|
  config.before(:suite) do
    Rake.application.init
    Rake.application.load_rakefile
  end
end
