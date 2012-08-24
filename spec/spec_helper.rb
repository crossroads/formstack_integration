require 'rubygems'
require 'spork'

Spork.prefork do

  ENV["RAILS_ENV"] ||= 'test'
  require 'rspec/autorun'
  require 'vcr'

  RSpec.configure do |config|
    # Run specs in random order to surface order dependencies. If you find an
    # order dependency and want to debug it, you can fix the order by providing
    # the seed, which is printed after each run.
    #     --seed 1234
    config.order = "random"
    
    config.extend VCR::RSpec::Macros
  end
  
  VCR.config do |config|
    config.cassette_library_dir = File.dirname(__FILE__) + '/fixtures/vcr_cassettes'
    config.stub_with :webmock
  end
  
end

Spork.each_run do
end
