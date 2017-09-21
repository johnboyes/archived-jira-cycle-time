require 'csv'

# Exports JIRA Control Chart data into CSV format, e.g. the cycle times
class JIRACSVExporter
  def initialize(jira_cycle_time)
    @jira_cycle_time = jira_cycle_time
  end

  def cycle_times
    CSV.generate do |csv|
      csv << ['Completed Date', 'Start Date', 'Type', 'Id', 'Description']
      @jira_cycle_time.issues.each { |issue| csv << CycleTimeCSVRow.new(issue).generate unless issue.in_progress? }
    end
  end

  # Translates an issue's cycle time data into an array which can be used for one row in the cycle time CSV
  class CycleTimeCSVRow
    def initialize(issue)
      @issue = issue
    end

    def generate
      [format_time(@issue.cycle_end_time), format_time(@issue.cycle_start_time), '', @issue.key, @issue.summary]
    end

    private

    def format_time(time)
      time.blank? ? '' : time.strftime('%d/%m/%Y')
    end
  end
end
