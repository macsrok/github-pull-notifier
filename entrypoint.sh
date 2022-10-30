echo "45 9 * * 1,3,5 /usr/local/bin/ruby /app/github-pull-notifier.rb" >> /var/spool/cron/crontabs/root
crond -f