class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.22.1589.tar.gz"
  sha256 "b5e6b7f11ff0f11cf09bce3f5dd3abeaf8622b6857a9b91a6c5b1111b686f196"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b3cdb51fb1b57622a0dc855139c339b00d30c6e47940f9739a6600ca26a64a27"
    sha256 cellar: :any,                 arm64_sonoma:  "85f9d1c3ca02069a370930b377227a2ac978530f8be3663c58f1291242d39bd3"
    sha256 cellar: :any,                 arm64_ventura: "e8d3a77b46f37fe6640f1b04b72beef4cea5faee9c100bbdd0dee4f7c149164b"
    sha256 cellar: :any,                 ventura:       "d6717969a04ac2f01cd430df70117ab9c37e791efc69453e48b414728fecc286"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c5fb894ef256a9f1934597e334722f49c8b92ee999cfc26f8e9f1a2cce241629"
  end

  depends_on "dotnet@8"

  def install
    ENV["DOTNET_CLI_TELEMETRY_OPTOUT"] = "1"
    ENV["DOTNET_SYSTEM_GLOBALIZATION_INVARIANT"] = "1"

    dotnet = Formula["dotnet@8"]

    args = %W[
      --configuration Release
      --framework net#{dotnet.version.major_minor}
      --output #{libexec}
      --no-self-contained
      --use-current-runtime
    ]
    if build.stable?
      args += %W[
        /p:AssemblyVersion=#{version}
        /p:FileVersion=#{version}
        /p:InformationalVersion=#{version}
        /p:Version=#{version}
      ]
    end

    system "dotnet", "publish", "src/Jackett.Server", *args

    (bin/"jackett").write_env_script libexec/"jackett", "--NoUpdates",
      DOTNET_ROOT: "${DOTNET_ROOT:-#{dotnet.opt_libexec}}"
  end

  service do
    run opt_bin/"jackett"
    keep_alive true
    working_dir opt_libexec
    log_path var/"log/jackett.log"
    error_log_path var/"log/jackett.log"
  end

  test do
    assert_match(/^Jackett v#{Regexp.escape(version)}$/, shell_output("#{bin}/jackett --version 2>&1; true"))

    port = free_port

    pid = fork do
      exec bin/"jackett", "-d", testpath, "-p", port.to_s
    end

    begin
      sleep 15
      assert_match "<title>Jackett</title>", shell_output("curl -b cookiefile -c cookiefile -L --silent http://localhost:#{port}")
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end
