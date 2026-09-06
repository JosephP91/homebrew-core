class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-16.24.0.tgz"
  sha256 "6a7afb80d3744a175ea2f8ec8cce8fc0027e444ba8752321cb1864d0b267d8ca"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "49c929c4d849d78322613df30ec77aa71b57d469398578a73bc1d9aba03bd931"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "49c929c4d849d78322613df30ec77aa71b57d469398578a73bc1d9aba03bd931"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "49c929c4d849d78322613df30ec77aa71b57d469398578a73bc1d9aba03bd931"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8645bba39f101d18b6424e0b77024b5b7f6e5fd29f6949d2b7887ad7472ff1ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8645bba39f101d18b6424e0b77024b5b7f6e5fd29f6949d2b7887ad7472ff1ee"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rulesync --version")

    output = shell_output("#{bin}/rulesync init")
    assert_match "rulesync initialized successfully", output
    assert_match "Project overview and general development guidelines", (testpath/".rulesync/rules/overview.md").read
  end
end
