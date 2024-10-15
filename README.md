# InfraAsCode

The repository contains aws resources created by OpenTofu with best practices. 

# Commands

MODULE=`basename "$PWD"
tofu init -backend-config="bucket=$S3_TOFU_STATE" -backend-config="key=$MODULE.state" -backend-config="region=$AWS_REGION" -backend-config="encrypt=true" -backend-config="dynamodb_table=$DDB_TOFU_STATE_LOCK"
