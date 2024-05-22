# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'

RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern = 'spec/**/*_spec.rb'
  t.verbose = false
end

RuboCop::RakeTask.new(:rubocop) do |t|
  t.options = ['--format', 'simple']
end

task default: :spec
