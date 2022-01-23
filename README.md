Introduction
============
This repo contains robot test suite which covers the tests of below API
https://gorest.co.in/public/v1/users

Repo Structure
==============
This is the directory structure of the repo. 

myrepo-main
|--Tests
	|--gorest_tests.robot
|--Results
	|-log.html
	|-log1.html
	|-log2.html
	|-log3.html
|--README.md

Tests
This directory contains the tests created for API calls

Results
This directory contains the html log files uploaded for each commit

Tests Description
==================
TC001_GET_Call_Basic_Test
This test case is to create a session to base url and verify its response status
 
TC002_GET_Call_to_users_first_page
This test case is to verify GET call with params 

TC003_Verify_response_has_pagination
This test case is to verify the above GET call has pagination in its response

TC004_Verify_response_has_Valid_Json_data
This test case is to verify the above GET call has valid Json as response

TC005_Verify_response_has_email
This test case is to verify the GET call to base url has email in its response

TC006_Verify_all_entries_on_list_data_have_similar_attributes
This test case is to verify the GET call to base url has list of items and each item has similar attributes

TC007_Create_new_user
This test case is to verify POST call to users endpoint

TC008_Create_same_user
This test case is to verify creating same user in users endpoint

TC009_Verify_Create_user_without_authentication
This test case is to check creating user with no proper authentication

TC010_Verify_Create_user_for_Internal_Server_Error
This test case is to verify erro code 500

TC011_Verify_GET_user_that_doesn't_exist
This test case is to verify GET call for user that doesn't exists

TC012_Verify_POST_with_non-ssl_call
This test case is to verify creating an Insure session to base url 


NOTE:
=====
1. Bearer Token is hardcoded because the token is generated from below URL with user's social account. There is no generic credentials available to utilize the same for generating this token. 
https://gorest.co.in/consumer/login