#!/bin/sh
set -ex

puppet_version=${1:-8}

get_codename() {
  if [ -f /etc/os-release ]; then
    local codename=""
    codename=$(cat /etc/os-release | grep VERSION_CODENAME | cut -d= -f2)
    echo $codename
  else
    echo "OS not supported"
    exit 1
  fi
}

get_deb_file() {
  local codename="$1"
  echo "puppet${puppet_version}-release-${codename}.deb"
}

install_puppet_agent() {
  local deb_file="$1"
  local tmpfile=$(mktemp)
  which curl >/dev/null || apt-get install --no-install-recommends -y curl
  curl -L https://apt.puppetlabs.com/$deb_file -o $tmpfile
  dpkg -i $tmpfile
  apt-get update
  apt-get install --no-install-recommends -y puppet-agent
  rm $tmpfile
}

codename=$(get_codename)
dep_file=$(get_deb_file $codename 8)
install_puppet_agent $dep_file
echo "Puppet agent was installed succesfuly"


