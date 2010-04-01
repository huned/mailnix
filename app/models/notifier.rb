class Notifier < ActionMailer::Base
  def results command
    subject "[mailnix] #{command.input[0..50]}"
    recipients command.from
    body :command => command
  end
end
