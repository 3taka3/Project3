# Utilisez une image Linux de base
FROM ubuntu:24.02

# Installez les packages nécessaires (Apache, MySQL, PHP, etc.)
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    apache2 \
    mysql-server \
    php libapache2-mod-php php-mysql

# Copiez vos fichiers PHP dans le répertoire du serveur web
COPY ./html /var/www/html

# Exposez le port 80 pour Apache
EXPOSE 80

# Commande par défaut pour lancer Apache
CMD ["apache2ctl", "-D", "FOREGROUND"]


FAjouter build et test 
