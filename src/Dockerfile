# Utiliser l'image officielle de PySpark
FROM bitnami/spark:latest

USER 0

# Définir le répertoire de travail
WORKDIR /app

# Copier le code source dans l'image
COPY . /app

# Installer les dépendances Python - 
RUN pip3 install --no-cache-dir -r requirements.txt 

# Exécuter les tests unitaires
CMD ["python", "-m", "unittest", "golden_spark_v1.py"]

USER 185