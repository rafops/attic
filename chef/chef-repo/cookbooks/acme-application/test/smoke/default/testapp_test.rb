# # encoding: utf-8

# Inspec test for recipe acme-application::testapp

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

describe directory('/srv/testapp') do
  it { should exist }
end

describe file('/srv/testapp/config.ru') do
  it { should exist }
end

describe port(8000) do
  it { should be_listening }
end
