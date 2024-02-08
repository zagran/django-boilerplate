import factory

from apps.samples.models import Key


class KeyFactory(factory.django.DjangoModelFactory):
    class Meta:
        model = Key
