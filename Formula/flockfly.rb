class Flockfly < Formula
  desc "Flockfly context router CLI"
  homepage "https://github.com/flockfly/cli"
  version "0.5.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/flockfly/cli/releases/download/v0.5.0/flockfly-aarch64-apple-darwin.tar.xz"
      sha256 "a75bf16472decfc423443f826509f53f6707b94639282e1d6eabe3e1a95761ee"
    end
    if Hardware::CPU.intel?
      url "https://github.com/flockfly/cli/releases/download/v0.5.0/flockfly-x86_64-apple-darwin.tar.xz"
      sha256 "693135363a38a4bce9abc70f1c1bf05c129b72ac68f3cb2c2415d888d3707979"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/flockfly/cli/releases/download/v0.5.0/flockfly-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "17df4de69cc47aff2731aa81bb2e38f167c3ae4c511b25060173044b38c78e14"
    end
    if Hardware::CPU.intel?
      url "https://github.com/flockfly/cli/releases/download/v0.5.0/flockfly-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "35748da8ad96edde6d71b18f2a69ec9db8eec21ec1857e9f5103f37f1da82554"
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
