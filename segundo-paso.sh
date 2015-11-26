#!/bin/bash

# AUTOR: hefesto
# Objetivo: Continuación de primer-paso.sh
# Manual de uso:


# echo 'Esto fue probado en fedora 23.'
# sudo su -
# chmod +x primer-paso.sh
# ./primer-paso.sh
# echo 'Sonreir sí y sólo sí se pudo instalar sin error.'

################ Secundo Paso ########################

echo "Continuando con la instalación de postgres 9.4"
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
