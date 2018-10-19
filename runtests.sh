#!/bin/sh

APPDIR=/var/tests
CURDIR=`pwd`
IMAGE=horneds/ubuntu14.04-ansible

RUNNER=`docker run -v $CURDIR:$APPDIR -w $APPDIR -t -i -d horneds/ubuntu14.04-ansible bash`

assert () {
    docker exec -it $RUNNER $1 || ( echo ${2-'Test is failed'} && exit 1 )
}

{
    assert "ansible-playbook -c local --syntax-check test.yml"          &&
    assert "ansible-playbook -c local test.yml"                         &&
    # it changes 2 because one is the call of the handler and the other is the call of the stub handler
    assert "ansible-playbook -c local test.yml" | grep changed=2

} || {

    echo "Tests are failed"

}

docker exec -it $RUNNER /bin/bash

docker stop $RUNNER
