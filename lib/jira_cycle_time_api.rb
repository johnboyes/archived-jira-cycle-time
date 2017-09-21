require 'grape'
require_relative 'jira_cycle_time'

module JIRAControlChartData
  # API allowing raw JIRA control chart data to be received and translated into a CSV with the cycle times
  class API < Grape::API
    version 'v1', using: :header, vendor: 'jira-control-chart-data'
    format :json
    prefix :api

    helpers do
      def raw_control_chart_json(params)
        params.select { |k, _v| %w(issues columns currentTime workRateData).include? k }
      end
    end

    resource :cycle_time do
      desc 'Cycle times in CSV format'
      post do
        status 200
        header 'Content-Disposition', 'attachment; filename=jira_cycle_time.csv'
        content_type 'application/csv'
        env['api.format'] = 'application/csv'
        JiraCycleTime.new(raw_control_chart_json: raw_control_chart_json(params),
                          cycle_time_columns: params[:in_progress_columns],
                          done_column: params[:done_column]).as_csv
      end
    end
  end
end
