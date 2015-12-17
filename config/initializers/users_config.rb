USERS_CONFIG = YAML.load_file("#{Rails.root.to_s}/config/users_config.yml")[Rails.env]
