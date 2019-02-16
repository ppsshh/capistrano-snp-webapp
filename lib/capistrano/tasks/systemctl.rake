namespace :snpwebapp do
  task :puma_reload do
    on roles(:app) do
      if test "systemctl -n 0 status #{fetch(:puma_systemd_unit_name)}"
        sudo "systemctl reload #{fetch(:puma_systemd_unit_name)}"
      else
        sudo "systemctl restart #{fetch(:puma_systemd_unit_name)}"
      end
    end
  end

  task :delayed_job_restart do
    on roles(:web) do
      sudo "systemctl restart #{fetch(:delayed_job_systemd_unit_name)}"
    end
  end

  after 'deploy:publishing', :puma_reload
  after 'deploy:publishing', :delayed_job_restart

  after 'deploy:reverted', :puma_reload
  after 'deploy:reverted', :puma_reload
end
