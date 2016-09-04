all: deps clean build install test test-integration doc
ci: deps clean build install test doc

deps:
	gem install bundler
	bundle install

clean:
	rm -f ruby_aem-*.gem

build: clean
	gem build ruby_aem.gemspec

install: build
	gem install `ls ruby_aem-*.gem`

test:
	rspec test/unit

test-integration: install
	rspec test/integration

doc:
	yard doc

.PHONY: all ci deps clean build install test test-integration doc
