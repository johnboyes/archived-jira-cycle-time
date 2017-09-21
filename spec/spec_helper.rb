require 'simplecov'
SimpleCov.start
require 'rspec'
require 'capybara/rspec'
require_relative '../lib/jira_data_api'

def app
  JIRAData::API
end

RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.before :each do
  end
end

def assert_last_csv_response(expected_body, expected_status = 200)
  expect(last_response.status).to eq expected_status
  expect(CSV.parse(last_response.body)).to eq expected_body
end

def post_json(url, json)
  post(url, json, 'CONTENT_TYPE' => 'application/json')
end
