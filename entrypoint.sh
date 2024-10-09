#!/bin/sh -l

aws eks update-kubeconfig --name tensorkube --region us-east-1 
ls -l
cd $8 

export TENSORKUBE_TOKEN=$9
export TENSORKUBE_SESSION_ID=${10}

echo "Version: 17.2"

secrets=$(echo ${11} | tr ' ' '\n')
echo "secrets input: ${11}"

# Create a string with the --secret flag for each secret
secrets_flags=""
for secret in $secrets; do
    echo "secret: $secret"
    secrets_flags="$secrets_flags --secret $secret"
done

echo "Secrets flags: $secrets_flags"

if [ -n "$2" ]; then
    if [ -n "$7" ]; then
        tensorkube deploy --gpus $1 --gpu-type $2 --cpu $3 --memory $4 --min-scale $5 --max-scale $6 --env $7 --github-actions $secrets_flags
    else
        tensorkube deploy --gpus $1 --gpu-type $2 --cpu $3 --memory $4 --min-scale $5 --max-scale $6 --github-actions $secrets_flags
    fi
else
    if [ -n "$7" ]; then
        tensorkube deploy --gpus $1 --cpu $3 --memory $4 --min-scale $5 --max-scale $6 --env $7 --github-actions $secrets_flags
    else
        tensorkube deploy --gpus $1 --cpu $3 --memory $4 --min-scale $5 --max-scale $6 --github-actions $secrets_flags
    fi
fi