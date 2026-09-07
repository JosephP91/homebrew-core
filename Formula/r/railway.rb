class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v5.49.3.tar.gz"
  sha256 "c8b2ceb020bbad2b8b595f1d1e27e8296ae1743b754ca8c83c3b612c8cb9d523"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "09fd488841c8f35d6a1f1ba6778912c819290e0b810080cd46a48f56d25dab2e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "14c30cc373f8b82a5036063bc49f297794b2bcafbdced657df1a682e5f03e4c8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5a39e75c95aee0961bcd9d8470f7981e680d7d49ca2e22a2176be3df43f7589d"
    sha256 cellar: :any,                 arm64_linux:   "1a47f873db9bfc98d2b68fd8109b5824a782f9d546b0181853de45a92f4a9fee"
    sha256 cellar: :any,                 x86_64_linux:  "5da35ea392fd2b528853846b915871c057a85fe68ad01f79b8b100d4b78453d8"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"railway", "completion")
  end

  test do
    output = shell_output("#{bin}/railway init 2>&1", 1).chomp
    assert_match "Unauthorized. Please login with `railway login`", output

    assert_equal "railway #{version}", shell_output("#{bin}/railway --version").strip
  end
end
