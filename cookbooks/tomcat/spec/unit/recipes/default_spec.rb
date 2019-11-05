# frozen_string_literal: true

#
# Cookbook:: tomcat
# Spec:: default
#
# Copyright:: 2019, The Authors, All Rights Reserved.

require 'spec_helper'

describe 'tomcat::default' do
  context 'When all attributes are default, on CentOS 7' do
    let(:chef_run) { ChefSpec::SoloRunner.new(platform: 'centos', version: '7').converge(described_recipe) }

    it 'creates group tomcat' do
      expect(chef_run).to create_group('tomcat')
    end

    it 'adds user tomcat to group tomcat' do
      expect(chef_run).to create_user('tomcat').with(
        group: 'tomcat'
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
