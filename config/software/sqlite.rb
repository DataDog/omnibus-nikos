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

name "sqlite"
default_version "3.33.0"

dependency 'libedit'
dependency 'zlib'

license "Public Domain"
skip_transitive_dependency_licensing true

version("3.33.0") do
  source url: "https://www.sqlite.org/2020/sqlite-autoconf-3330000.tar.gz",
         sha256: "106a2c48c7f75a298a7557bcc0d5f4f454e5b43811cc738b7ca294d6956bbb15"
end

relative_path "sqlite-autoconf-3330000"

build do
  env = with_standard_compiler_flags(with_embedded_path)

  env["CFLAGS"] << " -fPIC"

  configure "--enable-static --disable-shared --enable-pic", env: env

  make "-j #{workers}", env: env
  make "install", env: env
end
