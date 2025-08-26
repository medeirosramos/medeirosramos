# tests/test_01.py
import sys
import os
sys.path.insert(0, os.path.abspath('.'))
import unittest
# from presos_etl_siapen.api_Siapen import test_api_siapen

class TestModulo1(unittest.TestCase):
    def test_padrao(self):
        # self.assertEqual(test_api_dashboard(), 'resultado esperado')
        # assert test_api_siapen() == None
        assert None == None