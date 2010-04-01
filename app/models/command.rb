class Command < ActiveRecord::Base
  validates_presence_of :input
  validates_presence_of :from

  def run!
    # TODO chroot
    update_attribute :output, `#{input}`
    Notifier.send_later :deliver_results, self
  end
  handle_asynchronously :run!
  after_create :run!
end
