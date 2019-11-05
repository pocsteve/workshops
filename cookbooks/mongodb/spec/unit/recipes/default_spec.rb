# frozen_string_literal: true

#
# Cookbook:: mongodb
# Spec:: default
#
# Copyright:: 2019, The Authors, All Rights Reserved.

require 'spec_helper'

describe 'mongodb::default' do
  context 'When all attributes are default, on Ubuntu 18.04' do
    let(:chef_run) { ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '18.04').converge(described_recipe) }

    it 'installs package mongodb-org' do
      expect(chef_run).to install_apt_package('mongodb-org')
    end

    it 'adds apt repository mongodb-org-4.2' do
      expect(chef_run).to add_apt_repository('mongodb-org-4.2').with(
        arch: 'amd64',
        uri: 'http://repo.mongodb.org/apt/ubuntu',
        distribution: 'bionic/mongodb-org/4.2',
        components: ['multiverse'],
        trusted: true
      )
    end

    it 'enables and starts mongod service' do
      expect(chef_run).to enable_service('mongod')
      expect(chef_run).to start_service('mongod')
    end
  end

  context 'When all attributes are default, on CentOS 7' do
    let(:chef_run) { ChefSpec::SoloRunner.new(platform: 'centos', version: '7').converge(described_recipe) }

    it 'installs package mongodb-org' do
      expect(chef_run).to install_yum_package('mongodb-org')
    end

    it 'creates yum repository mongodb' do
      expect(chef_run).to create_yum_repository('mongodb').with(
        baseurl: 'https://repo.mongodb.org/yum/redhat/$releasever/mongodb-org/4.2/x86_64/',
        gpgcheck: false,
        enabled: true
      )
    end

    it 'enables and starts mongod service' do
      expect(chef_run).to enable_service('mongod')
      expect(chef_run).to start_service('mongod')
    end
  end
end
