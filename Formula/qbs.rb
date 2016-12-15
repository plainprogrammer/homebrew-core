class Qbs < Formula
  desc "Build tool for developing projects across multiple platforms."
  homepage "https://wiki.qt.io/Qbs"
  url "https://download.qt.io/official_releases/qbs/1.7.0/qbs-src-1.7.0.tar.gz"
  sha256 "a7271e35f35c015f6deda3bf5b614031019018572cebb9904920f251b583c3ef"
  head "https://code.qt.io/qt-labs/qbs.git"

  bottle do
    cellar :any
    sha256 "6a6c4fbfa3fa1ad92972f71feb76d65b85251b2bf02adb9c15c9782ae9f89468" => :sierra
    sha256 "6a6c4fbfa3fa1ad92972f71feb76d65b85251b2bf02adb9c15c9782ae9f89468" => :el_capitan
    sha256 "69ca219d98c2eaa3a2f5fddabc33fa95e7af5e699703a6720270e07fec5de6d4" => :yosemite
  end

  depends_on "qt5"

  def install
    system "qmake", "qbs.pro", "-r", "QBS_INSTALL_PREFIX=/"
    system "make", "install", "INSTALL_ROOT=#{prefix}"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      int main() {
        return 0;
      }
    EOS

    (testpath/"test.qbp").write <<-EOS.undent
      import qbs

      CppApplication {
        name: "test"
        files: "test.c"
        consoleApplication: true
      }
    EOS

    system "#{bin}/qbs", "setup-toolchains", "--detect", "--settings-dir", testpath
    system "#{bin}/qbs", "run", "--settings-dir", testpath, "-f", "test.qbp", "profile:clang"
  end
end
