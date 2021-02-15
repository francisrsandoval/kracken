# coding: utf-8

from __future__ import absolute_import

from flask import json
from six import BytesIO

from swagger_server.models.network_service_item import NetworkServiceItem  # noqa: E501
from swagger_server.test import BaseTestCase


class TestDevelopersController(BaseTestCase):
    """DevelopersController integration test stubs"""

    def test_search_network_service(self):
        """Test case for search_network_service

        searches NetworkService
        """
        query_string = [('search_string', 'search_string_example'),
                        ('skip', 1),
                        ('limit', 50)]
        response = self.client.open(
            '/pajarito/NetworkService/1.0.0/NetworkService',
            method='GET',
            query_string=query_string)
        self.assert200(response,
                       'Response body is : ' + response.data.decode('utf-8'))


if __name__ == '__main__':
    import unittest
    unittest.main()
