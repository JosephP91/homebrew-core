class ScikitImage < Formula
  include Language::Python::Virtualenv

  desc "Image processing in Python"
  homepage "https://scikit-image.org"
  url "https://files.pythonhosted.org/packages/c7/a8/3c0f256012b93dd2cb6fda9245e9f4bff7dc0486880b248005f15ea2255e/scikit_image-0.25.2.tar.gz"
  sha256 "e5a37e6cd4d0c018a7a55b9d601357e3382826d3888c10d0213fc63bff977dde"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/scikit-image/scikit-image.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a8cac211787f4ee9e93494a7a4dc40ab36f57744988df294b62372a1bdcb629a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7f92c634789c248e5faa16af8c885c76a797561f9caa90ad3ba6771ee8adc65a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dfcc775c8fdda7398e80b2684303c3c68310221e1fb0e83bcd69df31f4d25971"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5aabdc0e3471dda66884980b61a1c2f6f762a26016e724bcbde3f7659c2d1412"
    sha256 cellar: :any_skip_relocation, sonoma:        "dad009c5f2e033d67da433674f7e4900f84a47ae676050d58adf14808fc2c565"
    sha256 cellar: :any_skip_relocation, ventura:       "06de5f36d41949dd79b01e05bd6e10f27f8a1d808b7cb096b607484eb6af6632"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f3e3dc643fb1f17f0632ee7db9208753ced229c1fb14bf1412508f06813fde4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0426a7009a7096077fc58841681b3606ce906feb7abb54d15dcea8fa6cdaeb1c"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "numpy"
  depends_on "pillow"
  depends_on "python@3.14"
  depends_on "scipy"

  on_linux do
    depends_on "patchelf" => :build
  end

  pypi_packages exclude_packages: %w[numpy pillow scipy]

  resource "imageio" do
    url "https://files.pythonhosted.org/packages/0c/47/57e897fb7094afb2d26e8b2e4af9a45c7cf1a405acdeeca001fdf2c98501/imageio-2.37.0.tar.gz"
    sha256 "71b57b3669666272c818497aebba2b4c5f20d5b37c81720e5e1a56d59c492996"
  end

  resource "lazy-loader" do
    url "https://files.pythonhosted.org/packages/6f/6b/c875b30a1ba490860c93da4cabf479e03f584eba06fe5963f6f6644653d8/lazy_loader-0.4.tar.gz"
    sha256 "47c75182589b91a4e1a85a136c074285a5ad4d9f39c63e0d7fb76391c4574cd1"
  end

  resource "networkx" do
    url "https://files.pythonhosted.org/packages/6c/4f/ccdb8ad3a38e583f214547fd2f7ff1fc160c43a75af88e6aec213404b96a/networkx-3.5.tar.gz"
    sha256 "d4c6f9cf81f52d69230866796b82afbccdec3db7ae4fbd1b65ea750feed50037"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "tifffile" do
    url "https://files.pythonhosted.org/packages/2d/b5/0d8f3d395f07d25ec4cafcdfc8cab234b2cc6bf2465e9d7660633983fe8f/tifffile-2025.10.16.tar.gz"
    sha256 "425179ec7837ac0e07bc95d2ea5bea9b179ce854967c12ba07fc3f093e58efc1"
  end

  def install
    virtualenv_install_with_resources
  end

  def post_install
    HOMEBREW_PREFIX.glob("lib/python*.*/site-packages/skimage/**/*.pyc").map(&:unlink)
  end

  test do
    (testpath/"test.py").write <<~PYTHON
      import skimage as ski
      import numpy

      cat = ski.data.chelsea()
      assert isinstance(cat, numpy.ndarray)
      assert cat.shape == (300, 451, 3)
    PYTHON
    shell_output("#{libexec}/bin/python test.py")
  end
end
