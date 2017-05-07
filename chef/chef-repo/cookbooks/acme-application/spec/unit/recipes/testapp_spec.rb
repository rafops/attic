#
# Cookbook:: acme-application
# Spec:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

require 'spec_helper'

describe 'acme-application::testapp' do
  context 'When all attributes are default, on an Ubuntu 16.04' do
    let(:chef_run) do
      # for a complete list of available platforms and versions see:
      # https://github.com/customink/fauxhai/blob/master/PLATFORMS.md
      runner = ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04')
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'creates application directory' do
      expect(chef_run).to create_directory('/srv/testapp')
    end

    it 'generates rack application entry file' do
      expect(chef_run).to create_cookbook_file('/srv/testapp/config.ru')
    end

    it 'generates rack application Gemfile' do
      expect(chef_run).to create_cookbook_file('/srv/testapp/Gemfile')
    end
  end
end

# https://github.com/sethvargo/chefspec/tree/master/examples
