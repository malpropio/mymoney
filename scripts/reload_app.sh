echo "reloading app as $(whoami)"
echo "current directory: $(pwd)"
rvmsudo passenger-config restart-app /var/apps/mymoney
