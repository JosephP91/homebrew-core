class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://github.com/rorkai/App-Store-Connect-CLI/archive/refs/tags/5.0.0.tar.gz"
  sha256 "eb0ef1c66c0ab372ef1a455debcbf3573c505f5dabca88035754bb1260076ef2"
  license "MIT"
  head "https://github.com/rorkai/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4adbe7b14872f7875b02e8203182020da38ac3d04e01f55658469b3c391223c3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3e010c641572f872a07d94cfe006788b4accc76dbb6eb23c5526c8f1ab8e9ca2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a34984c7d4dbf7d3b616fbcbc30a74cc4f97a40b472fa724ae902acfecba62f1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4fc145f42ab9667c783d61520729da24bfa11aed14aebf737701571ee85f774e"
    sha256 cellar: :any,                 x86_64_linux:  "0d8fe3e8c78f2526a2ecd884b3aad67b864535f35c4ac67bb70805e193211f43"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"asc", "completion", "--shell")
  end

  test do
    system bin/"asc", "init", "--path", testpath/"ASC.md", "--link=false"
    assert_path_exists testpath/"ASC.md"
    assert_match "asc cli reference", (testpath/"ASC.md").read
    assert_match version.to_s, shell_output("#{bin}/asc version")
  end
end
