class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://github.com/patriceckhart/zot/archive/refs/tags/v0.3.65.tar.gz"
  sha256 "5b11851d78c26af9fae67d1a1ac77cbb4b2e4ec182e8496fe6f775cf23d0a7ea"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bd0651f9ff9436839f9a28fb81659ff8dbf2ae3ef12bf7e55a3a4ce504764321"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bd0651f9ff9436839f9a28fb81659ff8dbf2ae3ef12bf7e55a3a4ce504764321"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bd0651f9ff9436839f9a28fb81659ff8dbf2ae3ef12bf7e55a3a4ce504764321"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6d73063e3a139576dc6f3b0f62e69342d3d3e6149ae543f9d4702d1dc9b1afbc"
    sha256 cellar: :any,                 x86_64_linux:  "95ea629e181dc0b9bf5654437f81df2eeeaba69f0f54116819d4d7b0ef17be0b"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd/zot"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zot --version")
    assert_match "zot: no credential for anthropic", shell_output("#{bin}/zot rpc 2>&1", 1)
  end
end
