#!/bin/bash
curl https://thoughtworks.github.io/talisman/install.sh >> ~/install-talisman.sh
chmod +x ~/install-talisman.sh
sudo yum install perl-Digest-SHA -y
cd your-git-project
~/install-talisman.sh
