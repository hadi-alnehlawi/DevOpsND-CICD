aws cloudformation deploy  --stack-name network --template-file ./network.yml  --region us-east-1 --profile udacity;
aws cloudformation deploy  --stack-name backend --template-file ./backend.yml  --region us-east-1 --profile udacity;
# aws cloudformation deploy  --stack-name frontend --template-file ./frontend.yml  --region us-east-1 --profile udacity;
# aws cloudformation delete-stack --stack-name frontend --profile udacity;
# aws cloudformation delete-stack --stack-name backend --profile udacity;
# aws cloudformation delete-stack --stack-name network --profile udacity;