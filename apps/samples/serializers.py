from rest_framework.serializers import ModelSerializer

from apps.samples.models import Key


class KeySerializer(ModelSerializer):
    class Meta:
        model = Key
        fields = ("id", "value")
