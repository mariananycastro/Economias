require 'simplecov'
SimpleCov.start 'rails' do
  add_group 'Requests', 'app/services/requests'
  add_group 'Services', 'app/services'
  add_group 'Decorators', 'app/decorators'
end

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
end
