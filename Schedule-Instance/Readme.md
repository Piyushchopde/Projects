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

Step 2: create your EC2 instances
Create a file “Ec2-instance.tf” and paste this code:
Observe that we are defining a tag “WorkingHoursFlag” which is set to True or False, based on the EC2 instance:
the EC2 instance that will be active only from 9 AM to 5 PM will have the tag “WorkingHoursFlag” set to “True”
So tags are an efficient way of distinguishing between resources and making them behave differently.

Step 3: setup Lambda Functions
We will first create the Lambda function which is responsible for starting the EC2 instance. Define a Python script called “lambda_startec2.py” and paste this code:
As you can see there is a lambda handler and a function “start_ec2_instance()”. Python uses the boto3 library to allow the Lambda function to access the other AWS services, such as EC2. There are two main functions:

- describe_instances() retrieves the EC2 instances that corresponds to a specific tag that we pass in Filters, in our case we are taking those EC2 instances that have the tag “WorkingHoursFlag” set to True. Since we know that we have only 1 EC2 instance that should account for the workday schedule, we take the the first EC2 instance.
- 
- start_instances() starts up the EC2 instances whose ID is passed in the corresponding argument of the method.

The code for the other Lambda function is almost the same, so define a file “lambda_stopec2.py” and paste this:
Then create a file called “lambda.tf” and paste this code:
For each Lambda function Terraform needs to zip the code and create an archive that will be uploaded by indicating the zipped file as “filename” in “aws_lambda_function”.

Step 4: create IAM roles for Lambda functions
As you can see we have a field “role” in “aws_lambda_function”. The Lambda functions must have the permissions to invoke the previous methods to retrieve, start and stop EC2 instances, as well as access logs. Create a file “iam.tf”, in which we define the IAM role and attach some policies it.
Note that we are also defining a data source that allows the “lambda.amazonaws.com” service to assume roles using the “sts:AssumeRole” action.

Step 5: setup Amazon EventBridge Schedulers
Then define a file “scheduler.tf” in which we configure the schedulers that will trigger the Lambda functions. You can also define CloudWatch Event rules, which is the old approach but it has the same logic.
Also schedulers have a service role, to which must be attached a policy that permits the action “lambda:InvokeFunction” to be able to trigger the Lambda functions. So add this to “iam.tf”:

