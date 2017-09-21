require 'active_support'
require 'active_support/core_ext/object'
require_relative 'issue'

# Encapsulation of the data for one JIRA Control Chart
class JIRAControlChartData
  def initialize(raw_control_chart_json:, cycle_time_columns:, done_column:)
    @raw_control_chart_json = raw_control_chart_json
    @cycle_time_columns = cycle_time_columns
    @done_column = done_column
  end

  def raw_control_chart_data
    @raw_control_chart_json
  end

  def issues
    @issues ||= @raw_control_chart_json['issues'].map do |raw_issue|
      Issue.new(raw_issue: raw_issue, cycle_time_columns: @cycle_time_columns, done_column: @done_column,
                columns: columns)
    end
  end

  def columns
    raw_control_chart_data['columns']
  end

  def column(index)
    raw_control_chart_data['columns'][index]['name']
  end
end
