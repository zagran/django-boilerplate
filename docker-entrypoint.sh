#!/bin/bash
set -e

export APP=api

# We need to know if flavor is set
if [ ! -z ${FLAVOR+x} ] ; then
  echo "* Starting APP=${APP} with FLAVOR=${FLAVOR}"
else
  echo "* WARNING: No FLAVOR, environment may not load properly."
fi

if [[ $1 =~ ^(/bin/)?(ba)?sh$ ]]; then
  echo "* First CMD argument is a shell: $1"
  echo "* Running: exec ${@@Q}"
  exec "$@"
elif [[ "$*" =~ ([;<>]|\(|\)|\&\&|\|\|) ]]; then
  echo "* Shell metacharacters detected, passing CMD to bash"
  _quoted="$*"
  echo "* Running: exec /bin/bash -c ${_quoted@Q}"
  unset _quoted
  exec /bin/bash -c "$*"
fi

# dumb-init used to ensure proper handling of signals, zombies, etc.
# See https://github.com/Yelp/dumb-init

echo "* Running command: /.venv/bin/dumb-init ${@@Q}"
exec /app/.venv/bin/dumb-init "$@"
