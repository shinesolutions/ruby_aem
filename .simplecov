SimpleCov.minimum_coverage 100
SimpleCov.start do
  add_filter 'test/unit/'
  coverage_dir 'doc/coverage'
end
