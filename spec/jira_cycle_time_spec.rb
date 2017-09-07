require 'spec_helper'
require 'application'

describe 'Export JIRA issue cycle time data' do
  let(:cycle_times) { CSV.read(CSV_EXPORT_PATH) }

  before do
    delete_csv_file
    Rake::Task['export:csv'].invoke
  end

  after do
    delete_csv_file
  end

  it 'exports the JIRA issue cycle times in a CSV file' do
    expect(cycle_times).to match [
      a_collection_containing_exactly('Completed Date', 'Start Date', 'Type', 'Id', 'Description'),
      a_collection_containing_exactly('03/09/2017', '03/09/2017', '', 'AUTOMATED-14', 'Sunday afternoon issue'),
      a_collection_containing_exactly('03/09/2017', '03/09/2017', '', 'AUTOMATED-13', 'Sunday morning issue')
    ]
  end
end

describe 'JIRA issue cycle time' do
  issues.each do |the_issue|
    describe the_issue['key'] do
      let(:the_issue) { the_issue }

      it 'always has a start time before the end time' do
        expect(cycle_start_time(the_issue)).to be < cycle_end_time(the_issue)
      end

      it 'has a difference between cycle start time and end time which is same as total time in progress' do
        expect(cycle_end_time(the_issue) - cycle_start_time(the_issue)).to eq total_time_in_progress(the_issue)
      end
    end
  end
end
