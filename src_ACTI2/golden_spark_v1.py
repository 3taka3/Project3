#pip install pyspark /#sudo apt install default-jdk
from pyspark.sql import SparkSession

__all__ = ["SparkSession"]

# Création d'une instance de SparkSession
spark = SparkSession.builder \
    .appName("GoldenLine") \
    .getOrCreate()

# Création d'une DataFrame avec une seule colonne et une seule ligne contenant le texte "Hello, World!"
data = [("Hello, World!",)]
df = spark.createDataFrame(data, ["Golden Line Spark"])
# Centrage du texte dans la colonne "Golden Line Spark"

# Affichage du contenu de la DataFrame
df.show()

# Création d'un RDD (Resilient Distributed Dataset) à partir d'une liste
data = [1, 2, 3, 4, 8]
rdd = spark.sparkContext.parallelize(data)

# Calcul de la somme des éléments
somme = rdd.sum()

# Calcul le nombre d'élement
decompte = rdd.count()

# Affichage des résultats
print("Somme des éléments:", somme)
print("Nombre d'éléments:", decompte)

# Arrêt de la session Spark
spark.stop()
