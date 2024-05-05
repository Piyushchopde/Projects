This project aims to automate the management of EC2 instances in AWS using serverless architecture, specifically utilizing Terraform, AWS Lambda and Amazon EventBridge Schedulers. The primary objective is to efficiently handle the start and stop operations of EC2 instances based on predefined schedules, such as working hours, to optimize cost savings.

Here’s a breakdown of the project components and how they work together:

- EC2 Instances: These are the virtual servers running on AWS’s cloud infrastructure. Organizations often use EC2 instances for various tasks, but running them continuously can result in unnecessary costs, especially for instances only required during specific hours, such as working hours.

- Lambda Functions: Two Lambda functions will be created:

- Start AWS Lambda: This function will contain the code to start EC2 instances. When triggered by an Amazon EventBridge Scheduler at the beginning of working hours (e.g., 9 AM), this Lambda will initiate the start operation for the specified EC2 instances.

- Stop AWS Lambda: Conversely, this function will handle the code to stop EC2 instances. It will be triggered by another scheduler at the end of working hours (e.g., 5 PM), halting the specified EC2 instances.

The functionality for starting and stopping EC2 instances will be written in Python within the respective Lambda functions. The code will utilize AWS SDK for Python (Boto3) to interact with AWS services programmatically. This includes identifying the EC2 instances to be managed and executing the start or stop actions accordingly.

- Amazon EventBridge Schedulers: EventBridge, before known as CloudWatch Event, is AWS’s monitoring and management service. EventBridge Schedulers enable the triggering of automated actions based on predefined schedules or events. In this project, an EventBridge Scheduler will be configured to trigger the Start Instances Lambda at the beginning of the workday and the Stop Instances Lambda at the end of the workday.

The provided architecture diagram visually shows what we will create and how the different components interact. It illustrates the flow of events from EventBridge Schedulers triggering the respective Lambda functions, which then execute the start or stop operations on an EC2 instance.
<img width="509" alt="image" src="https://github.com/Piyushchopde/Projects/assets/88358122/e902d1c7-5b32-46b1-aabe-1e6e80ef0e84">

Step 1: setup your provider
The first step is to create a file “provider.tf”. Choose the AWS region that you prefer:

provider "aws" {
  region = "us-east-1"

}

terraform {
    required_providers {
        aws = {
        source  = "hashicorp/aws"
        version = "~> 5.0"
        }
    }
}


Step 2: create your EC2 instances
Create a file “Ec2-instance.tf” and paste this code:
resource "aws_instance" "ec2_9_5" {
  ami = "ami-0facbf2a36e11b9dd" # Amazon Linux 2023 AMI, eu-west-3
  instance_type = "t2.micro"
  tags = {
    Name = "EC2 9to5"
    WorkingHoursFlag = "True"
  }
}

resource "aws_instance" "ec2_24_7" {
  ami = "ami-0facbf2a36e11b9dd" # Amazon Linux 2023 AMI, eu-west-3
  instance_type = "t2.micro"
  tags = {
    Name = "EC2 24h"
    WorkingHoursFlag = "False"
  }
}


Observe that we are defining a tag “WorkingHoursFlag” which is set to True or False, based on the EC2 instance:

the EC2 instance that will be active only from 9 AM to 5 PM will have the tag “WorkingHoursFlag” set to “True”
the EC2 instance that runs continuously 24/7 will have the tag “WorkingHoursFlag” set to “False”.
So tags are an efficient way of distinguishing between resources and making them behave differently.

