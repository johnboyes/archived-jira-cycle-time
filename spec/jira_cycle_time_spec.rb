require 'spec_helper'

feature 'JIRA cycle times CSV export' do
  expected = [
    ['Completed Date', 'Start Date', 'Type', 'Id', 'Description'],
    ['03/09/2017', '03/09/2017', '', 'AUTOMATED-14', 'Sunday afternoon issue'],
    ['03/09/2017', '03/09/2017', '', 'AUTOMATED-13', 'Sunday morning issue']
  ]
  scenario 'valid request with raw control chart data' do
    post_json('/api/cycle_time?in_progress_columns[]=In+Progress', File.read('example_raw_jira_data.json'))
    assert_last_csv_response expected
  end

  scenario 'valid request with data that has issues that are still in progress' do
    expected = [
      ['Completed Date', 'Start Date', 'Type', 'Id', 'Description'],
      ['03/09/2017', '03/09/2017', '', 'AUTOMATED-13', 'Sunday morning issue']
    ]
    json = File.read('example_raw_jira_data_with_in_progress_issue.json')
    post_json('/api/cycle_time?in_progress_columns[]=In+Progress', json)
    assert_last_csv_response expected
  end
end
