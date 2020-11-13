require 'json'
require 'open3'

class Command
  def to_s
    "cat /fast/.quota-workspace/ood-quota.$USER.json"
  end

  # Execute the command, and parse the output, returning and array of
  # AppProcesses and nil for the error string.
  #
  # returns [Array<Array<AppProcess>, String] i.e.[processes, error]
  def exec
    quotas, error = [], nil

    stdout_str, stderr_str, status = Open3.capture3(to_s)
    if status.success?
      quotas = JSON.parse(stdout_str)
    else
      error = "Command '#{to_s}' exited with error: #{stderr_str}"
    end

    [quotas, error]
  end
end
