#!/bin/bash

# AUTOR: hefesto
# Objetivo: Este script se utilizó para que el usuario pueda replicar el ambiente de producción localmente.
# Manual de uso:
# echo "Se necesitan hacer cambios a /etc/yum.repos.d/fedora.repo file y /etc/yum.repos.d/fedora-updates.repo correspondientemente:
# [fedora]
# ...
# exclude=postgresql*
# [updates]
# ...
# exclude=postgresql*"

# echo 'Esto fue probado en fedora 23.'
# sudo su -
# chmod +x primer-paso.sh
# ./primer-paso.sh
# echo 'Sonreir sí y sólo sí se pudo instalar sin error.'

################ Primer Paso ########################

echo "dnf update"
yum install --nogpgcheck http://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm http://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y
dnf update -y

echo "Instalando cosas..."
dnf install zsh emacs tomcat vim nginx -y
echo "Instalando postgres 9.4"
rpm -Uvh http://yum.postgresql.org/9.4/fedora/fedora-22-x86_64/pgdg-fedora94-9.4-4.noarch.rpm
dnf install postgresql94 postgresql94-server postgresql94-contrib
su - postgres -c /usr/pgsql-9.4/bin/initdb

# Modificar archivo /var/lib/pgsql/9.4/data/postgresql.conf agregando:
# listen_addresses = 'localhost'
# port = 5432
echo $1 | sudo -S stemctl start postgresql-9.4.service
echo $1 | sudo -S systemctl enable postgresql-9.4.service
echo $1 | sudo -S su - postgres
createdb test # Esto me dio un error: la base de datos ya existía
psql test
CREATE ROLE testuser WITH SUPERUSER LOGIN PASSWORD 'test';
exit
# Para probar la conexión utilizar:
# psql -h localhost -U testuser test
firewall-cmd --get-active-zones

# zsh
curl -L https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh | sudo sh
curl -L https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh | sh
sudo chsh -s /bin/zsh hefesto

echo "configuración de emacs y zsh según las preferencias de hefesto"
git clone https://github.com/hhefesto/dotfiles.git
cd dotfiles
cp -rf emacs.d/ ~/.emacs.d
cp -rf zshrc ~/.zshrc
