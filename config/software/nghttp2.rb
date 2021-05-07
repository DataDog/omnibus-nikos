name "nghttp2"
default_version "1.43.0"

license "MIT"
license_file "COPYING"
skip_transitive_dependency_licensing true

version("1.43.0") { source sha256: "f7d54fa6f8aed29f695ca44612136fa2359013547394d5dffeffca9e01a26b0f" }

source url: "https://github.com/nghttp2/nghttp2/releases/download/v#{version}/nghttp2-#{version}.tar.xz"

relative_path "nghttp2-#{version}"

build do
  env = with_standard_compiler_flags(with_embedded_path)
  env["CFLAGS"] << " -fPIC"

  configure_options = [
      "--prefix=#{install_dir}/embedded",
      "--enable-static",
      "--disable-shared",
  ]

  configure(*configure_options, env: env)

  make "-j #{workers}", env: env
  make "install", env: env
end
