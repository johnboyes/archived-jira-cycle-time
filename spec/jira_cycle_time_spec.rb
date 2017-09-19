require 'spec_helper'

EXPECTED = [
  ['Completed Date', 'Start Date', 'Type', 'Id', 'Description'],
  ['03/09/2017', '03/09/2017', '', 'AUTOMATED-14', 'Sunday afternoon issue'],
  ['03/09/2017', '03/09/2017', '', 'AUTOMATED-13', 'Sunday morning issue']
]

feature 'JIRA cycle times CSV export' do
  scenario 'valid request with raw control chart data' do
    post_json('/api/cycle_time?in_progress_columns[]=In+Progress', File.read('story.json'))
    assert_last_csv_response EXPECTED
  end
end
