lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'application'

task default: 'export:csv'

desc 'Export cycle time data'
namespace 'export' do
  task :csv do
    create_cycle_time_csv
    puts "Created #{CSV_EXPORT_PATH}"
  end
end
