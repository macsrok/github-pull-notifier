echo "45 9 * * 1-5 ruby /app/github-pull-notifier.rb" > /var/spool/cron/crontabs/root
crond -f