# # encoding: utf-8

# Inspec test for recipe workstation::setup

describe user('chefuser') do
  it { should exist }
end
