class Haraka < Formula
  desc "Fast, highly extensible, and event driven SMTP server"
  homepage "https://haraka.github.io/"
  url "https://registry.npmjs.org/Haraka/-/Haraka-3.3.4.tgz"
  sha256 "9be028d17681556491e98d3fd38aee10d255d394f2218f46335eb77484df7882"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d6dfa694af595812e1d2d658df5bb0fed7925c9349f95098a8afec4d37cd220d"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/haraka --version")

    system bin/"haraka", "--install", testpath/"config"
    assert_path_exists testpath/"config/README"

    output = shell_output("#{bin}/haraka --list")
    assert_match "plugins/auth", output
  end
end
