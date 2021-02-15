# coding: utf-8

from __future__ import absolute_import

from flask import json
from six import BytesIO

from swagger_server.models.network_service_item import NetworkServiceItem  # noqa: E501
from swagger_server.models.network_service_state import NetworkServiceState  # noqa: E501
from swagger_server.test import BaseTestCase


class TestAdminsController(BaseTestCase):
    """AdminsController integration test stubs"""

    def test_add_network_service(self):
        """Test case for add_network_service

        adds an NetworkService item
        """
        body = NetworkServiceItem()
        response = self.client.open(
            '/pajarito/NetworkService/1.0.0/NetworkService',
            method='POST',
            data=json.dumps(body),
            content_type='application/json')
        self.assert200(response,
                       'Response body is : ' + response.data.decode('utf-8'))

    def test_lcm_network_service(self):
        """Test case for lcm_network_service

        Lifecycle Management af NetworkService item
        """
        body = NetworkServiceState()
        response = self.client.open(
            '/pajarito/NetworkService/1.0.0/NetworkService/LCM',
            method='POST',
            data=json.dumps(body),
            content_type='application/json')
        self.assert200(response,
                       'Response body is : ' + response.data.decode('utf-8'))


if __name__ == '__main__':
    import unittest
    unittest.main()
