set :application, "carl"
set :repository,  "git@github.com:railsrumble/rr10-team-142.git"

set :scm, :git

role :web, "carltherobot.r10.railsrumble.com"
role :app, "carltherobot.r10.railsrumble.com"
role :db,  "carltherobot.r10.railsrumble.com", :primary => true

set :deploy_to, "/webapps/carl"

task :change_group do
  run 'sudo chgrp -Rh www-data /webapps/carl'
end

after 'deploy:update', :change_group

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do                                                                    
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

