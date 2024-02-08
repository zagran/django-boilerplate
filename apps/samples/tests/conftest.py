import pytest
from pytest_factoryboy import register
from rest_framework.test import APIClient

from apps.samples.tests.factories import KeyFactory

register(KeyFactory)


@pytest.fixture
def api_client(admin_user) -> APIClient:
    client = APIClient()
    client.force_login(user=admin_user)

    session = client.session
    session.update(
        {
            "username": admin_user.username,
        }
    )
    session.save()
    client.cookies.load({"UserLogin": admin_user.username})
    return client
