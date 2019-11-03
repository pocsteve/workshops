# frozen_string_literal: true

require 'chefspec'
require 'chefspec/policyfile'

describe 'tomcat::default' do
  context 'When all attributes are default, on a RHEL-based system' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new(platform: 'centos', version: '7')
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end
  end
end
