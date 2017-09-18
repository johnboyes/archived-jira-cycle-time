require 'csv'

# Converts raw json control chart data into cycle times and exports as CSV
class JiraCycleTime
  def initialize(raw_control_chart_json, cycle_time_columns)
    @raw_control_chart_json = raw_control_chart_json
    @cycle_time_columns = cycle_time_columns
  end

  def as_csv
    CSV.generate do |csv|
      csv << ['Completed Date', 'Start Date', 'Type', 'Id', 'Description']
      issues.each { |issue| csv << [completed_date(issue), start_date(issue), '', issue['key'], issue['summary']] }
    end
  end

  def completed_date(issue)
    format_for_csv(cycle_end_time(issue))
  end

  def start_date(issue)
    format_for_csv(cycle_start_time(issue))
  end

  def format_for_csv(time)
    time.strftime('%d/%m/%Y')
  end

  def cycle_start_time(issue)
    cycle_end_time(issue) - total_time_in_progress(issue)
  end

  def cycle_end_time(issue)
    issue['leaveTimes'][@cycle_time_columns.last]
  end

  def raw_control_chart_data
    @raw_control_chart_json
  end

  def control_chart_data
    raw_control_chart_data.map do |key, value|
      case key
      when 'issues' then [key, map_issues(value)]
      when 'currentTime' then [key, epoch_to_time(value)]
      when 'workRateData' then [key, map_work_rate_data(value)]
      else [key, value]
      end
    end.to_h
  end

  def map_issues(raw_issues)
    raw_issues.map do |raw_issue|
      raw_issue.tap do |issue|
        issue['totalTime'] = map_durations_from_milliseconds_to_seconds(issue['totalTime'])
        issue['workingTime'] = map_durations_from_milliseconds_to_seconds(issue['workingTime'])
        issue['leaveTimes'] = map_leave_times(issue['leaveTimes'])
      end
    end
  end

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
    control_chart_data['issues']
  end

  def column(index)
    raw_control_chart_data['columns'][index]['name']
  end

  def epoch_to_time(epoch_in_milliseconds)
    return '' if epoch_in_milliseconds == -1
    Time.at(epoch_in_milliseconds / 1000)
  end

  def map_durations_from_milliseconds_to_seconds(raw_durations)
    raw_durations.map.each_with_index { |milliseconds, index| [column(index), to_seconds(milliseconds)] }.to_h
  end

  def to_seconds(milliseconds)
    milliseconds / 1000
  end

  def map_leave_times(raw_leave_times)
    raw_leave_times.map.each_with_index { |epoch, index| [column(index), epoch_to_time(epoch)] }.to_h
  end

  def issue(key)
    issues.find { |i| i['key'] == key }
  end

  def human_readable_duration(seconds)
    [[60, :seconds], [60, :minutes], [24, :hours], [1000, :days]].map do |count, name|
      if seconds.positive?
        seconds, n = seconds.divmod(count)
        "#{n.to_i} #{name}"
      end
    end.compact.reverse.join(' ')
  end

  def total_time_in_progress(issue)
    @cycle_time_columns.inject(0) { |total, column| total + issue['totalTime'][column] }
  end
end
