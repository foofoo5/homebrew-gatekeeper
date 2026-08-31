class Gatekeeper < Formula
  desc "Simple Gatekeeper management helper for macOS"
  homepage "https://github.com/foofoo5/homebrew-gatekeeper"
  url "https://github.com/foofoo5/homebrew-gatekeeper/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "6cc47a7caff8bdecbd28e2ae43b79eed6435d02400c216285af895d5d3d5a512"
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
