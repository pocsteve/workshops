# frozen_string_literal: true

#
# Cookbook:: centos7
# Recipe:: default
#
# Copyright:: 2019, The Authors, All Rights Reserved.

# include_recipe 'audit::default'
include_recipe 'centos7::set_security_hardening'
