#!/bin/sh

echo "Hi, your running ts-apply.sh"
echo "ts-apply: TFDIR = "$TFDIR
cd $TFDIR
terraform init
terraform plan -out ns-plan
terraform apply --auto-approve ns-plan
if [ $? -eq 0 ]; then
    echo "terraform apply result: OK"
else
    echo "terraform apply result: FAIL"
fi
