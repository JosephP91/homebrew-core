class RekorCli < Formula
  desc "CLI for interacting with Rekor"
  homepage "https://docs.sigstore.dev/logging/overview/"
  url "https://github.com/sigstore/rekor/archive/refs/tags/v1.3.8.tar.gz"
  sha256 "1bfdb9167624cf0125a9e7852fc3eb406b435d8e3949d91fcc47bc1dc7501009"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eb21a255eb2060476560d868605019b44d095e54fb9eac7931fd3ad76ea65a0b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eb21a255eb2060476560d868605019b44d095e54fb9eac7931fd3ad76ea65a0b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "eb21a255eb2060476560d868605019b44d095e54fb9eac7931fd3ad76ea65a0b"
    sha256 cellar: :any_skip_relocation, sonoma:        "15c6a44ce473bdc6ef08d1e697ef1dec51d5d64c7665f4ae0bb2b69acc2b60e7"
    sha256 cellar: :any_skip_relocation, ventura:       "15c6a44ce473bdc6ef08d1e697ef1dec51d5d64c7665f4ae0bb2b69acc2b60e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a73f9bdf01fcaaeba6862c98915233599d6e7a4bad83ae6ed7df4494ca05e13e"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X sigs.k8s.io/release-utils/version.gitVersion=#{version}
      -X sigs.k8s.io/release-utils/version.gitCommit=#{tap.user}
      -X sigs.k8s.io/release-utils/version.gitTreeState=#{tap.user}
      -X sigs.k8s.io/release-utils/version.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/rekor-cli"

    generate_completions_from_executable(bin/"rekor-cli", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rekor-cli version")

    url = "https://github.com/sigstore/rekor/releases/download/v#{version}/rekor-cli-darwin-arm64"
    output = shell_output("#{bin}/rekor-cli search --artifact #{url} 2>&1")
    assert_match "Found matching entries (listed by UUID):", output
  end
end
