class Flockfly < Formula
  desc "Flockfly context router CLI"
  homepage "https://github.com/flockfly/cli"
  version "0.4.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/flockfly/cli/releases/download/v0.4.0/flockfly-aarch64-apple-darwin.tar.xz"
      sha256 "3cd9f186d72824b0731b0062db223f1fd68ad38d8938be7387d71fe1669aebcd"
    end
    if Hardware::CPU.intel?
      url "https://github.com/flockfly/cli/releases/download/v0.4.0/flockfly-x86_64-apple-darwin.tar.xz"
      sha256 "581500e3abd6b7fd4f1ac40d3ddfe4a0cee1da8e972a035eee429d772019ff57"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/flockfly/cli/releases/download/v0.4.0/flockfly-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "60a67344ffb31f99ca7d0f60e31559c482de615ec27539a6d86341bd43710a25"
    end
    if Hardware::CPU.intel?
      url "https://github.com/flockfly/cli/releases/download/v0.4.0/flockfly-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6cadaa64fad1e9880e301e346bf3e01c85849df9d8656fcb208c40e44063a7e2"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":               {},
    "aarch64-unknown-linux-gnu":          {},
    "aarch64-unknown-linux-musl-dynamic": {},
    "aarch64-unknown-linux-musl-static":  {},
    "x86_64-apple-darwin":                {},
    "x86_64-unknown-linux-gnu":           {},
    "x86_64-unknown-linux-musl-dynamic":  {},
    "x86_64-unknown-linux-musl-static":   {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "flockfly" if OS.mac? && Hardware::CPU.arm?
    bin.install "flockfly" if OS.mac? && Hardware::CPU.intel?
    bin.install "flockfly" if OS.linux? && Hardware::CPU.arm?
    bin.install "flockfly" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
