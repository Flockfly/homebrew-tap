class Flockfly < Formula
  desc "Flockfly context router CLI"
  homepage "https://github.com/flockfly/cli"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/flockfly/cli/releases/download/v0.1.0/flockfly-aarch64-apple-darwin.tar.xz"
      sha256 "f1980fc9a47cb78a4a8864d53ca4a1398283554cd9a315caf95241d7e7445225"
    end
    if Hardware::CPU.intel?
      url "https://github.com/flockfly/cli/releases/download/v0.1.0/flockfly-x86_64-apple-darwin.tar.xz"
      sha256 "59933257cd5400e4eaef0b8e2499ba65d5f2c19b5655ef1ce8012003b9a5d890"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/flockfly/cli/releases/download/v0.1.0/flockfly-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "1d23798b2d427a3a26c0f2c37d9ddb6feb164d62a04663eb90f53b4e642f3b6e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/flockfly/cli/releases/download/v0.1.0/flockfly-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "914eab708eac99b170e1ead27f3330e48a535ebbef533d6c07b384b327f4a9d7"
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
