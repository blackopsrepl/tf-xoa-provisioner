import re, json, boto3

def get_variable(variable):
    variables = "variables.tf"
    pattern = r'variable\s+"([^"]+)"\s+{\s+default\s+=\s+"([^"]+)"\s+}'
    with open(variables, "r") as file:
        content = file.read()
        matches = re.findall(pattern, content)
        for match in matches:
            if match[0] == variable:
                return match[1]

iam = boto3.client('iam', region_name=get_variable("aws_region"))
s3 = boto3.client('s3', region_name=get_variable("aws_region"))
service_role_arn = iam.get_role(RoleName='vdistefano-sagemaker')['Role']['Arn']
bucket_name = get_variable("terraform_bucket")

def check_bucket(bucket_name):
    try:
        s3.head_bucket(Bucket=bucket_name)
        s3.put_object(Bucket=bucket_name, Key='test', Body='test')
        s3.delete_object(Bucket=bucket_name, Key='test')
        return True
    except:
        return False

if not check_bucket(bucket_name):
    print(f"Creating terraform backend bucket {bucket_name}")
    s3.create_bucket(Bucket=bucket_name, CreateBucketConfiguration={'LocationConstraint': get_variable("aws_region")})
    s3.get_waiter('bucket_exists').wait(Bucket=bucket_name)
    bucket_policy = {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Effect": "Allow",
                "Principal": {
                    "AWS": service_role_arn
                },
                "Action": "s3:*",
                "Resource": [
                    f"arn:aws:s3:::{bucket_name}",
                    f"arn:aws:s3:::{bucket_name}/*"
                ]
            }
        ]
    }
    print(f"Attaching bucket policy to terraform backend bucket {bucket_name}")
    s3.put_bucket_policy(Bucket=bucket_name, Policy=json.dumps(bucket_policy))
    print(f"Testing bucket policy on terraform backend bucket {bucket_name}")
    if not check_bucket(bucket_name):
        print("Bucket or policy not working, please check!")
        exit(1)
    else:
        print(f"Bucket {bucket_name} Done!")
        exit(0)
else:
    print(f"Terraform backend bucket already exists: {bucket_name}")
    if not check_bucket(bucket_name):
        print("Bucket or policy not working, please check!")
        exit(1)
    else:
        print(f"Bucket {bucket_name} works correctly! Done!")
        exit(0)