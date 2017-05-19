require_relative 'spec_helper'

describe 'Path' do
  before do
    @aem = init_client
  end

  after do
  end

  describe 'test path activation' do
    it 'should succeed when path exists' do
      path = @aem.path('/etc/designs/cloudservices')
      result = path.activate(true, false)
      expect(result.message).to eq('Path /etc/designs/cloudservices activated')
    end

    # tree activation returns 200 regardless whether the path exists or not
    it 'should still succeed when path does not exist' do
      path = @aem.path('/some/inexisting/path')
      result = path.activate(true, false)
      expect(result.message).to eq('Path /some/inexisting/path activated')
    end
  end
end
