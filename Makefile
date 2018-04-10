all: deps clean build lint install test-unit test-integration doc
ci: deps clean build lint install test-unit doc

deps:
	gem install bundler
	rm -rf .bundle
	bundle install --binstubs

clean:
	rm -f ruby_aem-*.gem

lint:
	bundle exec rubocop

build: clean
	gem build ruby_aem.gemspec

install: build
	gem install `ls ruby_aem-*.gem`

test-unit:
	bundle exec rspec test/unit

test-integration: install
	bundle exec rspec test/integration

doc:
	bundle exec yard doc --output-dir doc/api/master/

doc-publish:
	gh-pages --dist doc/

publish:
	gem push `ls ruby_aem-*.gem`

tools:
	npm install -g gh-pages

.PHONY: all ci deps clean build lint install test-unit test-integration doc doc-publish publish tools
