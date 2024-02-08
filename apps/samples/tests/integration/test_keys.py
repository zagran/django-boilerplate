from django.urls import reverse


class TestKeys:
    @classmethod
    def teardown_class(cls):
        pass

    def test_get(self, api_client):
        url = reverse("sample-keys-list")
        response = api_client.get(url)
        assert response.status_code == 200

    def test_post(self, api_client):
        url = reverse("sample-keys-list")
        response = api_client.post(url, format="json", data={"value": "string"})
        assert response.status_code == 201
