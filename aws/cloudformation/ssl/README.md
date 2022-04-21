
# Import Certificate associated with SSL by aws cli
sudo aws acm import-certificate \
    --certificate fileb://~/.aws/prod_weifenglai.me/prod_weifenglai_me.crt \
    --certificate-chain fileb://~/.aws/prod_weifenglai.me/prod_weifenglai_me.ca-bundle \
    --private-key fileb://~/.aws/private.key \
    --profile demo

