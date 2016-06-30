deps:
	gem install bundler
	bundle install

build:
	gem build ruby_aem.gemspec

install: build
	gem install ruby_aem-0.0.1.gem

test:
	rspec test/unit

test-integration: install
	rspec test/integration

.PHONY: deps test test-integration
