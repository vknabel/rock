import Commandant
import PromptLine
import Result
import RockLib

struct ProjectOptions: OptionsProtocol {
  let project: RockProject

  static func evaluate(_ m: CommandMode) -> Result<ProjectOptions, CommandantError<RockError>> {
    return (m <| RockProject.fromOptions)
      .map(ProjectOptions.init)
  }
}

struct ScriptCommand: CommandProtocol {
  let verb: String
  let script: String
  let function: String
  let defaultScript: [String]

  init(verb: String, script: String? = nil, defaultScript: [String] = [], function: String) {
    self.verb = verb
    self.script = script ?? verb
    self.function = function
    self.defaultScript = defaultScript
  }

  func run(_ options: ProjectOptions) -> Result<(), RockError> {
    let prompt = options.project.prompt.lensWorkingDirectory(to: ".")
    if let runner = options.project.rockfile.scriptRunners[self.script] {
      return runner(prompt)
        .map({ _ in () })
    } else if let runner = runnerFromStrings(defaultScript) {
      return (runner %? { RockError.rockfileCustomScriptFailed(self.script, $0) })(prompt)
        .map { _ in () }
    } else {
      return .failure(RockError.rockfileCustomScriptNotFound(self.script))
    }
  }
}
