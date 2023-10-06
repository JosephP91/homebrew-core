class Tvnamer < Formula
  include Language::Python::Virtualenv

  desc "Automatic TV episode file renamer that uses data from thetvdb.com"
  homepage "https://github.com/dbr/tvnamer"
  url "https://files.pythonhosted.org/packages/7e/07/688dc96a86cf212ffdb291d2f012bc4a41ee78324a2eda4c98f05f5e3062/tvnamer-3.0.4.tar.gz"
  sha256 "dc2ea8188df6ac56439343630466b874c57756dd0b2538dd8e7905048f425f04"
  license "Unlicense"
  revision 4
  head "https://github.com/dbr/tvnamer.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "aa86b886b7f703f6a6a99f95fd912894bf563289e0d4ab6aa9213401e3b6cdfd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c04db388beb645362148242d6f5e5a2820a45c3092c9d10271557c497c986a1a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "198e574e6641aa690d3d66c48da9b0dbfb5561b804771c7784509be716cbca28"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1da9d1ed619237568233503d4f950e5be70569e8ae96cdc485c8c97560784f21"
    sha256 cellar: :any_skip_relocation, sonoma:         "f27d5bb695686dc3f407423756dfc9dd7b6d8c478fcf2390f2f3344651a73b59"
    sha256 cellar: :any_skip_relocation, ventura:        "01505e260d0b498008b9eb5bac58023e60d7779a455f3552927ee4596b9275b0"
    sha256 cellar: :any_skip_relocation, monterey:       "fe17395b14667a8aabca043cec2d6c52c10c328c2ab577d0b4dca87cf896f30b"
    sha256 cellar: :any_skip_relocation, big_sur:        "5a7bd6a392e0c27f898a4f72800dc474439eca354e8d2f1478b3055334a2d289"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4576e4ecaf16db8cff481d6c4331f9e0367fd33a2d1690267468dfbf7b390fec"
  end

  depends_on "python-certifi"
  depends_on "python@3.11"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/cf/ac/e89b2f2f75f51e9859979b56d2ec162f7f893221975d244d8d5277aa9489/charset-normalizer-3.3.0.tar.gz"
    sha256 "63563193aec44bce707e0c5ca64ff69fa72ed7cf34ce6e11d5127555756fd2f6"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "requests-cache" do
    url "https://files.pythonhosted.org/packages/0c/d4/bdc22aad6979ceeea2638297f213108aeb5e25c7b103fa02e4acbe43992e/requests-cache-0.5.2.tar.gz"
    sha256 "813023269686045f8e01e2289cc1e7e9ae5ab22ddd1e2849a9093ab3ab7270eb"
  end

  resource "tvdb-api" do
    url "https://files.pythonhosted.org/packages/a9/66/7f9c6737be8524815a02dd2edd3a24718fa786614573104342eae8d2d08b/tvdb_api-3.1.0.tar.gz"
    sha256 "f63f6db99441bb202368d44aaabc956acc4202b18fc343a66bf724383ee1f563"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/8b/00/db794bb94bf09cadb4ecd031c4295dd4e3536db4da958e20331d95f1edb7/urllib3-2.0.6.tar.gz"
    sha256 "b19e1a85d206b56d7df1d5e683df4a7725252a964e3993648dd0fb5a1c157564"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    raw_file = testpath/"brass.eye.s01e01.avi"
    expected_file = testpath/"Brass Eye - [01x01] - Animals.avi"
    touch raw_file
    system bin/"tvnamer", "-b", raw_file
    assert_predicate expected_file, :exist?
  end
end
