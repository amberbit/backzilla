module Backzilla::Executor
  def execute(cmd)
    debug cmd
    pid, stdin, stdout, stderr = Open4.popen4(cmd)
    ignored, status = Process::waitpid2 pid
    out = stdout.read
    debug out unless out.blank?
    err = stderr.read
    if status.exitstatus != 0
      fatal err unless err.blank?
      exit 1
    else
      error err unless err.blank?
    end
  end
end

