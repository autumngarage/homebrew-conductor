class Conductor < Formula
  desc "Pick an LLM, give it a job — capability-aware router across claude / codex / gemini / kimi / ollama"
  homepage "https://github.com/autumngarage/conductor"
  url "https://github.com/autumngarage/conductor/archive/refs/tags/v0.10.7.tar.gz"
  sha256 "6b1c3692b148473d519b68e294addf74e8b5fdec3a34b3a6c03f9696e15e4fb5"
  license "MIT"

  depends_on "python@3.12"
  depends_on "uv"

  # Optional CLI providers. Conductor falls back to whichever provider is
  # configured at call time, so none of these are hard requirements.
  # `claude` and `codex` are intentionally NOT declared as Homebrew
  # dependencies: Claude Code ships via the desktop app or npm, and
  # OpenAI's `codex` CLI ships via npm — neither has a Homebrew formula
  # under those names. Users install them separately.
  depends_on "gemini-cli" => :optional
  depends_on "ollama" => :optional

  def install
    venv = libexec/"venv"
    system "uv", "venv", venv, "--python", "python3.12"
    system "uv", "pip", "install", ".", "--python", venv/"bin/python"
    bin.install_symlink venv/"bin/conductor"
  end

  def caveats
    <<~'EOS'
      conductor
        ___ ___  _  _ ___  _   _  ___ _____ ___  ___
       / __/ _ \| \| |   \| | | |/ __|_   _/ _ \| _ \
      | (_| (_) | .` | |) | |_| | (__  | || (_) |   /
       \___\___/|_|\_|___/ \___/ \___| |_| \___/|_|_\

      Get started:
        conductor init           # walk every provider, store credentials, smoke
        conductor doctor         # what's configured, what's missing
        conductor list           # all providers + tier + cost
        conductor smoke <id>     # cheapest round-trip on one provider
        conductor route --help   # dry-run: which provider would auto-routing pick?

      Use it:
        conductor call --auto --tags code-review --task "review this diff"
        conductor exec --auto --tools Read,Grep,Bash --sandbox read-only --task "..."
        conductor call --with claude --task "..."

      Conductor is the LLM-routing layer of the autumngarage suite. It owns
      auth, capability matching, sandbox translation, and cost reporting so
      every consumer (touchstone reviewers, sentinel cycles, your scripts)
      can share one provider abstraction:

        brew install autumngarage/touchstone/touchstone   # pre-push code review
        brew install autumngarage/conductor/conductor     # this package
        brew install autumngarage/sentinel/sentinel       # autonomous agent cycles
        brew install autumngarage/cortex/cortex           # project memory

      See: https://github.com/autumngarage/conductor#readme
    EOS
  end

  test do
    assert_match "conductor, version", shell_output("#{bin}/conductor --version")
  end
end
