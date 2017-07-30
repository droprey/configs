#!/bin/bash
#.setup-bash.sh
#
#Written by Dan O'Prey 	2015-08-14
#Last Modified		2015-08-14
#
#Only supports Ubuntu variants
#


#Set up .bashrc
function setup_bash(){

  touch ~/.bashrc

   #Remove old settings
   sed -i -e "/^GREEN/d"  ~/.bashrc
   sed -i -e "/^BLUE/d"  ~/.bashrc
   sed -i -e "/^WHITE/d"  ~/.bashrc
   sed -i -e "/^YELLOW/d"  ~/.bashrc
   sed -i -e "/^export PS1/d"  ~/.bashrc
   sed -i -e "/^PMT=/d"  ~/.bashrc
   sed -i -e "/^export PATH.*local/d" ~/.bashrc
   sed -i -e "/source .*bash_completion.*d.git/d"  ~/.bashrc
   sed -i -e "/source .*git-completion.bash/d"  ~/.bashrc

  sudo touch /etc/bash_completion.d/git

  if [ `cat ~/.bashrc | grep 'export PATH=/usr/local/bin:${PATH}' | wc -l`  -eq 0 ]
  then
    echo "" >> ~/.bashrc
    echo -e '\nexport PATH=/usr/local/bin:${PATH}\n' >> ~/.bashrc
    echo "" >> ~/.bashrc
    echo "Added 'export PATH=/usr/local/bin:\${PATH}' to ~/.bashrc"
  fi

  if [ `cat ~/.bashrc | grep "export PS1=.*git branch" | wc -l` -eq 0 ]
  then
    echo "" >> ~/.bashrc
    echo 'PMT=""; if [  $UID -eq 0 ];then PMT="#" ;else PMT="$" ; fi' >> ~/.bashrc
    echo 'WHITE="\[\033[0m\]" '>> ~/.bashrc
    echo 'YELLOW="\[\033[0;33m\]"' >> ~/.bashrc
    echo 'GREEN="\[\033[0;32;40m\]"' >> ~/.bashrc
    echo 'BLUE="\[\033[1;34m\]"' >> ~/.bashrc
    echo $'export PS1="[$GREEN\u@\h $BLUE\W$WHITE:$YELLOW\$(git branch 2>/dev/null | grep \'^*\' | colrm 1 2)$WHITE]"'"\$PMT " >> ~/.bashrc
    echo "" >> ~/.bashrc
  fi

  if [ `cat ~/.bashrc | grep 'source /etc/bash_completion.d/git' | wc -l`  -eq 0 ]
  then
    echo -e "\nsource /etc/bash_completion.d/git" >> ~/.bashrc
    echo "" >> ~/.bashrc
  fi

  source ~/.bashrc


echo "####################################"
echo "Set up complete."
}

#######################################
setup_bash

