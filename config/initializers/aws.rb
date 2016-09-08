AWS_CONFIG = YAML.load_file(File.join(Rails.root, "config", "aws.yml"))[Rails.env.to_s]

$ec2 = Aws::EC2::Client.new(access_key_id: AWS_CONFIG["access_key"], secret_access_key: AWS_CONFIG["secret_access_key"], region: "us-east-1")
