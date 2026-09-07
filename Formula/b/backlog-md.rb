class BacklogMd < Formula
  desc "Markdown‑native Task Manager & Kanban visualizer for any Git repository"
  homepage "https://github.com/MrLesk/Backlog.md"
  url "https://github.com/MrLesk/Backlog.md/archive/refs/tags/v1.51.0.tar.gz"
  sha256 "aed59fa7f5f8309ab244a30bad1d954330e6ff049f2acdfa1498dc52a18fd914"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "c4269429bf3cef81808b244bd34ecfbd39d2e6a91828ee9d41d55660248ec2d9"
    sha256                               arm64_sequoia: "c4269429bf3cef81808b244bd34ecfbd39d2e6a91828ee9d41d55660248ec2d9"
    sha256                               arm64_sonoma:  "c4269429bf3cef81808b244bd34ecfbd39d2e6a91828ee9d41d55660248ec2d9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "941efc9cf1652377a40e0538afa956858ebe708f7841199d414e8377e9279ac2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f6223840ec01ab7d2622c8978de7e1e817fcc2cdefc740dfd510b5a8d8a762f4"
  end

  depends_on "bun" => :build

  on_linux do
    # `bun build --compile` embeds the runtime, so the output inherits bun's ICU linkage.
    depends_on "icu4c@78"
  end

  def install
    if OS.linux?
      bun_icu = Formula["bun"].deps.find { |dep| dep.name.match?(/^icu4c/) }.to_formula
      icu = deps.find { |dep| dep.name.match?(/^icu4c/) }.to_formula

      odie "Update icu4c dependency!" if bun_icu.name != icu.name
    end

    system "bun", "install", "--frozen-lockfile", "--ignore-scripts"

    # Upstream injects the version at release time; the tagged `package.json` lags.
    ENV["BACKLOG_BUILD_VERSION"] = version.to_s

    # Not `bun run build`: that resolves `bun` from `node_modules/.bin`, and
    # `bun build --compile` embeds whichever runtime ran the build.
    system "bun", "scripts/build.ts"

    bin.install "dist/backlog"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/backlog --version")

    system "git", "init"
    system bin/"backlog", "init", "--defaults", "foobar"
    assert_path_exists testpath/"backlog"
  end
end
