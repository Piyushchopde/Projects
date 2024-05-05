import boto3

def stop_ec2_instance(tag_key, tag_value, region):
    ec2 = boto3.client('ec2', region_name=region)
    response = ec2.describe_instances(
        Filters=[
            {
                'Name': 'tag:'+tag_key,
                'Values': [tag_value]
            }
        ]
    )
    instance_id = response['Reservations'][0]['Instances'][0]['InstanceId']
    ec2.stop_instances(InstanceIds=[instance_id])
    return instance_id

def lambda_handler(event, context):
    tag_key = "WorkingHoursFlag"
    tag_value = "True"
    region = "us-east-1"
    instance_id = stop_ec2_instance(tag_key, tag_value, region)
    return instance_id