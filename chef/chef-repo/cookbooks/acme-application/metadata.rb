name 'acme-application'
maintainer 'The Authors'
maintainer_email 'noreply@rafops.github.io'
license 'All Rights Reserved'
description 'Installs/Configures acme-application'
long_description 'Installs/Configures acme-application'
version '0.1.4'
chef_version '>= 12.1' if respond_to?(:chef_version)

# The `issues_url` points to the location where issues for this cookbook are
# tracked.  A `View Issues` link will be displayed on this cookbook's page when
# uploaded to a Supermarket.
#
# issues_url 'https://github.com/<insert_org_here>/acme-application/issues'

# The `source_url` points to the development reposiory for this cookbook.  A
# `View Source` link will be displayed on this cookbook's page when uploaded to
# a Supermarket.
#
# source_url 'https://github.com/<insert_org_here>/acme-application'

# depends 'rbenv', '~> 1.7.1'
depends 'application_ruby', '~> 4.1.0'
