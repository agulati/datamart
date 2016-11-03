class NotificationService

  def self.notify message
    Faraday.post("https://hooks.slack.com/services/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", { text: message }.to_json)
  end
end
