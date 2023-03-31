USER=ubuntu
HOST=xxx.xxx.xxx.xxx
FOLDER_NAME=folder_name
BRANCH_NAME=master
SCRIPT="
  sudo apt update -y
  sudo apt upgrade -y
  cd /var/www/${FOLDER_NAME};
  rvm use 2.5.7
  git pull origin ${BRANCH_NAME};
  bundle install;
  rake assets:precompile RAILS_ENV=production;
  rake db:migrate RAILS_ENV=production;
  sudo systemctl restart apache2
"

ssh -l ${USER} ${HOST} "${SCRIPT}"
