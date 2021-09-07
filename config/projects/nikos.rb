#
# Copyright 2020 YOUR NAME
#
# All Rights Reserved.
#

name "nikos"
maintainer "Sylvain Baubeau <sylvain.baubeau@datadoghq.com>"
homepage "https://github.com/DataDog/nikos"

if not ENV['NIKOS_INSTALL_DIR'].empty?
  install_dir ENV['NIKOS_INSTALL_DIR']
else
  # Defaults to C:/nikos on Windows
  # and /opt/nikos on all other platforms
  install_dir "#{default_root}/#{name}"
end

build_version Omnibus::BuildVersion.semver
build_iteration 1

# Creates required build directories
dependency "preparation"

if linux?
  dependency 'libdnf'
end


exclude "**/.git"
exclude "**/bundler/git"
