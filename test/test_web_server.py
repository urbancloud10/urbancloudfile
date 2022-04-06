import unittest
from src.web_server import tree


class TestWebServerResponse(unittest.TestCase):
    
    def setUp(self) -> None:
        return super().setUp()

    def test_tree_respose(self):
        response = tree()
        self.assertTrue('myFavouriteTree' in response.keys())
        self.assertEqual(response['myFavouriteTree'], "evergreen oak")

if __name__ == '__main__':
    unittest.main()