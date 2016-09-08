JENKINS_CONFIG = YAML.load_file(File.join(Rails.root, "config", "jenkins.yml"))[Rails.env.to_s]

$jenkins_client = JenkinsApi::Client.new(server_ip: JENKINS_CONFIG["host"], username: JENKINS_CONFIG["username"], password: JENKINS_CONFIG["password"])
