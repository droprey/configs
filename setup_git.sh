#!/bin/bash
#.setup-git.sh
#
#Written by Dan O'Prey 	2015-08-14
#Last Modified		2015-08-14
#
#Only supports Ubuntu variants
#


#Set up git
function setup_git(){

  git config --global core.autocrlf input
  git config --global core.trustctime false
  git config --global core.filemode false

  git config --global color.ui true
  git config --global color.status auto
  git config --global color.diff auto
  git config --global color.branch auto
  git config --global color.interactive auto

  git config --global alias.st status
  git config --global alias.ci commit
  git config --global alias.co checkout
  git config --global alias.br branch
  git config --global alias.sr show-ref
  git config --global alias.cm '!sh -c "br_name=`git symbolic-ref HEAD|sed s#refs/heads/##`; git commit -em \"[\${br_name}] \""'
  git config --global alias.lg "log --graph --pretty=format:'%Cred%h%Creset -%x09%C(yellow)%d%Creset %C(cyan)[%an]%Creset %x09 %s %Cgreen(%cr)%Creset' --abbrev-commit --date=relative"

  source ~/.bashrc


echo "####################################"
echo "Set up complete."
}

#######################################
setup_git
