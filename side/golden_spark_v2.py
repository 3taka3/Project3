# pip install pyspark /#sudo apt install default-jdk
import unittest
from pyspark.sql import SparkSession

__all__ = ["SparkSession"]

# Création d'une instance de SparkSession
spark = SparkSession.builder \
    .appName("HelloWorld") \
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

# test unit
class TestSparkApp(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        # Initialiser la session Spark pour tous les tests
        cls.spark = SparkSession.builder \
            .appName("UnitTest") \
            .getOrCreate()

    def test_dataframe_creation(self):
        # Test la création d'une DataFrame
        data = [("Hello, World!",)]
        df = self.spark.createDataFrame(data, ["Golden Line Spark"])
        self.assertEqual(df.count(), 1)
        self.assertEqual(df.first()["Golden Line Spark"], "Hello, World!")

    def test_rdd_operations(self):
        # Test des opérations RDD
        data = [1, 2, 3, 4, 8]
        rdd = self.spark.sparkContext.parallelize(data)
        self.assertEqual(rdd.sum(), sum(data))
        self.assertEqual(rdd.count(), len(data))
    
    def tearDownClass(cls):
        # Arrêter la session Spark après tous les tests
        cls.spark.stop()

unittest.main()