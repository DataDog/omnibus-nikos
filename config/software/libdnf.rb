#
# Copyright:: Chef Software, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require './lib/cmake.rb'

name "libdnf"
default_version "0.54.2"

dependency 'libmodulemd'
dependency 'librepo'
dependency 'libsolv'
dependency 'glib'
dependency 'json-c'
dependency 'gpgme'
dependency 'sqlite'
dependency 'gnupg'
dependency 'check'

license "LGPL-2.1"
license_file "COPYING"
skip_transitive_dependency_licensing true

version("0.54.2") { source sha256: "090a417e1d620f3fc196bc5de36c03d7f0d6ebe2bb87346eba89560101280c01" }

source url: "https://github.com/rpm-software-management/libdnf/archive/#{version}.tar.gz"

relative_path "libdnf-#{version}"

build do
  patch source: "0001-Fix-cmake-resolution-for-FindLibSolv.cmake.patch"
  patch source: "0002-Only-require-smartcols-when-generating-Python-bi.patch"
  patch source: "0003-Allow-not-building-tests.patch"
  patch source: "0004-Do-not-set-unknown-pool-flat-POOL_FLAG_WHATPROVI.patch"
  # patch source: "0005-Wrap-older-glibc-functions.patch"
  patch source: "0006-Compile-static.patch"
  patch source: "0007-Fix-sys-auxv.h-import.patch"
  patch source: "0008-Include-atomic.patch"
  # patch source: "0009-Set-CMAKE_POSITION_INDEPENDENT_CODE-to-ON.patch"

  env = with_standard_compiler_flags(with_embedded_path)

  # Use glibc 2.16
  env["LD_LIBRARY_PATH"]= "/opt/glibc-2.16/lib" +
                          ":/lib/x86_64-linux-gnu" +
                          ":/usr/lib/x86_64-linux-gnu" +
                          ":/usr/local/lib" +
                          ":/lib" +
                          ":/usr/lib" +
                          ":/lib32" + 
                          ":/usr/lib32" +
                          ":" + env["LD_LIBRARY_PATH"]
  command "ln -sfn /opt/glibc-2.16/lib/ld-2.16.so /lib64/ld-linux-x86-64.so.2"

  cmake_options = [
    "-DCMAKE_C_FLAGS='-I#{install_dir}/embedded/libinclude -I/opt/glibc-2.16/include'",
    "-DCMAKE_CXX_FLAGS='-I/opt/glibc-2.16/include -std=c++11'",
    "-DCMAKE_POSITION_INDEPENDENT_CODE=ON",
    "-DWITH_BINDINGS=OFF", 
    "-DWITH_GTKDOC=OFF",
    "-DWITH_HTML=OFF",
    "-DWITH_MAN=OFF",
    "-DWITH_ZCHUNK=OFF",
    "-DWITH_TESTS=OFF"
  ]

  cmake(*cmake_options, env: env)

  # Reset the link we changed earlier
  command "ln -sfn /lib/x86_64-linux-gnu/ld-2.13.so /lib64/ld-linux-x86-64.so.2"
end
