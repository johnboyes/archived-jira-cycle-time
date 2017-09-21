require 'grape'
require_relative 'jira_control_chart_data'
require_relative 'jira_csv_exporter'

module JIRAData
  # API allowing raw JIRA control chart data to be received and translated into a CSV with the cycle times
  class API < Grape::API
    version 'v1', using: :header, vendor: 'jira-control-chart-data'
    format :json
    prefix :api

    helpers do
      def raw_control_chart_json(params)
        params.select { |key, _value| %w(issues columns currentTime workRateData).include? key }
      end
    end

    resource :cycle_time do
      # TODO: define required parameters and check their values are in correct format
      desc 'Cycle times in CSV format'
      post do
        status 200
        header 'Content-Disposition', 'attachment; filename=jira_cycle_time.csv'
        content_type 'application/csv'
        env['api.format'] = 'application/csv'
        jira_cycle_time = JIRAControlChartData.new(raw_control_chart_json: raw_control_chart_json(params),
                                                   cycle_time_columns: params[:in_progress_columns],
                                                   done_column: params[:done_column])
        JIRACSVExporter.new(jira_cycle_time).cycle_times
      end
    end
  end
end
