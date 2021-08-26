"""
Description:
=============
    This Python 3 script executes initial setup (init) process for an Aviatrix Controller,
    and it creates an AWS IAM Role based Access Account in the controller.


Prerequisites:
==============
    * Aviatrix Controller instance
    * Controller Firewall open for HTTPS access (TCP port 443)
      (AWS-Security-Group, Azure-Firewall and GoogleCloud-Firewall)


Input Parameters for the Script:
=================================
"ResourceProperties": {
    "LambdaInvokerTypeParam": "terraform",  # (REQUIRED)  # Valid values: "terraform", "tf", "cloudformation", "cf"
    "PrefixStringParam": "avx",  # (OPTIONAL)
    "KeywordForCloudWatchLogParam": "avx-lambda-function",  # (OPTIONAL)  This parameter is a string which is being used for CloudWatch loggin
    "DelimiterForCloudWatchLogParam": "---",  # (OPTIONAL) This parameter is used along with the parameter "KeywordForCloudWatchLogParam"
    "ControllerPublicIpParam": "123.123.123.123",  # (REQUIRED)
    "_SecondsToWaitForApacheToBeUpParam": 123  # (OPTIONAL)  value can be either str or int
    "AviatrixApiVersionParam": "v1",  # (OPTIONAL) Default value is "v1"
    "AviatrixApiRouteParam": "api/",  # (OPTIONAL) Default value is "api/"
    "ControllerPrivateIpParam": "10.1.2.3",  # (REQUIRED)
    "ControllerAdminPasswordParam": "Aviatrix123!",  # (REQUIRED)
    "ControllerAdminEmailParam": "test@aviatrix.com",  # (REQUIRED)
    "ControllerVersionParam": "latest"  # (OPTIONAL) Default value is "latest"
    "AviatrixCustomerLicenseIdParam": "aviatrix-customer-license-id-abcde12345,  # (OPTIONAL)
                                                                               How do I find out my controller type?
                                                                               https://s3-us-west-2.amazonaws.com/aviatrix-download/AMI_ID/ami_id.json
    "AWS_Account_ID": "987654321012",  # (REQUIRED)
    "ControllerAccessAccountNameParam": "my-access-account",  # (REQUIRED)
}


Script Workflow Overview:
==========================
    Phase 01: Environment/Prerequisites Checking
        * Wait until controller apache2 server is up and running.
          (Check if HTTPS response is 200)

    Phase 02: Start Init process
        * Login controller with private IP.
        * Reset admin password.
        * Re-login with new password
        * Set admin email.
        * Skip controller proxy setup process.
        * Upgrade controller to the Aviatrix latest software version.
          (could specify the version in later version of this script)
        * Wait until the latest software is fully downloaded and apache2 server
          is up and running. (wait for exact 180 seconds)
          (Check if HTTPS response is 200)

    Phase 03:
        * Login
        * Create an AWS IAM Role based Access Account
        * Verify the account creation by invoking Aviatrix API

    Phase 04:
        * Set Aviatrix Customer ID (ONLY if controller type is BYOL)


Dev-Notes:
    * It takes about 60 seconds in average to for API server to be available for a brand new controller.
        + The time measurement starts at the moment when click [Launch Instance] to the point that AVX API server is responsive
        + Tested in different regions (us, sa, ap, eu), and instance type is t2.medium
    *  login with POST is not supported in 2.7 (supported in 2.6)
    * "list_version_info" is supported in 2.7 and later releases
    * "change_password" is supported in 2.6 and later releases. However, "edit_account_user" was introduced in 2.7

Author:
========
    Ryan Liu (Aviatrix System)
"""

# print("Starting Aviatrix Lambda function to initialize an Aviatrix controller instance!\n\n")

import time
import os
import json
import traceback
import re
import requests


requests.packages.urllib3.disable_warnings()


# Global Variables
DEFAULT_WAIT_TIME_FOR_1ST_APACHE_WAKEUP = 600


class AviatrixException(Exception):
    def __init__(self, message="Aviatrix Error Message: ..."):
        super(AviatrixException, self).__init__(message)
# END class MyException


def lambda_handler(event, context):
    print(event)  # For debugging purpose if ever needed

    ### Get the values from "event" for variables, ONLY if the keys are found in the "event" dictionary
    keyword_for_log = ""
    if "KeywordForCloudWatchLogParam" in event["ResourceProperties"] and "DelimiterForCloudWatchLogParam" in event["ResourceProperties"]:
        keyword_for_log = "{0}{1}".format(
            str(event["ResourceProperties"]["KeywordForCloudWatchLogParam"]),
            str(event["ResourceProperties"]["DelimiterForCloudWatchLogParam"])
        )
    lambda_invoker_type = get_lambda_invoker_type(event)

    controller_public_ip = str(event["ResourceProperties"]["ControllerPublicIpParam"])

    try:
        _lambda_handler(event, context)
    except AviatrixException as e:
        traceback_msg = traceback.format_exc()
        # print(keyword_for_log + "Oops! Aviatrix Lambda caught an exception! The traceback message is: ")
        # print(traceback_msg)
        lambda_failure_reason = "Error: Aviatrix Lambda function failed due to " + str(e)
        print(keyword_for_log + lambda_failure_reason)
        if lambda_invoker_type == "terraform" or lambda_invoker_type == "tf":
            response_for_terraform = _build_response_for_terraform(
                event=event,
                status=False,
                message=lambda_failure_reason,
                keyword_for_log=keyword_for_log,
                indent=""
            )
            return response_for_terraform
        elif lambda_invoker_type == "cloudformation" or lambda_invoker_type == "cf":
            response_for_cloudformation = _build_response_for_cloudformation_stack(
                event=event,
                status="FAILED",
                reason=lambda_failure_reason,
                keyword_for_log=keyword_for_log,
                indent=""
            )
            response = requests.put(
                url=event["ResponseURL"],
                data=json.dumps(response_for_cloudformation)
            )
            return response_for_cloudformation
        elif lambda_invoker_type == "generic":
            response_for_generic_lambda_invoker = _build_response_for_generic_lambda_invoker(
                event=event,
                status=False,
                message=lambda_failure_reason,
                keyword_for_log=keyword_for_log,
                indent=""
            )
            return response_for_generic_lambda_invoker
        else:
            err_msg = "Lambda (Aviatrix Controller Initial Setup) does not support the Invoker Type: " + \
                      str(lambda_invoker_type)
            response_for_terraform = _build_response_for_generic_lambda_invoker(
                event=event,
                status=False,
                message=lambda_failure_reason,
                keyword_for_log=keyword_for_log,
                indent=""
            )
            return response_for_terraform
        # END if-else
    except Exception as e:  # pylint: disable=broad-except
        traceback_msg = traceback.format_exc()
        lambda_failure_reason = "Oops! Aviatrix Lambda caught an exception! The traceback message is: \n" + str(traceback_msg)
        print(keyword_for_log + lambda_failure_reason)
        if lambda_invoker_type == "terraform" or lambda_invoker_type == "tf":
            response_for_terraform = _build_response_for_terraform(
                event=event,
                status=False,
                message=lambda_failure_reason
            )
            return response_for_terraform
        elif lambda_invoker_type == "cloudformation" or lambda_invoker_type == "cf":
            response_for_cloudformation = _build_response_for_cloudformation_stack(
                event=event,
                status="FAILED",
                reason=lambda_failure_reason,
                keyword_for_log=keyword_for_log
            )
            response = requests.put(
                url=event["ResponseURL"],
                data=json.dumps(response_for_cloudformation)
            )
            return response_for_cloudformation
        elif lambda_invoker_type == "generic":
            response_for_generic_lambda_invoker = _build_response_for_generic_lambda_invoker(
                event=event,
                status=False,
                message=lambda_failure_reason,
                keyword_for_log=keyword_for_log,
                indent=""
            )
            return response_for_generic_lambda_invoker
        else:
            err_msg = "Lambda (Aviatrix Controller Initial Setup) does not support the Invoker Type: " + \
                      str(lambda_invoker_type)
            response_for_terraform = _build_response_for_generic_lambda_invoker(
                event=event,
                status=False,
                message=lambda_failure_reason
            )
            return response_for_terraform
        # END if-else
    # END try-except


    # At this point, Aviatrix/AWS Lambda function has finished the tasks without error

    success_msg = "Successfully initialized an Aviatrix Controller: " + controller_public_ip

    if lambda_invoker_type == "terraform" or lambda_invoker_type == "tf":
        response_for_terraform = _build_response_for_terraform(
            event=event,
            status=True,
            message=success_msg,
            keyword_for_log=keyword_for_log,
            indent=""
        )
        return response_for_terraform
    elif lambda_invoker_type == "cloudformation" or lambda_invoker_type == "cf":
        response_for_cloudformation = _build_response_for_cloudformation_stack(
            event=event,
            status="SUCCESS",
            keyword_for_log=keyword_for_log,
            indent=""
        )
        response = requests.put(
            url=event["ResponseURL"],
            data=json.dumps(response_for_cloudformation)
        )
        return response_for_cloudformation
    elif lambda_invoker_type == "generic":
        response_for_generic_lambda_invoker = _build_response_for_generic_lambda_invoker(
            event=event,
            status=True,
            message=success_msg,
            keyword_for_log=keyword_for_log,
            indent=""
        )
        return response_for_generic_lambda_invoker

    ### This section should never be run because get_lambda_invoker_type() already filters the names,
    ### but it's just a precaution.
    else:
        err_msg = "Lambda (Aviatrix Controller Initial Setup) does not support the Invoker Type: " + \
                  str(lambda_invoker_type)
        response_for_generic_lambda_invoker = _build_response_for_generic_lambda_invoker(
            event=event,
            status=False,
            message=err_msg,
            keyword_for_log=keyword_for_log,
            indent=""
        )
        return response_for_generic_lambda_invoker
    # END if-else
# END def lambda_handler()


def get_lambda_invoker_type(event=dict()):
    lambda_invoker_type = "generic"  # set default value
    key = "LambdaInvokerTypeParam"

    ### Identify if LambdaInvokerTypeParam is Aviatrix Terraform
    if key in event["ResourceProperties"]:  # IF the AWS Lambda invoker passed its type in "event"
        lambda_invoker_type = "{}".format(str(event["ResourceProperties"]["LambdaInvokerTypeParam"])).lower()
        if _is_valid_lambda_invoker_type(lambda_invoker_type):
            return lambda_invoker_type
        # END inner if
    # END outer if

    ### Identify if LambdaInvokerTypeParam is AWS Cloudformation stack
    try:
        cf_stack_id = event["StackId"]
        lambda_invoker_type = "cloudformation"
        print("Aviatrix Lambda Invoker type is From AWS CFT")
    except (KeyError, AttributeError, TypeError):
        err_msg = 'Error: LambdaInvokerTypeParam is NOT from "terraform" or "cloudformation"'
        raise AviatrixException(
            message=err_msg,
        )

    return "generic"
# END def get_lambda_invoker_type()


def _is_valid_lambda_invoker_type(lambda_invoker_type=""):
    lambda_invoker_type = lambda_invoker_type.lower()
    if lambda_invoker_type == "terraform" or \
       lambda_invoker_type == "tf" or \
       lambda_invoker_type == "cloudformation" or \
       lambda_invoker_type == "cf":
        return True
    else:
        return False
# END def is_valid_invoker_type()


def _lambda_handler(event, context):
    ##### Display all parameters from lambda "event" object

    ### Get the values from "event" for variables, ONLY if the keys are found in the "event" dictionary
    keyword_for_log = ""
    if "KeywordForCloudWatchLogParam" in event["ResourceProperties"] and "DelimiterForCloudWatchLogParam" in event["ResourceProperties"]:
        keyword_for_log = "{0}{1}".format(
            str(event["ResourceProperties"]["KeywordForCloudWatchLogParam"]),
            str(event["ResourceProperties"]["DelimiterForCloudWatchLogParam"])
        )

    print(keyword_for_log + 'START: Display all parameters from lambda "event" object')
    print_lambda_event(event, keyword_for_log=keyword_for_log, indent="    ")
    prefix_str = event["ResourceProperties"]["PrefixStringParam"]
    ucc_public_ip = event["ResourceProperties"]["ControllerPublicIpParam"]

    ### Get a value from pydict, 'event'
    try:
        wait_time_for_1st_apache_wakeup = event['ResourceProperties']['_SecondsToWaitForApacheToBeUpParam']
    except KeyError as e:
        print(keyword_for_log + '''AWS-Lambda invoker didn't pass the parameter: "_SecondsToWaitForApacheToBeUpParam". ''')
        wait_time_for_1st_apache_wakeup = DEFAULT_WAIT_TIME_FOR_1ST_APACHE_WAKEUP

    aviatrix_api_version = event["ResourceProperties"]["AviatrixApiVersionParam"]
    aviatrix_api_route = event["ResourceProperties"]["AviatrixApiRouteParam"]
    ucc_private_ip = event["ResourceProperties"]["ControllerPrivateIpParam"]
    admin_email = event["ResourceProperties"]["ControllerAdminEmailParam"]
    new_admin_password = event["ResourceProperties"]["ControllerAdminPasswordParam"]
    controller_init_version = event["ResourceProperties"]["ControllerVersionParam"]

    aviatrix_customer_id = ""  # Initialized variable, "aviatrix_customer_id" with empty string
    ### Get the value from "event" for variable, "aviatrix_customer_id" ONLY if the key is found in the "event" dictionary
    if "AviatrixCustomerLicenseIdParam" in event["ResourceProperties"]:
        aviatrix_customer_id = event["ResourceProperties"]["AviatrixCustomerLicenseIdParam"]

    aws_account_id = event["ResourceProperties"]["AWS_Account_ID"]
    new_access_account_name = event["ResourceProperties"]["ControllerAccessAccountNameParam"]
    # new_access_account_password = event["ResourceProperties"]["ControllerAccessAccountPasswordParam"]
    # new_access_account_email = event["ResourceProperties"]["ControllerAccessAccountEmailParam"]

    ### Reconstruct some parameters
    aviatrix_customer_id = aviatrix_customer_id.rstrip()  # Remove the trailing whitespace characters
    aviatrix_customer_id = aviatrix_customer_id.lstrip()  # Remove the leading whitespace characters
    api_endpoint_url = "https://" + ucc_public_ip + "/" + aviatrix_api_version + "/" + aviatrix_api_route
    # if new_access_account_password == "":
    #     new_access_account_password = new_admin_password
    # if new_access_account_email == "":
    #     new_access_account_email = admin_email

    print(keyword_for_log + 'ENDED: Display all parameters from lambda "event" object\n\n')


    ### Wait until REST API service of Aviatrix controller is up and running
    print(keyword_for_log + 'START: Wait until API server of controller is up and running')
    wait_time = get_apache_max_wait_time(wait_time=wait_time_for_1st_apache_wakeup, indent='    ')
    wait_until_controller_api_server_is_ready(
        ucc_public_ip=ucc_public_ip,
        api_version=aviatrix_api_version,
        api_route=aviatrix_api_route,
        total_wait_time=wait_time,  # second(s)  The average time for a brand new controller is about 60 seconds
        interval_wait_time=10,  # second(s)
        keyword_for_log=keyword_for_log,
        indent="    "
    )
    print(keyword_for_log + 'ENDED: Wait until API server of controller is up and running\n\n')


    ### Login Aviatrix Controller as admin with private IP
    print(keyword_for_log + 'START: Invoke Aviatrix API to login Aviatrix Controller as admin with private IP')
    response = login(
        api_endpoint_url=api_endpoint_url,
        username="admin",
        password=ucc_private_ip,
        hide_password=False,
        keyword_for_log=keyword_for_log
    )
    verify_aviatrix_api_response_login(response=response, keyword_for_log=keyword_for_log, indent="    ")
    CID = response.json()["CID"]
    print(keyword_for_log + 'ENDED: Invoke Aviatrix API to login Aviatrix Controller as admin with private IP\n\n')


    ### Check if the controller has already been initialized
    print(keyword_for_log + 'START: Check if the controller has already been initialized')
    is_controller_initialized = has_controller_initialized(
        api_endpoint_url=api_endpoint_url,
        CID=CID,
        keyword_for_log=keyword_for_log
    )
    if is_controller_initialized:
        print(keyword_for_log + "Error: Controller has already been initialized. Terminating Lambda function...")
        avx_err_msg = "Error: Controller has already been initialized. "
        raise AviatrixException(
            message=avx_err_msg,
        )
    print(keyword_for_log + 'ENDED: Check if the controller has already been initialized\n\n')


    ''' MMM
    ### Get controller version
    print(keyword_for_log + 'START: Get controller version')
    controller_version = get_controller_version(
        api_endpoint_url=api_endpoint_url,
        CID=CID,
        keyword_for_log=keyword_for_log
    )
    print(keyword_for_log + '    Controller Version: ' + str(controller_version))
    print(keyword_for_log + 'ENDED: Get controller version\n\n')
    '''
    controller_version = "2.7"  # it's hard-coded for now because "list_version_info" doesn't work at the moment


    '''
    Description:
        Invoking [set_admin_email] BEFORE [set_admin_password] is a better practice in case something goes wrong
        during [set_admin_password], and we can still use [forget_password] to reset admin password.
    '''
    ### Set admin email
    print(keyword_for_log + 'START: Invoke Aviatrix API to set admin email')
    response = set_admin_email(
        api_endpoint_url=api_endpoint_url,
        CID=CID,
        admin_email=admin_email,
        keyword_for_log=keyword_for_log
    )
    verify_aviatrix_api_set_admin_email(response=response, keyword_for_log=keyword_for_log, indent="    ")
    print(keyword_for_log + 'ENDED: Invoke Aviatrix API to set admin email\n\n')


    ### Set admin password
    print(keyword_for_log + 'START: Invoke Aviatrix API to set admin password')
    response = set_admin_password(
        api_endpoint_url=api_endpoint_url,
        CID=CID,
        # controller_version=controller_version,
        old_admin_password=ucc_private_ip,
        new_admin_password=new_admin_password,
        keyword_for_log=keyword_for_log
    )
    verify_aviatrix_api_set_admin_password(response=response, keyword_for_log=keyword_for_log, indent="    ")
    print(keyword_for_log + 'ENDED: Invoke Aviatrix API to set admin password\n\n')

    ### Login Aviatrix Controller as admin with new admin password
    print(
        keyword_for_log +
        'START: Invoke Aviatrix API to login Aviatrix Controller as admin with new admin password'
    )
    response = login(
        api_endpoint_url=api_endpoint_url,
        username="admin",
        password=new_admin_password,
        keyword_for_log=keyword_for_log
    )
    verify_aviatrix_api_response_login(response=response, keyword_for_log=keyword_for_log, indent="    ")
    CID = response.json()["CID"]
    print(
        keyword_for_log +
        'ENDED: Invoke Aviatrix API to login Aviatrix Controller as admin with new admin password\n\n'
    )

    ''' PLACEHOLDER
    print(keyword_for_log + 'START: Invoke Aviatrix API to set controller proxy')
    response = set_controller_proxy((
        api_endpoint_url=api_endpoint_url,
        param1=param1,
        param2=param2,
        keyword_for_log=keyword_for_log
    )
    verify(response, keyword_for_log=keyword_for_log)
    print(keyword_for_log + 'ENDED: Invoke Aviatrix API to set controller proxy\n\n')
    '''

    print(keyword_for_log + 'START: Invoke Aviatrix API to run initial setup')
    response = run_initial_setup(
        api_endpoint_url=api_endpoint_url,
        CID=CID,
        target_version=controller_init_version,
        keyword_for_log=keyword_for_log
    )
    verify_aviatrix_api_run_initial_setup(response=response, keyword_for_log=keyword_for_log, indent="    ")
    print(keyword_for_log + 'ENDED: Invoke Aviatrix API to run initial setup\n\n')


    # wait_until_controller_initial_setup_finishes()  # PLACEHOLDER
    wait_time = 15
    print(keyword_for_log + 'START: Wait until controller finishes initial setup')
    print(keyword_for_log + '    Waiting for roughly ' + str(wait_time) + ' seconds...')
    time.sleep(wait_time)
    print(keyword_for_log + 'ENDED: Wait until controller finishes initial setup\n\n')


    ### Wait until apache2 of controller is up and running
    print(keyword_for_log + 'START: Wait until API server of controller is up and running')
    wait_until_controller_api_server_is_ready(
        ucc_public_ip=ucc_public_ip,
        api_version=aviatrix_api_version,
        api_route=aviatrix_api_route,
        total_wait_time=wait_time,  # second(s)
        interval_wait_time=10,  # second(s)
        keyword_for_log=keyword_for_log,
        indent="    "
    )
    print(keyword_for_log + 'ENDED: Wait until API server of controller is up and running\n\n')


    ### Re-login after initial-setup
    print(keyword_for_log + 'START: Re-login after initial-setup')
    response = login(
        api_endpoint_url=api_endpoint_url,
        username="admin",
        password=new_admin_password,
        keyword_for_log=keyword_for_log
    )
    verify_aviatrix_api_response_login(response=response, keyword_for_log=keyword_for_log, indent="    ")
    CID = response.json()["CID"]
    print(keyword_for_log + 'ENDED: Re-login after initial-setup\n\n')


    ''' START COMMENT: This section of code needs to be commented out after 4.1 is released
    # The difference between this section and the following section is "is_controller_type_byol()",
    # the Aviatrix API that this function uses, which is NOT supported before 4.1
    ENDED COMMENT: This section of code needs to be commented out after 4.1 is released '''
    # IF aviatrix_customer_id string has more than 3 characters
    if len(aviatrix_customer_id) > 3:
        print(keyword_for_log + 'START: Invoke Aviatrix API to set Aviatrix Customer ID')
        response = set_aviatrix_customer_id(
            api_endpoint_url=api_endpoint_url,
            CID=CID,
            customer_id=aviatrix_customer_id,
            keyword_for_log=keyword_for_log
        )

        py_dict = response.json()
        print(keyword_for_log + "Aviatrix API response --> " + str(py_dict))
        print(keyword_for_log + 'ENDED: Invoke Aviatrix API to set Aviatrix Customer ID\n\n')


    """ START COMMENT: This section of code is for the time when 4.1 is released
    # IF aviatrix_customer_id string has more than 3 characters
    if len(aviatrix_customer_id) > 3 and is_controller_type_byol(api_endpoint_url=api_endpoint_url, CID=CID):
        print(keyword_for_log + 'START: Invoke Aviatrix API to set Aviatrix Customer ID')
        response = set_aviatrix_customer_id(
            api_endpoint_url=api_endpoint_url,
            CID=CID,
            customer_id=aviatrix_customer_id,
            keyword_for_log=keyword_for_log
        )

        py_dict = response.json()
        print(keyword_for_log + "Aviatrix API response --> " + str(py_dict))
        print(keyword_for_log + 'ENDED: Invoke Aviatrix API to set Aviatrix Customer ID\n\n')
        
        ''' COMMENT START: Don't verify the operation of set_aviatrix_customer_id because this operation is optional
        verify_aviatrix_api_set_aviatrix_customer_id(
            response=response,
            keyword_for_log=keyword_for_log,
            indent="    "
        )
        print(keyword_for_log + 'ENDED: Invoke Aviatrix API to set Aviatrix Customer ID\n\n')
        COMMENT ENDED: Don't verify the operation of set_aviatrix_customer_id'''
        
    # END if
    '''
    ENDED COMMENT: This section of code is for the time when 4.1 is released """


    print(
        keyword_for_log +
        'START: Invoke Aviatrix API to create Access-Account which the cloud type is AWS IAM Role based'
    )
    app_role_arn = "arn:aws:iam::{AWS_ACCOUNT_ID}:role/aviatrix-role-app"
    app_role_arn = app_role_arn.format(AWS_ACCOUNT_ID=aws_account_id)
    ec2_role_arn = "arn:aws:iam::{AWS_ACCOUNT_ID}:role/aviatrix-role-ec2"
    ec2_role_arn = ec2_role_arn.format(AWS_ACCOUNT_ID=aws_account_id)
    response = create_access_account(
        api_endpoint_url=api_endpoint_url,
        CID=CID,
        account_name=new_access_account_name,
        # account_password=new_access_account_password,
        # account_email=new_access_account_email,
        cloud_type="1",
        aws_account_number=aws_account_id,
        is_iam_role_based="true",
        app_role_arn=app_role_arn,
        ec2_role_arn=ec2_role_arn,
        keyword_for_log=keyword_for_log
    )
    verify_aviatrix_api_create_access_account(
        response=response,
        admin_email=admin_email,
        keyword_for_log=keyword_for_log,
        indent="    "
    )
    print(
        keyword_for_log +
        'ENDED: Invoke Aviatrix API to create Access-Account which the cloud type is AWS IAM Role based\n\n'
    )

    # At this point, all lambda code statements are executed successfully with no errors.
    print(keyword_for_log + "Successfully completed lambda function with no errors!\n\n")
# END def _lambda_handler()


def _is_integer(string_to_check='123'):
    """
    This function checks if a string input can be converted to an integer
    :param  str  string_to_check:
    :return: True if the input can be converted to an integer
    """
    try:
        int(string_to_check)
        return True
    except ValueError:
        return False
# END def _is_integer()


def get_apache_max_wait_time(wait_time=600, indent=''):
    min_wait_time = 60
    max_wait_time = 600

    # Construct variable "wait_time"
    if _is_integer(wait_time):  # when "wait_time" is int-convertible
        if isinstance(wait_time, str):
            wait_time = eval(wait_time)
        # END if: convert str to int

        if wait_time < 60:  # when "wait_time" is less than 60 seconds
            print(indent + 'The max Apache wait time provided by AWS-Lambda caller is: ' + str(wait_time) + ' second(s), which might not be enough. Aviatrix auto-configures it to ' + str(min_wait_time) + ' seconds')
            wait_time = min_wait_time
        elif 600 < wait_time:  # when "wait_time" is greater than 600 seconds
            print(indent + 'The max Apache wait time provided by AWS-Lambda caller is: ' + str(wait_time) + ' second(s), which might be too long. Aviatrix auto-configures it to ' + str(max_wait_time) + ' seconds')
            wait_time = max_wait_time
        # ENF if: Take care of wait_time is either too short or too long
    else:
        print(indent + 'The max Apache wait time provided by AWS-Lambda caller is: ' + str(wait_time) + ' which is not valid. Aviatrix auto-configures it to default: ' + str(DEFAULT_WAIT_TIME_FOR_1ST_APACHE_WAKEUP) + ' seconds')
        wait_time = DEFAULT_WAIT_TIME_FOR_1ST_APACHE_WAKEUP
    # END outer if-else

    # print(indent + 'The finalized max Apache wait time is: ' + str(wait_time) + ' seconds')
    return wait_time
# END def get_apache_max_wait_time()


def print_lambda_event(
    event,
    keyword_for_log="avx-lambda-function---",
    indent="    "
        ):
    print(indent + keyword_for_log + "LambdaInvokerTypeParam                    --> " +
          event["ResourceProperties"]["LambdaInvokerTypeParam"])
    print(indent + keyword_for_log + "PrefixStringParam                    --> " +
          event["ResourceProperties"]["PrefixStringParam"])
    print(indent + keyword_for_log + "KeywordForCloudWatchLogParam         --> " +
          event["ResourceProperties"]["KeywordForCloudWatchLogParam"])
    print(indent + keyword_for_log + "DelimiterForCloudWatchLogParam       --> " +
        event["ResourceProperties"]["DelimiterForCloudWatchLogParam"])
    print(indent + keyword_for_log + "ControllerPublicIpParam              --> " +
        event["ResourceProperties"]["ControllerPublicIpParam"])
    print(indent + keyword_for_log + "AviatrixApiVersionParam              --> " +
        event["ResourceProperties"]["AviatrixApiVersionParam"])
    print(indent + keyword_for_log + "AviatrixApiRouteParam                --> " +
        event["ResourceProperties"]["AviatrixApiRouteParam"])
    print(indent + keyword_for_log + "ControllerPrivateIpParam             --> " +
        event["ResourceProperties"]["ControllerPrivateIpParam"])
    print(indent + keyword_for_log + "ControllerAdminEmailParam            --> " +
        event["ResourceProperties"]["ControllerAdminEmailParam"])
    # print(indent + keyword_for_log + "ControllerAdminPasswordParam  -    -> " +
    #     event["ResourceProperties"]["ControllerAdminPasswordParam"])
    print(indent + keyword_for_log + "ControllerVersionParam               --> " +
        event["ResourceProperties"]["ControllerVersionParam"])

    ### Get the value from "event" for variable, "aviatrix_customer_id" ONLY if the key is found in the "event" dictionary
    if "AviatrixCustomerLicenseIdParam" in event["ResourceProperties"]:
        print(indent + keyword_for_log + "AviatrixCustomerLicenseIdParam       --> " +
              event["ResourceProperties"]["AviatrixCustomerLicenseIdParam"])

    print(indent + keyword_for_log + "AWS_Account_ID                       --> " +
        event["ResourceProperties"]["AWS_Account_ID"])
    print(indent + keyword_for_log + "ControllerAccessAccountNameParam     --> " +
        event["ResourceProperties"]["ControllerAccessAccountNameParam"])
    # print(indent + keyword_for_log + "ControllerAccessAccountPasswordParam --> " +
    #     event["ResourceProperties"]["ControllerAccessAccountPasswordParam"])
    # print(indent + keyword_for_log + "ControllerAccessAccountEmailParam    --> " +
    #     event["ResourceProperties"]["ControllerAccessAccountEmailParam"])
# END def print_lambda_event()


def _build_response_for_terraform(
    event=None,  # AWS Lambda "event"
    status=False,  # Valid values: True, False (bool)
    # message="Succeesfully finished Initial Setup for Aviatrix Controller: 255.255.255.255",
    message="Failed Initial Setup for Aviatrix Controller: 255.255.255.255 due to: xxx",
    keyword_for_log="avx-lambda-function---",
    indent=""
        ):
    print(indent + keyword_for_log + "START: _build_response_for_terraform()")
    response_for_tf = {
        'status': status,  # (Required)
        'message': message  # (Required)
    }
    print(str(json.dumps(obj=response_for_tf, indent=4)))
    print(indent + keyword_for_log + "ENDED: _build_response_for_terraform()\n\n")
    return response_for_tf
# END def _build_response_for_terraform()


def _build_response_for_generic_lambda_invoker(
    event=None,  # AWS Lambda "event"
    status=False,  # Valid values: True, False (bool)
    # message="Succeesfully finished Initial Setup for Aviatrix Controller: 255.255.255.255",
    message="Failed Initial Setup for Aviatrix Controller: 255.255.255.255 due to: xxx",
    keyword_for_log="avx-lambda-function---",
    indent=""
        ):
    print(indent + keyword_for_log + "START: _build_response_for_generic_lambda_invoker()")
    response_for_generic_lambda_invoker = {
        'status': status,  # (Required)
        'message': message  # (Required)
    }
    print(str(json.dumps(obj=response_for_generic_lambda_invoker, indent=4)))
    print(indent + keyword_for_log + "ENDED: _build_response_for_generic_lambda_invoker()\n\n")
    return response_for_generic_lambda_invoker
# END def _build_response_for_generic_lambda_invoker()


def _build_response_for_cloudformation_stack(
    event=dict(),
    status="FAILED or SUCCESS",
    reason="Failed because...",
    data=dict(),
    keyword_for_log="avx-lambda-function---",
    indent=""
        ):
    """
        Reference:
            https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/crpg-ref-responses.html
    """
    print(indent + keyword_for_log + "START: _build_response_for_cloudformation_stack()")
    response_for_cf = {
        'Status': status,  # (Required)
        'Reason': reason,  # Required if Status is FAILED
        "StackId": event["StackId"],  # (Required)
        'PhysicalResourceId': 'myapp::{}'.format(event['LogicalResourceId']),  # (Required)
        # 'Data': {},
        'RequestId': event['RequestId'],  # (Required)
        "LogicalResourceId": event["LogicalResourceId"]  # (Required)
    }
    print(str(json.dumps(obj=response_for_cf, indent=4)))
    print(indent + keyword_for_log + "ENDED: _build_response_for_cloudformation_stack()\n\n")
    return response_for_cf
# END def _build_response_for_cloudformation_stack


def wait_until_controller_api_server_is_ready(
    ucc_public_ip="123.123.123.123",
    api_version="v1",
    api_route="api/",
    total_wait_time=600,  # second(s)
    interval_wait_time=10,  # second(s)
    keyword_for_log="avx-lambda-function---",
    indent=""
        ):
    api_endpoint_url = "https://" + ucc_public_ip + "/" + api_version + "/" + api_route

    #### Invoke a login API with a username doesn't exist
    #### By using the mechanism above, we can resolve the issue where server status code is 200 but response message is "Valid action required: login", which means backend is NOT ready yet
    payload = {
        "action": "login",
        "username": "test",
        "password": "test"
    }
    remaining_wait_time = total_wait_time

    ''' Variable Description: (time_spent_for_requests_lib_timeout)
    Description: 
        * This value represents how many seconds for "requests" lib to timeout by default. 
    Detail: 
        * The value 20 seconds is actually a rough number which is not  
        * If there is a connection error and causing timeout when 
          invoking--> requests.get(xxx), it takes about 20 seconds for requests.get(xxx) to throw timeout exception.
        * When calculating the remaining wait time, this value is considered.
    '''
    time_spent_for_requests_lib_timeout = 20
    last_err_msg = ""
    while remaining_wait_time > 0:
        try:
            ### Reset the checking flags
            response_status_code = -1
            is_apache_returned_200 = False
            is_api_service_ready = False


            ### Invoke a dummy REST API to Aviatrix controller
            response = requests.post(
                url=api_endpoint_url,
                data=payload,
                verify=False
            )

            ### Check the response
            if response is not None:
                response_status_code = response.status_code
                print(indent + keyword_for_log + "Server status code: " + str(response_status_code))
                pydict = response.json()
                if 200 == response.status_code:
                    is_apache_returned_200 = True

                # Case 01: cloudxd is NOT ready if response returns False (expected) and reason message is "Valid action required: login"
                # Case 02: cloudxd is     ready if response returns False (expected) and reason message is "username and password do not match"
                # Mantis 13363
                actual_response_message = pydict['reason']
                response_msg_indicates_backend_not_ready = "Valid action required"
                if False is pydict['return'] and response_msg_indicates_backend_not_ready in actual_response_message:
                    is_api_service_ready = False
                    print(indent + keyword_for_log + "Server backend is NOT ready yet (Server response message: " + actual_response_message + ")")
                else:
                    is_api_service_ready = True
            # END outer if

            if is_apache_returned_200 and is_api_service_ready:
                print(indent + keyword_for_log + "Server status code: " + str(response_status_code) + " AND API Server backend is ready!")
                return True
        except Exception as e:
            print(indent + keyword_for_log + "Aviatrix Controller " + api_endpoint_url + " is still not available")
            last_err_msg = str(e)
            pass  # Purposely ignore the exception by displaying the error message only since it's retry
        # END try-except

        if 404 == response_status_code:
            err_msg = "Error: Aviatrix Controller returns error code: 404 for " + api_endpoint_url + \
                      " Please check if the API version or API endpoint route is correct."
            raise AviatrixException(
                message=err_msg,
            )
        # END if

        # At this point, server status code is NOT 200, or some other error has occurred. Retrying...

        remaining_wait_time = remaining_wait_time - interval_wait_time - time_spent_for_requests_lib_timeout
        print(indent + keyword_for_log + "Remaining wait time: " + str(remaining_wait_time) + " second(s)")
        if remaining_wait_time > 0:
            # print(indent + keyword_for_log + "Wait for " + str(interval_wait_time) + " second(s) before next retry...")
            time.sleep(interval_wait_time)
    # END while

    # TIME IS UP!! At this point, server is still not available or not reachable
    err_msg = "Aviatrix Controller " + api_endpoint_url + " is still not available after " + \
              str(total_wait_time) + " seconds retry. " + \
              "Server status code is: " + str(response_status_code) + ". " + \
              "The last retry message (if any) is: " + last_err_msg
    raise AviatrixException(
        message=err_msg,
    )
# END wait_until_controller_api_server_is_ready()


def _send_aviatrix_api(
    api_endpoint_url="https://123.123.123.123/v1/api",
    request_method="POST",
    payload=dict(),
    retry_count=5,
    keyword_for_log="avx-lambda-function---",
    indent=""
        ):
    response = None
    responses = list()
    request_type = request_method.upper()
    response_status_code = -1

    for i in range(retry_count):
        try:
            if request_type == "GET":
                response = requests.get(url=api_endpoint_url, params=payload, verify=False)
                response_status_code = response.status_code
            elif request_type == "POST":
                response = requests.post(url=api_endpoint_url, data=payload, verify=False)
                response_status_code = response.status_code
            else:
                lambda_failure_reason = "ERROR: Bad HTTPS request type: " + request_method
                print(keyword_for_log + lambda_failure_reason)
                return lambda_failure_reason
            # END if-else

            responses.append(response)  # For error message/debugging purposes
        except requests.exceptions.ConnectionError as e:
            print(indent + keyword_for_log + "WARNING: Oops, it looks like the server is not responding...")
            responses.append(str(e))  # For error message/debugging purposes
            # hopefully it keeps retrying...

        except Exception as e:
            traceback_msg = traceback.format_exc()
            print(indent + keyword_for_log + "Oops! Aviatrix Lambda caught an exception! The traceback message is: ")
            print(traceback_msg)
            lambda_failure_reason = "Oops! Aviatrix Lambda caught an exception! The traceback message is: \n" + str(traceback_msg)
            print(keyword_for_log + lambda_failure_reason)
            responses.append(str(traceback_msg))  # For error message/debugging purposes
        # END try-except

        finally:
            if 200 == response_status_code:  # Successfully send HTTP request to controller Apache2 server
                    return response
            elif 404 == response_status_code:
                lambda_failure_reason = "ERROR: Oops, 404 Not Found. Please check your URL or route path..."
                print(indent + keyword_for_log + lambda_failure_reason)
            # END IF-ELSE: Checking HTTP response code

            '''
            IF the code flow ends up here, it means the current HTTP request have some issue 
            (exception occurs or HTTP response code is NOT 200)
            '''

            '''
            retry     --> 5
            wait_time -->    1, 2, 4, 8 (no 16 because when i == , there will be NO iteration)
            i         --> 0, 1, 2, 3, 4
            '''
            if i+1 < retry_count:
                print(indent + keyword_for_log + "START: Wait until retry")
                print(indent + keyword_for_log + "    i == " + str(i))
                wait_time_before_retry = pow(2, i)
                print(
                    indent + keyword_for_log + "    Wait for: " + str(wait_time_before_retry) +
                    " second(s) until next retry"
                )
                time.sleep(wait_time_before_retry)
                print(indent + keyword_for_log + "ENDED: Wait until retry  \n\n")
                # continue next iteration
            else:
                lambda_failure_reason = 'ERROR: Failed to invoke Aviatrix API. Max retry exceeded. ' + \
                                        'The following includes all retry responses: ' + \
                                        str(responses)
                raise AviatrixException(
                    message=lambda_failure_reason,
                )
        # END try-except-finally
    # END for

    return response  # IF the code flow ends up here, the response might have some issues
# END def _send_aviatrix_api()


def login(
    api_endpoint_url="https://123.123.123.123/v1/api",
    username="admin",
    password="**********",
    hide_password=True,
    keyword_for_log="avx-lambda-function---",
    indent="    "
        ):
    request_method = "POST"
    data = {
        "action": "login",
        "username": username,
        "password": password
    }
    print(indent + keyword_for_log + "API End Point URL   : " + str(api_endpoint_url))
    print(indent + keyword_for_log + "Request Method Type : " + str(request_method))

    if hide_password:
        payload_with_hidden_password = dict(data)
        payload_with_hidden_password["password"] = "************"
        print(
        indent + keyword_for_log + "Request payload     : \n" +
        str(json.dumps(obj=payload_with_hidden_password, indent=4))
        )
    else:
        print(
        indent + keyword_for_log + "Request payload     : \n" +
        str(json.dumps(obj=data, indent=4))
    )




    response = _send_aviatrix_api(
        api_endpoint_url=api_endpoint_url,
        request_method=request_method,
        payload=data,
        keyword_for_log=keyword_for_log,
        indent=indent + "    "
    )
    return response
# END def set_admin_email()


def verify_aviatrix_api_response_login(response=None, keyword_for_log="avx-lambda-function---", indent="    "):
    py_dict = response.json()
    print(indent + keyword_for_log + "Aviatrix API response --> " + str(py_dict))

    ### Verify if HTTP response code is 200
    response_code = response.status_code  # expect to be 200
    if response_code is not 200:
        err_msg = "Fail to login Aviatrix controller. " \
                  "Expected HTTP response code is 200, but the actual " \
                  "response code is: " + str(response_code)
        raise AviatrixException(
            message=err_msg,
        )
    # END if

    ### Verify if API response returns True
    api_return_boolean = py_dict["return"]
    if api_return_boolean is not True:
        err_msg = "Fail to login Aviatrix controller. API response is: " + str(py_dict)
        raise AviatrixException(
            message=err_msg,
        )
    # END if

    # At this point, py_dict["return"] is True

    ### Verify if able to find expected string from API response
    api_return_msg = py_dict["results"]
    expected_string = "authorized successfully"
    if (expected_string in api_return_msg) is False:
        err_msg = "Fail to login Aviatrix controller. API actual return message is: " + \
                  str(py_dict) + \
                  " The string we expect to find is: " + \
                  expected_string

        raise AviatrixException(
            message=err_msg,
        )
    # END if
# END def verify_aviatrix_api_response_login()


def has_controller_initialized(
    api_endpoint_url="https://123.123.123.123/v1/api",
    CID="ABCD1234",
    keyword_for_log="avx-lambda-function---",
    indent="    "
        ):

    request_method = "GET"
    data = {
        "action": "initial_setup",
        "subaction": "check",
        "CID": CID
    }
    print(indent + keyword_for_log + "API End Point URL   : " + str(api_endpoint_url))
    print(indent + keyword_for_log + "Request Method Type : " + str(request_method))
    print(indent + keyword_for_log + "Request payload     : \n" + str(json.dumps(obj=data, indent=4)))

    response = _send_aviatrix_api(
        api_endpoint_url=api_endpoint_url,
        request_method=request_method,
        payload=data,
        keyword_for_log=keyword_for_log,
        indent=indent + "    "
    )

    py_dict = response.json()
    print(indent + keyword_for_log + "Aviatrix API response --> " + str(py_dict))

    if py_dict["return"] is False and "not run" in py_dict["reason"]:
        return False  # Controller has NOT been initialized
    # END if

    return True  # Controller has ALREADY been initialized
# END def has_controller_initialized()


def is_controller_type_byol(
    api_endpoint_url="https://123.123.123.123/v1/api",
    CID="ABCD1234",
    keyword_for_log="avx-lambda-function---",
    indent="    "
        ):
    request_method = "GET"
    payload = {
        "action": "get_controller_license_type",
        "CID": CID
    }
    response = _send_aviatrix_api(
        api_endpoint_url=api_endpoint_url,
        request_method=request_method,
        payload=payload,
        keyword_for_log=keyword_for_log,
        indent=indent + "    "
    )
    py_dict = response.json()
    print(indent + keyword_for_log + "Aviatrix API response --> " + str(py_dict))
    if py_dict["return"] == True:
        controller_type = str(py_dict["results"]["license_type"]).upper()
        if controller_type == "BYOL":
            return True
    # END outer if
# END def is_controller_type_byol()


def get_controller_version(
    api_endpoint_url="https://123.123.123.123/v1/api",
    CID="ABCD1234",
    keyword_for_log="avx-lambda-function---",
    indent="    "
        ):
    """    "list_version_info" API is supported by all controller versions since 2.7  """
    request_method = "GET"
    params = {
        "action": "list_version_info",
        "CID": CID
    }
    print(indent + keyword_for_log + "API End Point URL   : " + str(api_endpoint_url))
    print(indent + keyword_for_log + "Request Method Type : " + str(request_method))
    print(indent + keyword_for_log + "Request payload     : \n" + str(json.dumps(obj=params, indent=4)))

    response = _send_aviatrix_api(
        api_endpoint_url=api_endpoint_url,
        request_method=request_method,
        payload=params,
        keyword_for_log=keyword_for_log,
        indent=indent + "    "
    )

    ##### Get controller info
    py_dict = response.json()
    # Commented out on purpose to avoid confusion since 2.6 doesn't support "list_version_info"
    # print(keyword_for_log + "Aviatrix API response --> " + str(py_dict))
    ### IF controller doesn't find the API "list_version_info", it means controller version is 2.6 or older
    if py_dict["return"] is False and py_dict["reason"] == "valid action required":
        # print(indent + keyword_for_log + 'Controller version does not support the API, "list_version_info". '
        #                         'Controller version is 2.6 or earlier release.')
        return "2.6"

    ### IF "list_version_info" API call succeeded, then start parsing and trimming the strings to get the version ONLY
    elif py_dict["return"] is True:
        controller_version = _parse_list_version_info_API_to_get_controller_version(
            response=response,
            with_subversion=False,
            keyword_for_log="avx-lambda-function---",
            indent="    "
        )
        return controller_version
    # END if-else

    avx_err_msg = 'Error: Not able to get controller version.'
    raise AviatrixException(
        message=avx_err_msg,
    )
# END def get_controller_version()


def _parse_list_version_info_API_to_get_controller_version(
    response=None,
    with_subversion=False,
    keyword_for_log="avx-lambda-function---",
    indent="    "
        ):
    """
    This function will extract the version in the digit part, like ...
    from
    "UserConnect-3.4.105"
    to
    "3.4.105"

    This API is supported in 2.7 or later release
    """
    pydict = response.json()
    current_version_string = ""
    if pydict["return"] is True:
        current_version_string = pydict["results"]["current_version"]
    else:
        print(indent + keyword_for_log + "Fail to get Aviatrix controller version")
        return None  # Fail to get Aviatrix controller version

    # Trim the version string
    if "UserConnect-" in current_version_string:
        current_version_string = current_version_string[12:]  # Get rid of the string "UserConnect-"

    if with_subversion:
        return current_version_string
    else:
        pattern = "\d.\w+"
        re_match_obj = re.search(pattern=pattern, string=current_version_string)
        current_version_string = re_match_obj.group(0)
        return current_version_string

# END _parse_list_version_info_API_to_get_controller_version


def set_admin_email(
    api_endpoint_url="https://123.123.123.123/v1/api",
    CID="ABCD1234",
    admin_email="test@aviatrix.com",
    keyword_for_log="avx-lambda-function---",
    indent="    "
        ):
    """    "add_admin_email_addr" API is supported by all controller versions since 2.6    """

    request_method = "POST"
    data = {
        "action": "add_admin_email_addr",
        "CID": CID,
        "admin_email": admin_email
    }
    print(indent + keyword_for_log + "API End Point URL   : " + str(api_endpoint_url))
    print(indent + keyword_for_log + "Request Method Type : " + str(request_method))
    print(indent + keyword_for_log + "Request payload     : \n" + str(json.dumps(obj=data, indent=4)))

    response = _send_aviatrix_api(
        api_endpoint_url=api_endpoint_url,
        request_method=request_method,
        payload=data,
        keyword_for_log=keyword_for_log,
        indent=indent + "    "
    )
    return response
# END def set_admin_email()


def verify_aviatrix_api_set_admin_email(response=None, keyword_for_log="avx-lambda-function---", indent="    "):
    py_dict = response.json()
    print(indent + keyword_for_log + "Aviatrix API response --> " + str(py_dict))

    ### Verify if HTTP response code is 200
    response_code = response.status_code  # expect to be 200
    if response_code is not 200:
        err_msg = "Fail to set admin email for Aviatrix controller. " \
                  "Expected HTTP response code is 200, but the actual " \
                  "response code is: " + str(response_code)
        raise AviatrixException(
            message=err_msg,
        )
    # END if

    ### Verify if API response returns True
    api_return_boolean = py_dict["return"]
    if api_return_boolean is not True:
        err_msg = "Fail to set admin email for Aviatrix controller. API response is: " + str(py_dict)
        raise AviatrixException(
            message=err_msg,
        )
    # END if

    # At this point, py_dict["return"] is True

    ### Verify if able to find expected string from API response
    api_return_msg = py_dict["results"]
    expected_string = "admin email address has been successfully added"
    if (expected_string in api_return_msg) is False:
        avx_err_msg = "Fail to set admin email for Aviatrix controller. API actual return message is: " + \
                      str(py_dict) + \
                      " The string we expect to find is: " + \
                      expected_string

        raise AviatrixException(
            message=avx_err_msg,
        )
    # END if
# END def verify_aviatrix_api_set_admin_email()


def set_admin_password(
    api_endpoint_url="https://123.123.123.123/v1/api",
    # controller_version="4.0",  # MMM
    CID="ABCD1234",
    old_admin_password="**********",
    new_admin_password="**********",
    keyword_for_log="avx-lambda-function---",
    indent="    "
        ):
    """
        Dev Notes:
            * One of the reasons for this API to fail and seeing the following message:
                {'return': False, 'reason': 'valid action required'}
                is because the base AMI of the controller has been updated.
                The API name has been changed from "change_password" to the following  -->
                {
                "action": "edit_account_user",
                "CID": CID,
                "username": "admin",
                "what": "password",
                "old_password": old_admin_password,
                "new_password": new_admin_password
                }

            * The action name of this API has use "edit_account_user" if controller's base AMI has been changed.
              The current API, "change_password" is for classic base AMI
        """

    request_method = "POST"

    """ MMM
    # controller_version = eval(controller_version)  

    
    # The account_name and username fields are hard-coded as "admin" because this function ONLY sets/changes the
    # password for "admin"
    if controller_version <= 2.6:
        data = {
            "action": "change_password",
            "CID": CID,
            "account_name": "admin",
            "user_name": "admin",
            "old_password": old_admin_password,
            "password": new_admin_password
        }
    else:  # The API, "edit_account_user" is supported in 2.7 or later release
        data = {
            "action": "edit_account_user",
            "CID": CID,
            "username": "admin",
            "what": "password",
            "old_password": old_admin_password,
            "new_password": new_admin_password
        }
    # END determine API depends on controller version
    """

    data_1st_try = {
        "action": "edit_account_user",
        "CID": CID,
        "username": "admin",
        "what": "password",
        "old_password": old_admin_password,
        "new_password": new_admin_password
    }

    payload_with_hidden_password = dict(data_1st_try)
    payload_with_hidden_password["new_password"] = "************"
    # placeholder: After AMI has updated, this line needs to change to --> payload_with_hidden_password["new_password"]
    # payload_with_hidden_password["password"] = "************"
    print(indent + keyword_for_log + "API End Point URL   : " + str(api_endpoint_url))
    print(indent + keyword_for_log + "Request Method Type : " + str(request_method))
    print(
        indent + keyword_for_log + "Request payload     : \n" +
        str(json.dumps(obj=payload_with_hidden_password, indent=4))
    )

    response = _send_aviatrix_api(
        api_endpoint_url=api_endpoint_url,
        request_method=request_method,
        payload=data_1st_try,
        keyword_for_log=keyword_for_log,
        indent=indent + "    "
    )

    ### Check if API (edit_account) response tells the API is not a Valid action, which means this API doesn't exist
    if response and response.json()["return"] == False and "Valid action required" in response.json()["reason"]:
        is_successfully_changed_password = False
    else:
        # At this point, it has successfully changed the password
        return response
    # END if-else

    # At this point, script has failed to use ""

    data_2nd_try = {
        "action": "change_password",
        "CID": CID,
        "account_name": "admin",
        "user_name": "admin",
        "old_password": old_admin_password,
        "password": new_admin_password
    }

    payload_with_hidden_password = dict(data_2nd_try)
    # payload_with_hidden_password["old_password"] = "************"  # it's okay to see the old password which is the private ip of the controller
    # placeholder: After AMI has updated, this line needs to change to --> payload_with_hidden_password["new_password"]
    payload_with_hidden_password["password"] = "************"
    print(indent + keyword_for_log + "API End Point URL   : " + str(api_endpoint_url))
    print(indent + keyword_for_log + "Request Method Type : " + str(request_method))
    print(
        indent + keyword_for_log + "Request payload     : \n" +
        str(json.dumps(obj=payload_with_hidden_password, indent=4))
    )

    response = _send_aviatrix_api(
        api_endpoint_url=api_endpoint_url,
        request_method=request_method,
        payload=data_2nd_try,
        keyword_for_log=keyword_for_log,
        indent=indent + "    "
    )

    return response
# END def set_admin_password()


def verify_aviatrix_api_set_admin_password(response=None, keyword_for_log="avx-lambda-function---", indent="    "):
    py_dict = response.json()
    print(indent + keyword_for_log + "Aviatrix API response --> " + str(py_dict))

    ### Verify if HTTP response code is 200
    response_code = response.status_code  # expect to be 200
    if response_code is not 200:
        avx_err_msg = "Fail to set admin password on Aviatrix controller. " \
                      "Expected HTTP response code is 200, but the actual " \
                      "response code is: " + str(response_code)
        raise AviatrixException(
            message=avx_err_msg,
        )
    # END if

    ### Verify if API response returns True
    api_return_boolean = py_dict["return"]
    if api_return_boolean is not True:
        avx_err_msg = "Fail to set admin password on Aviatrix controller. API response is: " + str(py_dict)
        raise AviatrixException(
            message=avx_err_msg,
        )
    # END if

    # At this point, py_dict["return"] is True

    ''' COMMENT START: not verifying because there are 2 versions of this API
    ### Verify if able to find expected string from API response
    api_return_msg = py_dict["results"]
    expected_string = "password has been changed successfully"
    if (expected_string in api_return_msg) is False:
        err_msg = "Fail to set admin password on Aviatrix controller. API actual return message is: " + \
                  str(py_dict) + \
                  " The string we expect to find is: " + \
                  expected_string

        raise AviatrixException(
            message=err_msg,
        )
    # END if
    COMMENT ENDED: not verifying because there are 2 versions of this API'''
# END def verify_aviatrix_api_set_admin_password()


def run_initial_setup(
    api_endpoint_url="https://123.123.123.123/v1/api",
    CID="ABCD1234",
    target_version="latest",
    keyword_for_log="avx-lambda-function---",
    indent="    "
        ):
    """    "initial_setup" API is supported by all controller versions since 2.6    """
    request_method = "POST"

    ### Step 01: Check if init setup has been done before
    data = {
        "action": "initial_setup",
        "CID": CID,
        "subaction": "check"
    }
    print("Checking initial setup")
    response = _send_aviatrix_api(
        api_endpoint_url=api_endpoint_url,
        request_method=request_method,
        payload=data,
        keyword_for_log=keyword_for_log,
        indent=indent + "    "
    )
    py_dict = response.json()
    if py_dict['return'] is True:
        print(indent + keyword_for_log + "Initial setup is already done. Skipping...")
        return response

    try:
        ### Step 02: Start invoking init setup API
        data = {
            "action": "initial_setup",
            "CID": CID,
            "target_version": target_version,
            "subaction": "run"
        }
        print(indent + keyword_for_log + "API End Point URL   : " + str(api_endpoint_url))
        print(indent + keyword_for_log + "Request Method Type : " + str(request_method))
        print(indent + keyword_for_log + "Request payload     : \n" + str(json.dumps(obj=data, indent=4)))

        response = requests.post(url=api_endpoint_url, data=data, verify=False, timeout=600)
        return response
    except (requests.exceptions.ConnectionError, requests.exceptions.Timeout) as err:
        if "Remote end closed connection without response" in str(err):
            print("Server closed the connection while executing initial setup API."
                  " Ignoring response")
            time.sleep(15)
            response = requests.models.Response()
            response.status_code = 200
            response_content = json.dumps({'return': True, 'reason': 'Warning!! Server closed the connection'})
            response._content = str.encode(response_content)
            return response
        else:
            raise AviatrixException(message="Failed to execute initial setup: " + str(err))
# END def run_initial_setup()


def verify_aviatrix_api_run_initial_setup(response=None, keyword_for_log="avx-lambda-function---", indent="    "):
    py_dict = response.json()
    print(indent + keyword_for_log + "Aviatrix API response --> " + str(py_dict))

    ### Verify if HTTP response code is 200
    response_code = response.status_code  # expect to be 200
    if response_code is not 200:
        avx_err_msg = "Fail to run-initial-setup on Aviatrix controller. " \
                      "Expected HTTP response code is 200, but the actual " \
                      "response code is: " + str(response_code)
        raise AviatrixException(
            message=avx_err_msg,
        )
    # END if

    ### Verify if API response returns True
    api_return_boolean = py_dict["return"]
    if api_return_boolean is not True:
        avx_err_msg = "Fail to run-initial-setup on Aviatrix controller. API response is: " + str(py_dict)
        raise AviatrixException(
            message=avx_err_msg,
        )
    # END if

    # At this point, py_dict["return"] is True

    ### Verify if able to find expected string from API response
    # api_return_msg = str(py_dict["results"])
    # expected_string = "180"
    # if (expected_string in api_return_msg) is False:
    #     err_msg = "Fail to run-initial-setup on Aviatrix controller. API actual return message is: " + \
    #               str(py_dict) + \
    #               " The string we expect to find is: " + \
    #               expected_string
    #
    #     raise AviatrixException(
    #         message=err_msg,
    #     )
    # # END if
    pass  # The code section above has been commented out since the API response could be from check_init_setup_status

# END def verify_aviatrix_api_run_initial_setup()


def set_aviatrix_customer_id(
    api_endpoint_url="https://123.123.123.123/v1/api",
    CID="ABCD1234",
    customer_id="aviatrix-customer-id-abcdefghijk123456789",
    keyword_for_log="avx-lambda-function---",
    indent="    "
        ):
    """    "setup_customer_id" API is supported by all controller versions since 2.6    """

    request_method = "POST"
    data = {
        "action": "setup_customer_id",
        "CID": CID,
        "customer_id": customer_id
    }
    print(indent + keyword_for_log + "API End Point URL   : " + str(api_endpoint_url))
    print(indent + keyword_for_log + "Request Method Type : " + str(request_method))
    print(indent + keyword_for_log + "Request payload     : \n" + str(json.dumps(obj=data, indent=4)))

    response = _send_aviatrix_api(
        api_endpoint_url=api_endpoint_url,
        request_method=request_method,
        payload=data,
        keyword_for_log=keyword_for_log,
        indent=indent + "    "
    )
    return response
# END def set_aviatrix_customer_id()


def verify_aviatrix_api_set_aviatrix_customer_id(response=None, keyword_for_log="avx-lambda-function---", indent="    "):
    py_dict = response.json()
    print(indent + keyword_for_log + "Aviatrix API response --> " + str(py_dict))

    ### Verify if HTTP response code is 200
    response_code = response.status_code  # expect to be 200
    if response_code is not 200:
        avx_err_msg = "Fail to set aviatrix customer id on Aviatrix controller. " \
                      "Expected HTTP response code is 200, but the actual " \
                      "response code is: " + str(response_code)
        raise AviatrixException(
            message=avx_err_msg,
        )
    # END if

    ### Verify if API response returns True
    api_return_boolean = py_dict["return"]
    if api_return_boolean is not True:
        avx_err_msg = "Fail to set aviatrix customer id on Aviatrix controller. API response is: " + str(py_dict)
        raise AviatrixException(
            message=avx_err_msg,
        )
    # END if

    # At this point, py_dict["return"] is True

    ### Verify if able to find expected string from API response
    api_return_msg = py_dict["results"]
    expected_string = "CustomerID"
    if (expected_string in api_return_msg) is False:
        avx_err_msg = "Fail to set aviatrix customer id on Aviatrix controller. API actual return message is: " + \
                      str(py_dict) + \
                      " The string we expect to find is: " + \
                      expected_string

        raise AviatrixException(
            message=avx_err_msg,
        )
    # END if
# END def verify_aviatrix_api_set_aviatrix_customer_id()


def create_access_account(
    api_endpoint_url="https://123.123.123.123/v1/api",
    CID="ABCD1234",
    controller_version="4.0",
    account_name="my-aws-role-based",
    account_password="**********",
    account_email="test@aviatrix.com",
    cloud_type="1",
    aws_account_number="123456789012",
    is_iam_role_based="true",
    app_role_arn="arn:aws:iam::123456789012:role/aviatrix-role-app",
    ec2_role_arn="arn:aws:iam::123456789012:role/aviatrix-role-ec2",
    keyword_for_log="avx-lambda-function---",
    indent="    "
        ):
    controller_version = eval(controller_version)
    request_method = "POST"

    if controller_version <= 2.6:
        data = {
            "action": "xxxxx",
            "CID": CID,
            "account_name": account_name,
            "account_password": account_password,
            "account_email": account_email,
            "cloud_type": cloud_type,
            "aws_account_number": aws_account_number,
            "aws_iam": is_iam_role_based,
            "aws_role_arn": app_role_arn,
            "aws_role_ec2": ec2_role_arn
        }
    else:  # The API, "edit_account_user" is supported in 2.7 or later release
        data = {
            "action": "setup_account_profile",
            "CID": CID,
            "account_name": account_name,
            "account_password": account_password,
            "account_email": account_email,
            "cloud_type": cloud_type,
            "aws_account_number": aws_account_number,
            "aws_iam": is_iam_role_based,
            "aws_role_arn": app_role_arn,
            "aws_role_ec2": ec2_role_arn
        }
    # END determine API depends on controller version

    payload_with_hidden_password = dict(data)
    payload_with_hidden_password["account_password"] = "************"

    print(indent + keyword_for_log + "API End Point URL   : " + str(api_endpoint_url))
    print(indent + keyword_for_log + "Request Method Type : " + str(request_method))
    print(
        indent + keyword_for_log + "Request payload     : \n" +
        str(json.dumps(obj=payload_with_hidden_password, indent=4))
    )

    response = _send_aviatrix_api(
        api_endpoint_url=api_endpoint_url,
        request_method=request_method,
        payload=data,
        keyword_for_log=keyword_for_log,
        indent=indent + "    "
    )
    return response
# END def create_access_account()


def verify_aviatrix_api_create_access_account(
    response=None,
    admin_email="test@aviatrix.com",
    keyword_for_log="avx-lambda-function---",
    indent="    "
        ):
    py_dict = response.json()
    print(indent + keyword_for_log + "Aviatrix API response --> " + str(py_dict))

    ### Verify if HTTP response code is 200
    response_code = response.status_code  # expect to be 200
    if response_code is not 200:
        avx_err_msg = "Fail to create access account on  Aviatrix controller. " \
                      "Expected HTTP response code is 200, but the actual " \
                      "response code is: " + str(response_code)
        raise AviatrixException(
            message=avx_err_msg,
        )
    # END if

    ### Verify if API response returns True
    api_return_boolean = py_dict["return"]
    if api_return_boolean is not True:
        avx_err_msg = "Fail to create access account on  Aviatrix controller. API response is: " + str(py_dict)
        raise AviatrixException(
            message=avx_err_msg,
        )
    # END if

    # At this point, py_dict["return"] is True

    ### Verify if able to find expected string from API response
    api_return_msg = py_dict["results"]
    expected_string = "An email confirmation has been sent to {EMAIL_ADDRESS}"
    expected_string = expected_string.format(EMAIL_ADDRESS=admin_email)
    if (expected_string in api_return_msg) is False:
        avx_err_msg = "Fail to create access account on  Aviatrix controller. API actual return message is: " + \
                      str(py_dict) + \
                      " The string we expect to find is: " + \
                      expected_string

        raise AviatrixException(
            message=avx_err_msg,
        )
    # END if
# END def verify_aviatrix_api_create_access_account()
