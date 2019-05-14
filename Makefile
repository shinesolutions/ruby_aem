all: deps clean build lint install test-unit test-integration doc
ci: deps clean build lint install test-unit doc

deps:
	gem install bundler --version=1.17.3
	rm -rf .bundle
	bundle install --binstubs

clean:
	rm -f ruby_aem-*.gem Gemfile.lock

lint:
	bundle exec rubocop
	bundle exec yaml-lint .*.yml conf/*.yaml

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

release:
	rtk release

tools:
	npm install -g gh-pages@2.0.1

fixtures:
	# based on AEM documentation at https://helpx.adobe.com/experience-manager/kt/platform-repository/using/ssl-wizard-technical-video-use.html#generate-key-cert
	# you will be prompted for private key password, the integration tests are expecting 'someprivatekeypassword' as the password for the fixtures data
	mkdir -p test/integration/fixtures/
	openssl genrsa -aes256 -out test/integration/fixtures/private_key.key 4096
	openssl req -sha256 -new -key test/integration/fixtures/private_key.key -out test/integration/fixtures/cert_sign_request.csr -subj '/CN=localhost'
	openssl x509 -req -days 365 -in test/integration/fixtures/cert_sign_request.csr -signkey test/integration/fixtures/private_key.key -out test/integration/fixtures/cert_chain.crt
	openssl pkcs8 -topk8 -inform PEM -outform DER -in test/integration/fixtures/private_key.key -out test/integration/fixtures/private_key.der -nocrypt

.PHONY: all ci deps clean lint build install test-unit test-integration doc doc-publish publish release tools fixtures release
