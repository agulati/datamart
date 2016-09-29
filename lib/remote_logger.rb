class RemoteLogger < ActiveSupport::Logger

  ONE_DAY   = 86400
  ONE_WEEK  = 7 * ONE_DAY
  TWO_WEEKS = 2 * ONE_WEEK

  def add(severity, message=nil, progname=nil)
    severity ||= UNKNOWN
    if @logdev.nil? or severity < @level
      return true
    end
    progname ||= @progname
    if message.nil?
      if block_given?
        message = yield
      else
        message = progname
        progname = @progname
      end
    end
    message_string = format_message(format_severity(severity), Time.now, progname, message)
    remote_log(message_string)
    @logdev.write(message_string)
    true
  end

  def remote_log message
    log_key = "tc-trends:logger:#{Date.today.to_s}"
    $redis.rpush(log_key, "#{Socket.ip_address_list.detect(&:ipv4_private?).try(:ip_address)}, #{message}")
    $redis.expire(log_key, TWO_WEEKS)
  end
end
