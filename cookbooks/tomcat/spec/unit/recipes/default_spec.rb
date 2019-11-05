# frozen_string_literal: true

#
# Cookbook:: tomcat
# Spec:: default
#
# Copyright:: 2019, The Authors, All Rights Reserved.

require 'spec_helper'

describe 'tomcat::default' do
  os = { 'ubuntu' => '18.04' }
  os.each do |platform, version|
    let(:chef_run) { ChefSpec::SoloRunner.new(platform: platform.to_s, version: version.to_s).converge(described_recipe) }

    it 'installs jdk 8' do
      expect(chef_run).to install_apt_package('openjdk-8-jdk')
    end
  end
end

describe 'tomcat::default' do
  os = { 'ubuntu' => '18.04', 'centos' => '7' }
  os.each do |platform, version|
    let(:chef_run) { ChefSpec::SoloRunner.new(platform: platform.to_s, version: version.to_s).converge(described_recipe) }

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    case platform.to_s
    # when 'ubuntu'
    #   it 'installs jdk 8' do
    #     expect(chef_run).to install_apt_package('openjdk-8-jdk')
    #   end
    when 'centos'
      it 'installs jdk 1.7' do
        expect(chef_run).to install_yum_package('java-1.7.0-openjdk-devel')
      end
    end

    it 'creates group tomcat' do
      expect(chef_run).to create_group('tomcat')
    end

    it 'extracts tomcat archive' do
      expect(chef_run).to install_ark('tomcat').with(
        url: 'https://archive.apache.org/dist/tomcat/tomcat-8/v8.5.45/bin/apache-tomcat-8.5.45.tar.gz',
        path: '/opt',
        prefix_root: '/opt',
        group: 'tomcat',
        version: '8.5.45',
        checksum: 'd9b58d12979243fba01bbbbb33c140c8593940c005ec9acef1b2f54ce9b3d0fc'
      )
    end

    it 'adds user tomcat' do
      expect(chef_run).to create_user('tomcat').with(
        group: 'tomcat',
        shell: '/bin/nologin',
        home: '/opt/tomcat-8.5.45'
      )
    end

    it 'creates a template' do
      expect(chef_run).to create_template('/etc/systemd/system/tomcat.service')
    end

    it 'creates a service tomcat.service' do
      expect(chef_run).to enable_systemd_unit('tomcat.service')
      expect(chef_run).to start_systemd_unit('tomcat.service')
    end
  end
end
