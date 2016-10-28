require_relative 'spec_helper'

describe 'Package' do
  before do
    @aem = init_client

    # ensure package does not exist
    @package = @aem.package('somepackagegroup', 'somepackage', '1.2.3')
    result = @package.delete()
  end

  after do
  end

  describe 'test package build install replicate download' do

    it 'should succeed' do
      # create package
      result = @package.create()
      expect(result.is_success?).to be(true)
      expect(result.message).to eq('Package created')

      # build package
      result = @package.build()
      expect(result.is_success?).to be(true)
      expect(result.message).to eq('Package built')

      # package is not installed yet
      result = @package.is_installed()
      expect(result.is_success?).to be(false)
      expect(result.message).to eq('Package somepackagegroup/somepackage-1.2.3 is not installed')

      # install package
      result = @package.install()
      expect(result.is_success?).to be(true)
      expect(result.message).to eq('Package installed')

      # package is installed
      result = @package.is_installed()
      expect(result.is_success?).to be(true)
      expect(result.message).to eq('Package somepackagegroup/somepackage-1.2.3 is installed')

      # replicate package
      result = @package.replicate()
      expect(result.is_success?).to be(true)
      expect(result.message).to eq('Package is replicated asynchronously')

      # download package
      result = @package.download('/tmp')
      expect(result.is_success?).to be(true)
      expect(result.message).to eq('Package downloaded to /tmp/somepackage-1.2.3.zip')
    end

  end

  describe 'test package upload rebuild install replicate' do

    it 'should succeed' do
      # package is not uploaded yet
      result = @package.is_uploaded()
      expect(result.is_success?).to be(false)
      expect(result.message).to eq('Package somepackagegroup/somepackage-1.2.3 is not uploaded')

      # upload package
      result = @package.upload('/tmp', true)
      expect(result.is_success?).to be(true)
      expect(result.message).to eq('Package uploaded')

      # package is uploaded
      result = @package.is_uploaded()
      expect(result.is_success?).to be(true)
      expect(result.message).to eq('Package somepackagegroup/somepackage-1.2.3 is uploaded')

      # rebuild package
      result = @package.build()
      expect(result.is_success?).to be(true)
      expect(result.message).to eq('Package built')

      # install package
      result = @package.install()
      expect(result.is_success?).to be(true)
      expect(result.message).to eq('Package installed')

      # replicate package
      result = @package.replicate()
      expect(result.is_success?).to be(true)
      expect(result.message).to eq('Package is replicated asynchronously')

    end

  end

  describe 'test package update get filter activate' do

    it 'should succeed when the package has filter' do
      # create package
      result = @package.create()
      expect(result.is_success?).to be(true)
      expect(result.message).to eq('Package created')

      # update package filter
      result = @package.update('[{"root":"/apps/geometrixx","rules":[]},{"root":"/apps/geometrixx-common","rules":[]}]')
      expect(result.is_success?).to be(true)
      expect(result.message).to eq('Package updated successfully')

      # get package filter
      result = @package.get_filter()
      expect(result.is_success?).to be(true)
      expect(result.message).to eq('Filter retrieved successfully')
      expect(result.data.length).to eq(2)
      expect(result.data[0]).to eq('/apps/geometrixx')
      expect(result.data[1]).to eq('/apps/geometrixx-common')

      # activate filter in package
      results = @package.activate_filter(true, false)
      expect(results.length).to be(3)
      expect(results[0].is_success?).to be(true)
      expect(results[0].message).to eq('Filter retrieved successfully')
      expect(results[1].is_success?).to be(true)
      expect(results[1].message).to eq('Path /apps/geometrixx activated')
      expect(results[2].is_success?).to be(true)
      expect(results[2].message).to eq('Path /apps/geometrixx-common activated')
    end

  end

  describe 'test package list' do

    it 'should succeed' do
      result = @package.list_all()
      expect(result.is_success?).to be(true)
      expect(result.message).to eq('Package list retrieved successfully')
    end

  end

end