set :application, "moodapp"
#role :web, "www.moodapp.com"
#role :app, "www.moodapp.com"
#role :db,  "www.moodapp.com", :primary => true

role :web, "moodapp.atlassian.com"
role :app, "moodapp.atlassian.com"
role :db,  "moodapp.atlassian.com", :primary => true


# server details
default_run_options[:pty] = true
ssh_options[:forward_agent] = true
ssh_options[:keys] = %w(~/.ssh/ec2-moodapp.pem)
#set :deploy_to, "/var/www/www.moodapp.com"
set :deploy_to, "/var/www/moodapp.atlassian.com"
set :deploy_via, :remote_cache
set :user, "ec2-user"
set :use_sudo, true

# repo details
set :scm, :git
set :scm_username, "spittet"
set :repository, "git@bitbucket.org:spittet/moodapp.git"
set :branch, "master"
set :git_enable_submodules, 1

# tasks
namespace :deploy do
  task :start, :roles => :app do
    run "chown -r www-data:www-data #{current_path}"
    run "touch #{current_path}/tmp/restart.txt"
  end

  task :stop, :roles => :app do
    # Do nothing.
  end

  desc "Restart Application"
  task :restart, :roles => :app do
    run "sudo touch #{current_path}/tmp/restart.txt"
  end

  desc "Symlink shared resources on each release"
  task :symlink_shared, :roles => :app do
    #run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end
end

after 'deploy:update_code', 'deploy:symlink_shared'

namespace :bundler do
  desc "Symlink bundled gems on each release"
  task :symlink_bundled_gems, :roles => :app do
    run "mkdir -p #{shared_path}/bundled_gems"
    run "ln -nfs #{shared_path}/bundled_gems #{release_path}/vendor/bundle"
  end

  desc "Install for production"
  task :install, :roles => :app do
    run "cd #{release_path} && bundle install --production"
  end

end

after 'deploy:update_code', 'bundler:symlink_bundled_gems'
after 'deploy:update_code', 'bundler:install'