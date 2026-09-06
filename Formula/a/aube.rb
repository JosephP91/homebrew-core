class Aube < Formula
  desc "Fast Node.js package manager"
  homepage "https://aube.en.dev"
  url "https://github.com/jdx/aube/archive/refs/tags/v2.2.12.tar.gz"
  sha256 "598b6dd1de288f6f9e5ece4a5efdd023a50858aeac307142a877e28830b269ec"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c4cce2a4ddf451869bac21236130df90be2382bf127d6d4388acaad071f8eaa9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7b65d99af114d1ad960600030b3db442bce00c02908a85a37d3d786d8cb3719e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e19cb668e0afb946ea5a874833a5c1b25d25124626041d9b687ed568c4b726a6"
    sha256 cellar: :any,                 arm64_linux:   "738a11d5016f916954f84d42674110643a0b0a9931def6f282e789d58fe936d1"
    sha256 cellar: :any,                 x86_64_linux:  "65acac7f7859dff9c1ebaa50d4996c97dc15dcece2f6925da8b93cd0ff41190e"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "usage" => :build
  depends_on "node" => :test

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/aube")
    generate_completions_from_executable(bin/"aube", "completion")
  end

  test do
    system bin/"aube", "init", "--bare"
    system bin/"aube", "add", "cowsay"
    assert_path_exists testpath/"node_modules/cowsay"
    assert_match "< moo >", shell_output("#{bin}/aubx cowsay moo")
  end
end
