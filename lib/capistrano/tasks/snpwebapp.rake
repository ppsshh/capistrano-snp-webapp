namespace :snpwebapp do
  task :load_defaults do
    set :app_id, fetch(:app_id, "#{fetch(:application)}_#{fetch(:stage)}").gsub(/[^a-zA-Z]/, '_')
    set_if_empty :nginx_config_name, "#{fetch(:app_id)}.conf"
    set_if_empty :puma_systemd_unit_name, "puma-#{fetch(:app_id)}"
    set_if_empty :puma_config_path, File.join(shared_path, 'config', "puma-#{fetch(:stage)}.rb")
    set_if_empty :delayed_job_systemd_unit_name, "delayed-job-#{fetch(:app_id)}"
    set_if_empty :logrotate_days, 10
  end

  task :init => :load_defaults do
    on roles(:app) do
      sudo :install, "-o #{local_user}", "-g #{local_user}", '-d', deploy_to
      execute :mkdir, '-p', File.join(shared_path, '{config,log,public,tmp/pids,tmp/sockets}')
    end
  end

  def upload_template(template_name, destination_path, options = {})
    template_path = File.expand_path("../../templates/#{template_name}.erb", __FILE__)
    erb = File.read(template_path)
    if options[:root]
      tmp_path = File.join(shared_path, 'tmp', template_name)
      upload!(StringIO.new(ERB.new(erb).result), tmp_path)
      sudo :install, '-o root', '-g root', '-m 644', tmp_path, destination_path
    else
      upload!(StringIO.new(ERB.new(erb).result), destination_path)
    end
  end

  desc "Configuration files setup"
  task :setup => :init do
    on roles(:app) do
      upload_template('puma.service',
            File.join("/etc/systemd/system", "#{fetch(:puma_systemd_unit_name)}.service"),
            root: true)

      upload_template('delayed-job.service',
            File.join("/etc/systemd/system", "#{fetch(:delayed_job_systemd_unit_name)}.service"),
            root: true)

      upload_template('logrotate',
            File.join("/etc/logrotate.d", "#{fetch(:app_id)}"), root: true)

      upload_template('nginx',
            File.join("/etc/nginx/conf.d", "#{fetch(:app_id)}.conf"), root: true)

      upload_template('puma.config', fetch(:puma_config_path))
    end
  end
end
