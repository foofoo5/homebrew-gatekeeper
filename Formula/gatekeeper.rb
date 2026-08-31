class Gatekeeper < Formula
  desc "Simple Gatekeeper management helper for macOS"
  homepage "https://github.com/foofoo5/homebrew-gatekeeper"
  url "https://github.com/foofoo5/homebrew-gatekeeper/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "s/sha256 31e3bf5b877bbf008ef2ec11e5137eaa2c29fdb4c468eb207294f33248ed4b28"
  version "1.0.0"
  license "MIT"

  def install
    bin.install "gatekeeper.sh" => "gatekeeper"
    bin.install "gatekeeper-check.sh" => "gatekeeper-check"
    chmod 0755, bin/"gatekeeper"
    chmod 0755, bin/"gatekeeper-check"
    pkgshare.install "com.foofoo5.gatekeeper.plist"
  end

  test do
    system "#{bin}/gatekeeper", "status"
  end
end
