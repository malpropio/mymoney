namespace :db do
  db_config = Rails.application.config.database_configuration[Rails.env]
  db_dir = Rails.root.join('db', 'backups')
  system 'mkdir -p ' + db_dir.to_s

  db_diagram_dir = Rails.root.join('db', 'diagrams')
  system 'mkdir -p ' + db_diagram_dir.to_s

  desc 'take a backup of the db'
  task backup: :environment do
    puts "backing up #{db_config['database']} into #{db_dir}/#{db_config['database']}"
    system "mysqldump -u#{db_config['username']} -p#{db_config['password']} #{db_config['database']} | gzip > #{db_dir}/#{db_config['database']}.sql.gz"
  end

  desc 'restore the last backup'
  task restore: :environment do
    puts "restoring #{db_dir}/#{db_config['database']} into #{db_config['database']}"
    system "gunzip < #{db_dir}/#{db_config['database']}.sql.gz | mysql -u#{db_config['username']} -p#{db_config['password']} #{db_config['database']}"
  end

  desc 'take a diagram of the current db'
  task :diagram do
    t = Time.current.utc.strftime('%Y%m%d_%H%M%S')
    ENV['filename'] = "#{db_diagram_dir}/#{t}_erd"
    ENV['orientation'] = 'vertical'
    ENV['title'] = 'My Money Model Diagram'
    ENV['attributes'] = 'content,foreign_keys,primary_keys'
    ENV['notation'] = 'bachman'
    ENV['polymorphism'] = 'true'

    Rake::Task['erd'].invoke
  end
end
