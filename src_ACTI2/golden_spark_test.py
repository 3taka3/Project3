import unittest
from pyspark.sql import SparkSession

class TestSparkApp(unittest.TestCase):

    @classmethod
    def setUpClass(cls):
        # Créer une session Spark pour tous les tests
        cls.spark = SparkSession.builder \
            .appName("Test Spark App") \
            .getOrCreate()

    @classmethod
    def tearDownClass(cls):
        # Arrêter la session Spark après tous les tests
        cls.spark.stop()

    def test_dataframe_creation(self):
        # Créer une DataFrame et vérifier le contenu
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

