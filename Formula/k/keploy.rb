class Keploy < Formula
  desc "Testing Toolkit creates test-cases and data mocks from API calls, DB queries"
  homepage "https://keploy.io"
  url "https://github.com/keploy/keploy/archive/refs/tags/v2.6.12.tar.gz"
  sha256 "ae69ff6b274360844a1d31efe5d50a44aae66b1ac57ccf467472a703a4fa5846"
  license "Apache-2.0"
  head "https://github.com/keploy/keploy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c7a6124c7b54f26a3712085ed3ec560bdc9d99dcb157c54586eddaba063a0703"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c7a6124c7b54f26a3712085ed3ec560bdc9d99dcb157c54586eddaba063a0703"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c7a6124c7b54f26a3712085ed3ec560bdc9d99dcb157c54586eddaba063a0703"
    sha256 cellar: :any_skip_relocation, sonoma:        "e98882d262e1f5576d8d211c2d11704ef41bcead5a9c2150f7f331b35555c0c6"
    sha256 cellar: :any_skip_relocation, ventura:       "e98882d262e1f5576d8d211c2d11704ef41bcead5a9c2150f7f331b35555c0c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea68f4fd6cf3f62f2b528ba0e2f34cac22fa2576e679507a6429540ece732d02"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    system bin/"keploy", "config", "--generate", "--path", testpath
    assert_match "# Generated by Keploy", (testpath/"keploy.yml").read

    output = shell_output("#{bin}/keploy templatize --path #{testpath}")
    assert_match "No test sets found to templatize", output

    assert_match version.to_s, shell_output("#{bin}/keploy --version")
  end
end
