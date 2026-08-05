class Flockfly < Formula
  desc "Flockfly context router CLI"
  homepage "https://github.com/flockfly/cli"
  version "0.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/flockfly/cli/releases/download/v0.3.0/flockfly-aarch64-apple-darwin.tar.xz"
      sha256 "e826dcf3fdc6dd3357c66321d0269e71dcb360ed7bc6644e23f2d930cea84a92"
    end
    if Hardware::CPU.intel?
      url "https://github.com/flockfly/cli/releases/download/v0.3.0/flockfly-x86_64-apple-darwin.tar.xz"
      sha256 "8da7ab5fb2e43fc7cd577c6bf1c6a2d53de4fb3bb09ffdea3447f5890e153b63"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/flockfly/cli/releases/download/v0.3.0/flockfly-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "ac32b121455c61e965442223aa5d6140a61670c4a2f5f50b4355296e803f618e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/flockfly/cli/releases/download/v0.3.0/flockfly-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "36bc27a77bd0e1e9ccf2bba0c579a638defdae98134308eefafd992c14558432"
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
