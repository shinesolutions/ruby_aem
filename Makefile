all: deps build install test test-integration doc
ci: deps build install test doc

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

doc:
	yard doc

.PHONY: deps test test-integration
