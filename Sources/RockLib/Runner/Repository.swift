import Result
import PromptLine
import PathKit

public struct Repository {
  public let path: Path

  public func create() -> PromptRunner<PromptError> {
    return Prompt.mkpath(path)
      %& Prompt.chdir(self.path, run: >-"git init > /dev/null")
  }

  public func clone(url: String, branch: String = "master") -> PromptRunner<PromptError> {
    let cmd: String = [
      "git clone --recursive --depth 1",
      "\"\(url)\"",
      "--branch \"\(branch)\"",
      "\"\(self.path.description)\"",
      "> /dev/null"
    ].reduce("") { "\($0) $($1)" }
    return Prompt.mkpath(path.parent())
      %& Prompt.chdir(
        self.path.parent(),
        run: >-cmd
    )
  }

  public func checkout(branch: String) -> PromptRunner<PromptError> {
    return Prompt.mkpath(path.parent())
      %& Prompt.chdir(
        self.path,
        run: >-"git checkout \"\(branch)\" > /dev/null"
    )
  }

  public func pull() -> PromptRunner<PromptError> {
    return Prompt.mkpath(path)
      %& Prompt.chdir(
        self.path,
        run: >-"git pull > /dev/null"
    )
  }

  public func fetch(tags: Bool = false) -> PromptRunner<PromptError> {
    return Prompt.mkpath(path)
      %& Prompt.chdir(
        self.path,
        run: >-(tags ? "git fetch --tags > /dev/null" : "git fetch > /dev/null")
    )
  }
}
