require_relative 'spec_helper'

describe 'Package' do
  before do
    @aem = init_client

    # ensure package does not exist
    @package = @aem.package('somepackagegroup', 'somepackage', '1.2.3')
    begin
      @package.delete_wait_until_ready()
    rescue RubyAem::Error => err
      # package doesn't exist and can't be deleted
    end
  end

  after do
  end

  describe 'test package build install replicate download' do

    it 'should succeed' do
      # create package
      result = @package.create()
      expect(result.message).to eq('Package created')

      # build package
      result = @package.build()
      expect(result.message).to eq('Package built')

      # package is not installed yet
      result = @package.is_installed()
      expect(result.message).to eq('Package somepackagegroup/somepackage-1.2.3 is not installed')
      expect(result.data).to eq(false)

      # install package
      result = @package.install()
      expect(result.message).to eq('Package installed')

      # package is installed
      result = @package.is_installed()
      expect(result.message).to eq('Package somepackagegroup/somepackage-1.2.3 is installed')
      expect(result.data).to eq(true)

      # replicate package
      result = @package.replicate()
      expect(result.message).to eq('Package is replicated asynchronously')

      # download package
      result = @package.download('/tmp')
      expect(result.message).to eq('Package downloaded to /tmp/somepackage-1.2.3.zip')
    end

  end

  describe 'test package upload rebuild install replicate' do

    it 'should succeed' do
      # package is not uploaded yet
      result = @package.is_uploaded()
      expect(result.message).to eq('Package somepackagegroup/somepackage-1.2.3 is not uploaded')
      expect(result.data).to eq(false)

      # upload package
      result = @package.upload_wait_until_ready('/tmp', {
        force: true,
        _retries: {
          max_tries: 60,
          base_sleep_seconds: 2,
          max_sleep_seconds: 2
        }})
      expect(result.message).to eq('Package uploaded')

      # package is uploaded
      result = @package.is_uploaded()
      expect(result.message).to eq('Package somepackagegroup/somepackage-1.2.3 is uploaded')
      expect(result.data).to eq(true)

      # rebuild package
      result = @package.build()
      expect(result.message).to eq('Package built')

      # install package
      result = @package.install_wait_until_ready({
        _retries: {
          max_tries: 60,
          base_sleep_seconds: 2,
          max_sleep_seconds: 2
        }})
      expect(result.message).to eq('Package installed')

      # replicate package
      result = @package.replicate()
      expect(result.message).to eq('Package is replicated asynchronously')

    end

  end

  describe 'test package update get filter activate' do

    it 'should succeed when the package has filter' do
      # create package
      result = @package.create()
      expect(result.message).to eq('Package created')

      # update package filter
      result = @package.update('[{"root":"/apps/geometrixx","rules":[]},{"root":"/apps/geometrixx-common","rules":[]}]')
      expect(result.message).to eq('Package updated successfully')

      # get package filter
      result = @package.get_filter()
      expect(result.message).to eq('Filter retrieved successfully')
      expect(result.data.length).to eq(2)
      expect(result.data[0]).to eq('/apps/geometrixx')
      expect(result.data[1]).to eq('/apps/geometrixx-common')

      # activate filter in package
      results = @package.activate_filter(true, false)
      expect(results.length).to be(3)
      expect(results[0].message).to eq('Filter retrieved successfully')
      expect(results[1].message).to eq('Path /apps/geometrixx activated')
      expect(results[2].message).to eq('Path /apps/geometrixx-common activated')
    end

  end

  describe 'test package list' do

    it 'should succeed' do
      result = @package.list_all()
      expect(result.message).to eq('Package list retrieved successfully')
    end

  end

end
