class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-2.15.0.tgz"
  sha256 "0744a1fb716cbacddce5af066a76536bf6a7784ba404af5a42976eec9834ac4f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7075096a5aa01819998ee1bdb71fb1af2e06fa46ed7093bedd2b4eb8272ca7e2"
    sha256 cellar: :any,                 arm64_sonoma:  "7075096a5aa01819998ee1bdb71fb1af2e06fa46ed7093bedd2b4eb8272ca7e2"
    sha256 cellar: :any,                 arm64_ventura: "7075096a5aa01819998ee1bdb71fb1af2e06fa46ed7093bedd2b4eb8272ca7e2"
    sha256 cellar: :any,                 sonoma:        "112ca487eaa122277831c2f2b4347ef29e36fd2bf08815f61f4a2b117a4b1161"
    sha256 cellar: :any,                 ventura:       "112ca487eaa122277831c2f2b4347ef29e36fd2bf08815f61f4a2b117a4b1161"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "681a607718ac6f90a929d94cbc11ffcd39348376dd881ca71ce75752e8c8c3e8"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"asyncapi", "new", "--file-name=asyncapi.yml", "--example=default-example.yaml", "--no-tty"
    assert_predicate testpath/"asyncapi.yml", :exist?, "AsyncAPI file was not created"
  end
end
