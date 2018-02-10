#!/bin/bash
# ----------------------------------------------------------------------------------------------------\\
# Description:
#   A basic installer for IBM Cloud Private-CE 2.1.0.1 on RHEL 7.4 or Ubuntu 16.04
# ----------------------------------------------------------------------------------------------------\\
# Note:
#   This assumes all VMs were provisioned to be accessable with the same SSH key
#   All scripts should be run from the master node
# ----------------------------------------------------------------------------------------------------\\
# System Requirements:
#   Tested against RHEL 7.4 (OpenStack - KVM-RHE7.4-Srv-x64), Ubuntu 16.04 (OpenStack)
#   Master Node - 4 CPUs, 8 GB RAM, 80 GB disk, public IP
#   Worker Node - 2 CPUs, 4 GB RAM, 40 GB disk
#   Requires sudo access
# ----------------------------------------------------------------------------------------------------\\
# Docs:
#   Installation Steps From:
#    - https://www.ibm.com/support/knowledgecenter/SSBS6K_2.1.0/installing/prep_cluster.html
#    - https://www.ibm.com/support/knowledgecenter/SSBS6K_2.1.0/installing/install_containers_CE.html
#
#   Wiki:
#    - https://www.ibm.com/developerworks/community/wikis/home?lang=en#!/wiki/W1559b1be149d_43b0_881e_9783f38faaff
#    - https://www.ibm.com/developerworks/community/wikis/home?lang=en#!/wiki/W1559b1be149d_43b0_881e_9783f38faaff/page/Connect
# ----------------------------------------------------------------------------------------------------\\

##########
# Colors##
##########
Green='\x1B[0;32m'
Red='\x1B[0;31m'
Yellow='\x1B[0;33m'
Cyan='\x1B[0;36m'
no_color='\x1B[0m' # No Color
beer='\xF0\x9f\x8d\xba'
delivery='\xF0\x9F\x9A\x9A'
beers='\xF0\x9F\x8D\xBB'
eyes='\xF0\x9F\x91\x80'
cloud='\xE2\x98\x81'
crossbones='\xE2\x98\xA0'
litter='\xF0\x9F\x9A\xAE'
fail='\xE2\x9B\x94'
harpoons='\xE2\x87\x8C'
tools='\xE2\x9A\x92'
present='\xF0\x9F\x8E\x81'
#############

export SSH_KEY=/home/ubuntu/.ssh/boilerup-ssh.pem
export SSH_USER=ubuntu
export ICPUSER=admin
export ICPPW=admin
export ICPEMAIL=icp@foo.com


export PUBLIC_IP=9.37.239.93
export MASTER_IP=10.10.25.41

# WORKER_IPS[0] should be the same worker at WORKER_HOSTNAMES[0]
export WORKER_IPS=("10.10.25.42" "10.10.25.43")
export WORKER_HOSTNAMES=("om-demo-worker-1" "om-demo-worker-2")

if [[ "${#WORKER_IPS[@]}" != "${#WORKER_HOSTNAMES[@]}" ]]; then
  echo "ERROR: Ensure that the arrays WORKER_IPS and WORKER_HOSTNAMES are of the same length"
  return 1
fi

export NUM_WORKERS=${#WORKER_IPS[@]}

export ARCH="$(uname -m)"
if [ "${ARCH}" != "x86_64" ]; then
  export INCEPTION_TAG="-${ARCH}"
fi

export INCEPTION_VERSION="2.1.0.1"

# Get OS ID
if [ -f /etc/os-release ]; then
  source /etc/os-release
  export OS="${ID}"
fi

#export ARRAY_IDX=${!WORKER_IPS[*]}
#for index in $ARRAY_IDX;
#do
#    echo ${WORKER_IPS[$index]}
#done
