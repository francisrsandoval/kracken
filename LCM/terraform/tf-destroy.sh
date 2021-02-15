#!/bin/sh

echo "Hi, your running tf-destroy.sh"
cd $TFDIR
terraform destroy --auto-approve
if [ $? -eq 0 ]; then
    echo "terraform destroy result: OK"
else
    echo "terraform destroy result: FAIL"
fi
