from django.urls import include, path
from rest_framework.routers import SimpleRouter

from apps.samples.views import KeyViewSet

router = SimpleRouter()
router.register("key", KeyViewSet, basename="sample-keys")


urlpatterns = [path("", include(router.urls))]
