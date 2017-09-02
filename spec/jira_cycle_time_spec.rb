require 'application'

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
