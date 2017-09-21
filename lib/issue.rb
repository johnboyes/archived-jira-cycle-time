require 'active_support'
require 'active_support/core_ext/object'

# JIRA Control Chart data relating to one issue
class Issue
  def initialize(raw_issue:, cycle_time_columns:, done_column:, columns:)
    @raw_issue = raw_issue
    @cycle_time_columns = cycle_time_columns
    @done_column = done_column
    @columns = columns
    @done_time = leave_times[@done_column]
  end

  def leave_times
    @raw_issue['leaveTimes'].map.each_with_index { |epoch, index| [column(index), epoch_to_time(epoch)] }.to_h
  end

  def working_times
    map_durations_from_milliseconds_to_seconds(issue['workingTime'])
  end

  def total_times
    map_durations_from_milliseconds_to_seconds(@raw_issue['totalTime'])
  end

  def column(index)
    @columns[index]['name']
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

  def key
    @raw_issue['key']
  end

  def summary
    @raw_issue['summary']
  end

  def in_progress?
    cycle_end_time.blank? || reopened_and_in_progress?
  end

  def cycle_start_time
    cycle_end_time.blank? ? '' : cycle_end_time - total_time_in_progress
  end

  def reopened_and_in_progress?
    return false if cycle_end_time.blank?
    @done_time < cycle_end_time
  end

  def cycle_end_time
    return nil unless @done_time.present?
    leave_times[column_which_has_the_cycle_end_time]
  end

  def column_which_has_the_cycle_end_time
    @cycle_time_columns.max_by { |cycle_time_column| leave_times[cycle_time_column].to_i }
  end

  def total_time_in_progress
    @cycle_time_columns.inject(0) { |total, column| total + total_times[column] }
  end
end
