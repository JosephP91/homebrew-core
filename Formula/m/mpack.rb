class Mpack < Formula
  desc "MIME mail packing and unpacking"
  homepage "https://web.archive.org/web/20190220145801/ftp.andrew.cmu.edu/pub/mpack/"
  url "https://ftp.gwdg.de/pub/misc/mpack/mpack-1.6.tar.gz"
  mirror "https://fossies.org/linux/misc/old/mpack-1.6.tar.gz"
  sha256 "274108bb3a39982a4efc14fb3a65298e66c8e71367c3dabf49338162d207a94c"
  license "BSD-3-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aa3b844e21d01085594dc4e3826d34f4aa5e9bfd371e31b0a04d6599095081b0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "47bd4a5b967d0d67f6e71bde23a5578fc61a8afdd90b6bac7ae007b6ec1e7058"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "590ebe27e3a84b46df9a304a6207a0d6754ed71dd04892aa965eed9315240c48"
    sha256 cellar: :any_skip_relocation, ventura:        "7fdef10282b191453bb625c95be3b29906c9b051d68654f8f2fadb1aef9b3887"
    sha256 cellar: :any_skip_relocation, monterey:       "dc71738af5d7167731cd69a6608fefbd6ee509ca87cd57ede2680799344ce0de"
    sha256 cellar: :any_skip_relocation, big_sur:        "b3ac3a2ad7ba9481bdbd6ce2c2a3e1d0e59128f4cf8cd846be7a75fc6f27d6b5"
    sha256 cellar: :any_skip_relocation, catalina:       "561bc78b36f0b0cb8b67ff4c59407439fcb70d7f0b0ed23313cbe7579ad6a00f"
    sha256 cellar: :any_skip_relocation, mojave:         "3da5fac96c17669d27049ec2b5eebc0b711258ece13dad09c609792b45498bbc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b67930d5c73b96f420f655232564bb6b48ca5b6d3689d0804390e9860a65610b"
  end

  deprecate! date: "2024-07-21", because: :repo_removed

  # Fix missing return value; clang refuses to compile otherwise
  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/1ad38a9c/mpack/uudecode.c.patch"
    sha256 "52ad1592ee4b137cde6ddb3c26e3541fa0dcea55c53ae8b37546cd566c897a43"
  end

  # Fix build failure because of missing include statements on Linux.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/6e7bc4dd7b971cabc3cc794236e62e732981102f/mpack/linux.patch"
    sha256 "3123446e13b34a083cab8408e16fce0a4dba78c170887722f4cd4306798c54d0"
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end
end
