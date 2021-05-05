#
# Copyright 2012-2019 Chef Software, Inc.
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

name "make"
default_version "3.79"

license "GPL-3.0"
license_file "COPYING"

version("3.79") { source sha256: "e4bde0f9d71e2e7c979ee97dc70d9ceb0b2278ddd3ddeb82992f2ea9a0d07ac2" }

source url: "https://ftp.gnu.org/gnu/make/make-#{version}.tar.gz"

relative_path "make-#{version}"

build do
  env = with_standard_compiler_flags(with_embedded_path)

  # Work around an error caused by Glibc 2.27
  # Thanks to: http://www.linuxfromscratch.org/lfs/view/8.2/chapter05/make.html
  if (debian? &&  platform_version.satisfies?(">= 10")) || (ubuntu? && platform_version.satisfies?(">= 18.04")) || raspbian?
    patch source: "deb-make-glob.patch", plevel: 1, env: env
  end

  command "./configure" \
          " --disable-nls" \
          " --prefix=#{install_dir}/embedded", env: env

  make "-j #{workers}", env: env
  make "install", env: env

  # We are very prescriptive. We made make, we will make all the things use it!
  link "#{install_dir}/embedded/bin/make", "#{install_dir}/embedded/bin/gmake"
end