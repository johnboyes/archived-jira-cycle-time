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

  # TODO: this method is in two classes.  Extract to one common time helper type class?
  def epoch_to_time(epoch_in_milliseconds)
    return '' if epoch_in_milliseconds == -1
    Time.at(epoch_in_milliseconds / 1000)
  end

  def control_chart_data
    raw_control_chart_data.map do |key, value|
      case key
      when 'currentTime' then [key, epoch_to_time(value)]
      when 'workRateData' then [key, map_work_rate_data(value)]
      else [key, value]
      end
    end.to_h
  end

  # TODO: Extract WorkRate class?
  def map_work_rate_data(raw_work_rate_data)
    raw_work_rate_data.map do |key, value|
      case key
      when 'rates' then [key, map_rates(value)]
      else [key, value]
      end
    end.to_h
  end

  def map_rates(raw_rates)
    raw_rates.map do |raw_rate|
      raw_rate.tap do |rate|
        rate['start'] = epoch_to_time(rate['start'])
        rate['end'] = epoch_to_time(rate['end'])
      end
    end
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
