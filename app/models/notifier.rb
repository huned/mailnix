require 'net/imap'

class Notifier < ActionMailer::Base
  def results command
    subject "[mailnix] #{command.input[0..50]}"
    recipients command.from
    body :command => command
  end

  def receive mail
    to = mail['to'].addrs.first.address
    from = mail['from'].addrs.first.address
    body = mail.parts.find {|p| p.content_type == 'text/plain' }.body

    # TODO create a command
  end

  def process_inbox
    # config
    config = YAML::load_file 'config/inbox.yml'
    lock = File.new config['lock_file'], 'w'

    # non-blocking, exclusive lock
    if lock.flock(File::LOCK_EX | File::LOCK_NB)
      imap = Net::IMAP.new config['host'], config['port'], true

      begin
        imap.login config['email'], config['password']
        imap.select 'INBOX'

        # find only messages for this Rails.env

        reply_to = 'reply'
        reply_to += "+#{Rails.env}" unless Rails.env == 'production'
        options = [ 'TO', reply_to ]
        imap.search(options).each do |message_id|
          # fetch
          mail = imap.fetch(message_id, ['RFC822']).first.attr['RFC822']

          begin
            Notifier.receive mail
            imap.copy message_id, 'processed' # add label 'processed'
            imap.store message_id, '+FLAGS', [:Deleted] # remove label 'inbox'
          rescue Exception => e
            imap.copy message_id, 'error' # add label 'error'
          end
        end

        imap.expunge
      ensure
        # always disconnect
        imap.disconnect

        # always unlock
        lock.flock File::LOCK_UN
      end
    end
  end
end
