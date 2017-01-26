import Result
import PromptLine
import PathKit

public struct Repository {
  public let path: Path

  public func create() -> PromptRunner<PromptError> {
    return Prompt.mkpath(path)
      %& Prompt.chdir(self.path, run: >-"git init")
  }

  public func clone(url: String, branch: String = "master") -> PromptRunner<PromptError> {
    return Prompt.mkpath(path.parent())
      %& Prompt.chdir(
        self.path.parent(),
        run: >-["git", "clone", "--recursive", "--depth", "1", url, "--branch", branch, self.path.description]
    )
  }

  public func checkout(branch: String) -> PromptRunner<PromptError> {
    return Prompt.mkpath(path.parent())
      %& Prompt.chdir(
        self.path,
        run: >-["git", "checkout", branch]
    )
  }

  public func pull() -> PromptRunner<PromptError> {
    return Prompt.mkpath(path)
      %& Prompt.chdir(
        self.path,
        run: >-"git pull"
    )
  }

  public func fetch(tags: Bool = false) -> PromptRunner<PromptError> {
    return Prompt.mkpath(path)
      %& Prompt.chdir(
        self.path,
        run: >-(tags ? "git fetch --tags" : "git fetch")
    )
  }
}
