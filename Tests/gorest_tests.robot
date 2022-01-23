*** Settings ***
Library    RequestsLibrary  
Library    JSONLibrary
Library    Collections 
Library    OperatingSystem
Suite Setup    Open Connection and create session
Suite Teardown    Close All Connections 
Resource    resource.robot

*** Variables ***
${base_url}   https://gorest.co.in/ 

*** Test Cases ***
TC001_GET_Call_Basic_Test:
    open connection and create session

TC002_GET_Call_to_users_first_page:
    GET call    gorest    /public/v1/users     page=1    200   

TC003_Verify_response_has_pagination:
    ${response_body}    GET call    gorest    /public/v1/users     page=1    200
    Should Contain    ${response_body}    pagination
    Log To Console    Response has "pagination"     
    
TC004_Verify_response_has_Valid_Json_data:
    ${response}  GET On Session    gorest    /public/v1/users     params=page=1
    ${dict}  Set Variable    ${response.json()}
    ${dict_keys}=    Get Dictionary Keys    ${dict}
    Log To Console    ${dict_keys}
    Log To Console    "Response has valid Json data which is in key-value pair format"

TC005_Verify_response_has_email:
    ${response}=  GET On Session    gorest    /public/v1/users
    ${actual_body}=    Convert To String    ${response.content}
    Should Contain    ${actual_body}    email
    Log To Console    "Response has email content"

TC006_Verify_all_entries_on_list_data_have_similar_attributes:
    ${response}=  GET On Session    gorest    /public/v1/users     
    ${dict}  Set Variable    ${response.json()}
    Dictionary Should Contain Key    ${dict}    data
    ${list_data}=    Get Value From Json    ${dict}    data
    ${list_attributes}=    Create List    email    gender    id    name    status
    
    FOR    ${item}    IN     ${list_data}
        FOR    ${i}    IN RANGE    0    20
            ${data_item}=    Get Dictionary Keys    ${item[0][${i}]}
            Lists Should Be Equal    ${list_attributes}    ${data_item}
            Log To Console    \n From the list data,item ${i} has similar attributes   
        END              
    END   

TC007_Create_new_user:
    POST call    gorest    /public/v1/users    ${header}    ${new_user}    201

TC008_Create_same_user:
    POST call    gorest    /public/v1/users    ${header}    ${new_user}    422

TC009_Verify_Create_user_without_authentication:
    POST call    gorest    /public/v1/users    ${invalid_header1}    ${new_user}    401

TC010_Verify_Create_user_for_Internal_Server_Error:
    POST call    gorest    /public/v1/users    ${invalid_header2}    ${new_user}    500

TC011_Verify_GET_user_that_doesn't_exist:
    GET call    gorest    /public/v1/user    name=Tenali    404

 TC012_Verify_POST_with_non-ssl_call:
    Create Session    no_ssl    http://gorest.co.in/
    ${response}=    POST On Session    no_ssl    /public/v1/users    json=${new_user}    expected_status=anything      
    Log To Console    ${response.status_code}   