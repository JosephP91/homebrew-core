class Jcode < Formula
  desc "AI coding agent harness for the terminal"
  homepage "https://jcode.sh"
  url "https://github.com/1jehuang/jcode/archive/refs/tags/v0.83.0.tar.gz"
  sha256 "fbab8b02316c436eae162d8d7dc26c029435b24e6205ceef5e8d310f2d0dc7b8"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7d38cecaea2862df1a21451471d6aba1816d5e4cb979298bdccbf12241cb3960"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "24ce17845d7491b19c1a47ad0394ea7c19ec3f5783cc4f2cf03e853edd62fa27"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "76f552f8a261d7de39d22399a6ed73bc6565a665d9a883ebebca62870d676cb3"
    sha256 cellar: :any,                 arm64_linux:   "79f6051c2e69a0b182131c5b872edbcf157809b6b9b5a8d096643def801add21"
    sha256 cellar: :any,                 x86_64_linux:  "fb6eff08844b14fc6fca915a78cd700f746face075481de1fadb1cd6cb8c9dd5"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  deny_network_access! :build

  def fetch
    system "cargo", "fetch", "--locked"
  end

  def install
    # Disable background auto-update by default
    inreplace "src/cli/args.rs",
              '#[arg(long, global = true, default_value = "true")]',
              '#[arg(long, global = true, default_value = "false")]'

    # Redirect `jcode update` to Homebrew
    inreplace "src/cli/dispatch.rs",
              "hot_exec::run_update()?;",
              'eprintln!("Please update jcode using: brew upgrade jcode");'

    system "cargo", "install", *std_cargo_args
    rm bin/"test_api"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jcode --version")
    assert_match "Please update jcode using: brew upgrade jcode", shell_output("#{bin}/jcode update 2>&1")

    system bin/"jcode-harness", "--cwd", testpath
    assert_match "alpha2", (testpath/"sample.txt").read
  end
end
