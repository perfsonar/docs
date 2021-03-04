# Sanity check
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# Make sure apt cache is up to date before we start anything,
# sometimes we'd get errors about it not knowing about common packages
echo "\nBEGIN: updating cache\n\n"
apt-get update
echo "END: updating cache\n"

# Set up SSHD
echo  "\n\nBEGIN: Installing and configuring SSHD\n"
apt-get -y install openssh-server
sed -i 's/PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
service ssh restart
echo  "\n\nEND: Installing and configuring SSHD\n"

# Add perfsonar debian repository
echo  "\n\nBEGIN: Deploying ps repo and also getting gpg key\n"
wget -O /etc/apt/sources.list.d/perfsonar-wheezy-3.5.list http://downloads.perfsonar.net/debian/perfsonar-wheezy-3.5.list
wget -qO - http://downloads.perfsonar.net/debian/perfsonar-wheezy-3.5.gpg.key | apt-key add -
echo  "END> Deploying ps repo and also getting gpg key"

# Rebuild cache with new perfsonar repo
echo "\n\nBEGIN: updating cache\n"
apt-get update
echo "END: updating cache"

# Install testpoint package
echo  "\n\nBEGIN: Getting  ps-testpoint\n"
apt-get -y install perfsonar-testpoint
echo  "END: Getting  ps-endpoint"

# Install firewall rules, ntp, etc stuff.
echo  "\n\nBEGIN: Installing and configuring optional packages recommended by PerfSONAR: perfsonar-toolkit-security perfsonar-toolkit-sysctl perfsonar-toolkit-ntp\n"
apt-get -y install perfsonar-toolkit-security perfsonar-toolkit-sysctl perfsonar-toolkit-ntp
echo  "\t\tConfigure NTPD\n"
/usr/lib/perfsonar/scripts/configure_ntpd new
service ntp restart
echo  "\t\tVerifying NTPD\n"
ntpq -p
echo  "\n\nEND: Installing and configuring optional packages recommended by PerfSONAR\n"

# Set up auto updates
echo "\n\nBEGIN: configuring auto updates\n"
apt-get -y install cron-apt
echo 'upgrade -y -o APT::Get::Show-Upgraded=true -o Dir::Etc::SourceList=/etc/apt/sources.list.d/perfsonar-wheezy-release.list -o Dir::Etc::SourceParts="/dev/null' >> /etc/cron-apt/action.d/5-install
echo "\n\nEND: configuring auto updates"

# Start relevant services. Some of these auto start from their own packages, some
# don't so test before starting. Also makes it easier if this is re-run.
echo "\n\nBEGIN: start perfsonar services as necessary\n"
ps cax | grep -i "bwctld" >/dev/null || /etc/init.d/bwctl-server start
ps cax | grep -i "owamp" >/dev/null || /etc/init.d/owampd start
ps cax | grep -i "lsregistration" >/dev/null || /etc/init.d/perfsonar-lsregistrationdaemon start
ps cax | grep -i "perfSONAR" | grep -i " Re" >/dev/null || /etc/init.d/perfsonar-regulartesting start
ps cax | grep -i "oppd" >/dev/null || /etc/init.d/perfsonar-oppd-server start
echo "\n\nEND: start perfsonar services"
