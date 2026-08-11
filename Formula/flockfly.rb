class Flockfly < Formula
  desc "Flockfly context router CLI"
  homepage "https://github.com/flockfly/cli"
  version "0.6.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/flockfly/cli/releases/download/v0.6.0/flockfly-aarch64-apple-darwin.tar.xz"
      sha256 "1b89b6be6a7f47e4c9a6630142ea0bfedb66a7a3477cb90fa1f9d857ac464e19"
    end
    if Hardware::CPU.intel?
      url "https://github.com/flockfly/cli/releases/download/v0.6.0/flockfly-x86_64-apple-darwin.tar.xz"
      sha256 "dbaccbd16cc87bdbb90704ed423b99da26a06e8e675dc5fa50978a7d76b8f1c0"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/flockfly/cli/releases/download/v0.6.0/flockfly-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "93db163b7d4f04c491d924d02f6998092749d3b1588a23170baa97e092565d1c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/flockfly/cli/releases/download/v0.6.0/flockfly-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "574d542afb8975f641e934a0251c084dda811b67cdf932461ed439a84bc56995"
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "flockfly"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "flockfly"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "flockfly"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "flockfly"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
