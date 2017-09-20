require 'spec_helper'

feature 'JIRA cycle times CSV export' do
  scenario 'valid request with raw control chart data' do
    expected = [
      ['Completed Date', 'Start Date', 'Type', 'Id', 'Description'],
      ['03/09/2017', '03/09/2017', '', 'AUTOMATED-14', 'Sunday afternoon issue'],
      ['03/09/2017', '03/09/2017', '', 'AUTOMATED-13', 'Sunday morning issue']
    ]
    post_json('/api/cycle_time?in_progress_columns[]=In+Progress&done_column=Done',
              File.read('example_raw_jira_data.json'))
    assert_last_csv_response expected
  end

  scenario 'valid request with data that has issues that are still in progress' do
    expected = [
      ['Completed Date', 'Start Date', 'Type', 'Id', 'Description'],
      ['03/09/2017', '03/09/2017', '', 'AUTOMATED-13', 'Sunday morning issue']
    ]
    json = File.read('example_raw_jira_data_with_in_progress_issue.json')
    post_json('/api/cycle_time?in_progress_columns[]=In+Progress&done_column=Done', json)
    assert_last_csv_response expected
  end
end
