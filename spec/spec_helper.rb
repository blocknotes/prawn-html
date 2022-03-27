# frozen_string_literal: true

require 'simplecov'
require 'simplecov-lcov'

SimpleCov::Formatter::LcovFormatter.config do |c|
  c.report_with_single_file = true
  # c.single_report_path = ENV['LCOV_PATH'] if ENV['LCOV_PATH'].present?
end
simplecov_formatters = [SimpleCov::Formatter::LcovFormatter, SimpleCov.formatter]
SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new(simplecov_formatters)
SimpleCov.start do
  add_filter '/spec/'
end

require 'ostruct'
require 'prawn-html'
require 'pdf/inspector'
require 'pry'

Dir["#{__dir__}/support/**/*.rb"].sort.each { |f| require f }

Prawn::Fonts::AFM.hide_m17n_warning = true

RSpec.configure do |config|
  config.color = true
  config.tty = true

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
end
