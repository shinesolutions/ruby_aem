all: clean deps build lint install test-unit test-integration doc

# Everything that runs without a live AEM, as run by the CI workflow.
# test-integration is left out because it needs a running AEM instance (see README Testing)
ci: clean deps build lint install test-unit doc

# Gemfile.lock is removed too, so deps resolves the dependencies afresh
clean:
	rm -f ruby_aem-*.gem Gemfile.lock

deps:
	gem install bundler --version=4.0.22
	rm -rf .bundle
	bundle install
	bundle binstubs --all

# yamllint runs with its default rules, exceptions are marked inline in each YAML file.
# markdownlint-cli2 reads its rules from .markdownlint.yaml
lint:
	bundle exec rubocop
	bundle exec yaml-lint .*.yml conf/*.yaml
	yamllint .markdownlint.yaml .rubocop.yml .github/workflows/*.yaml conf/*.yaml
	markdownlint-cli2 README.md

build: clean
	gem build ruby_aem.gemspec

install: build
	gem install `ls ruby_aem-*.gem`

# Unit tests, fails when line coverage is below the .simplecov minimum
test-unit:
	bundle exec rspec test/unit

# Needs a running AEM instance, configured with the aem_* environment variables (see README Testing)
test-integration: install
	bundle exec rspec test/integration

# Generate the API reference (YARD) for the current branch into doc/api/master/
doc:
	bundle exec yard doc --output-dir doc/api/master/

# Push doc/ to the gh-pages branch, needs the gh-pages CLI from make tools
doc-publish:
	gh-pages --dist doc/

publish: install
	gem push `ls ruby_aem-*.gem`

release-major:
	rtk release --release-increment-type major

release-minor:
	rtk release --release-increment-type minor

release-patch:
	rtk release --release-increment-type patch

release: release-minor

# Install the gh-pages CLI used by doc-publish
tools:
	npm install -g gh-pages@2.0.1

# Regenerate the SSL key and certificate fixtures used by the integration tests.
# Based on AEM documentation at https://helpx.adobe.com/experience-manager/kt/platform-repository/using/ssl-wizard-technical-video-use.html#generate-key-cert
# You will be prompted for the private key password, the integration tests expect 'someprivatekeypassword'
fixtures:
	mkdir -p test/integration/fixtures/
	openssl genrsa -aes256 -out test/integration/fixtures/private_key.key 4096
	openssl req -sha256 -new -key test/integration/fixtures/private_key.key -out test/integration/fixtures/cert_sign_request.csr -subj '/CN=localhost'
	openssl x509 -req -days 365 -in test/integration/fixtures/cert_sign_request.csr -signkey test/integration/fixtures/private_key.key -out test/integration/fixtures/cert_chain.crt
	openssl pkcs8 -topk8 -inform PEM -outform DER -in test/integration/fixtures/private_key.key -out test/integration/fixtures/private_key.der -nocrypt

.PHONY: all ci clean deps lint build install test-unit test-integration doc doc-publish publish release-major release-minor release-patch release tools fixtures
