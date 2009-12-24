module Backzilla::Executor
  def execute(cmd)
    debug cmd
    pid, stdin, stdout, stderr = Open4.popen4(cmd)
    ignored, status = Process::waitpid2 pid
    out = stdout.read
    debug out
    if status.exitstatus != 0
      err = stderr.read
      fatal err unless err.blank?
      exit -1
    end
  end
end

