class Cppcheck < Formula
  desc "Static analysis of C and C++ code"
  homepage "https://sourceforge.net/projects/cppcheck/"
  url "https://github.com/danmar/cppcheck/archive/refs/tags/2.17.1.tar.gz"
  sha256 "bfd681868248ec03855ca7c2aea7bcb1f39b8b18860d76aec805a92a967b966c"
  license "GPL-3.0-or-later"
  revision 2
  head "https://github.com/danmar/cppcheck.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sequoia: "3102544868411c345f7bb673595f0226163fe9e6d220ff4715c7af038751a9b7"
    sha256 arm64_sonoma:  "77ac696a0ef87246ca35816c0dfb0c094bdee504bb987d1ba1658414743a6fa6"
    sha256 arm64_ventura: "023da7be5d3eb3d13f4609eeb23601bd95b7a261dcb2cd545c7aa7a0d25494e3"
    sha256 sonoma:        "8d5db1a37f58fa1313ff48bd119d3bd7fbf9b1604f6a2d51c0e167581b548f81"
    sha256 ventura:       "28b99b71be9372234be2e688217a65675bb7270f9c851c48e6dd825ec4d9b29a"
    sha256 arm64_linux:   "40e4409e2397ae1d69d2c4643cb57887ee81bb96cea754f04439dcc8d8975390"
    sha256 x86_64_linux:  "3ce75b931157c6e05a6d3e016fefd6d5c3357e2c3975440dac2b916b118c8c90"
  end

  depends_on "cmake" => :build
  depends_on "python@3.13" => [:build, :test]
  depends_on "pcre"
  depends_on "tinyxml2"

  uses_from_macos "libxml2"

  def python3
    which("python3.13")
  end

  def install
    args = %W[
      -DHAVE_RULES=ON
      -DUSE_BUNDLED_TINYXML2=OFF
      -DENABLE_OSS_FUZZ=OFF
      -DPYTHON_EXECUTABLE=#{python3}
      -DFILESDIR=#{pkgshare}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # Execution test with an input .cpp file
    test_cpp_file = testpath/"test.cpp"
    test_cpp_file.write <<~CPP
      #include <iostream>
      using namespace std;

      int main()
      {
        cout << "Hello World!" << endl;
        return 0;
      }

      class Example
      {
        public:
          int GetNumber() const;
          explicit Example(int initialNumber);
        private:
          int number;
      };

      Example::Example(int initialNumber)
      {
        number = initialNumber;
      }
    CPP
    system bin/"cppcheck", test_cpp_file

    # Test the "out of bounds" check
    test_cpp_file_check = testpath/"testcheck.cpp"
    test_cpp_file_check.write <<~CPP
      int main()
      {
        char a[10];
        a[10] = 0;
        return 0;
      }
    CPP
    output = shell_output("#{bin}/cppcheck #{test_cpp_file_check} 2>&1")
    assert_match "out of bounds", output

    # Test the addon functionality: sampleaddon.py imports the cppcheckdata python
    # module and uses it to parse a cppcheck dump into an OOP structure. We then
    # check the correct number of detected tokens and function names.
    addons_dir = pkgshare/"addons"
    cppcheck_module = "#{name}data"
    expect_token_count = 51
    expect_function_names = "main,GetNumber,Example"
    assert_parse_message = "Error: sampleaddon.py: failed: can't parse the #{name} dump."

    sample_addon_file = testpath/"sampleaddon.py"
    sample_addon_file.write <<~PYTHON
      #!/usr/bin/env #{python3}
      """A simple test addon for #{name}, prints function names and token count"""
      import sys
      from importlib import machinery, util
      # Manually import the '#{cppcheck_module}' module
      spec = machinery.PathFinder().find_spec("#{cppcheck_module}", ["#{addons_dir}"])
      cpp_check_data = util.module_from_spec(spec)
      spec.loader.exec_module(cpp_check_data)

      for arg in sys.argv[1:]:
          # Parse the dump file generated by #{name}
          configKlass = cpp_check_data.parsedump(arg)
          if len(configKlass.configurations) == 0:
              sys.exit("#{assert_parse_message}") # Parse failure
          fConfig = configKlass.configurations[0]
          # Pick and join the function names in a string, separated by ','
          detected_functions = ','.join(fn.name for fn in fConfig.functions)
          detected_token_count = len(fConfig.tokenlist)
          # Print the function names on the first line and the token count on the second
          print("%s\\n%s" %(detected_functions, detected_token_count))
    PYTHON

    system bin/"cppcheck", "--dump", test_cpp_file
    test_cpp_file_dump = "#{test_cpp_file}.dump"
    assert_path_exists testpath/test_cpp_file_dump
    output = shell_output("#{python3} #{sample_addon_file} #{test_cpp_file_dump}")
    assert_match "#{expect_function_names}\n#{expect_token_count}", output
  end
end
