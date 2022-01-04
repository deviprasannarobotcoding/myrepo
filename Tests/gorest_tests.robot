*** Settings ***
Library    RequestsLibrary  
Library    JSONLibrary
Library    Collections 
Library    OperatingSystem

*** Variables ***  
${base_url}   https://gorest.co.in/ 
${Token}=    Bearer d477ac3f30a63763716361f3cabdda268d80cf2ba7c1afcc75f21d6be935a13e

*** Keywords ***

*** Test Cases ***
TC001_GET_Call_Basic_Test:
    Create Session    gorest    ${base_url}    verify=True
    ${response}=  GET On Session    gorest    ${base_url}    expected_status=200 
    Log To Console    ${response.status_code}        

TC002_GET_Call_to_users_first_page:
    ${response}=  GET On Session    gorest    /public/v1/users     params=page=1
    Should Be Equal As Strings    ${response.status_code}    200
    Log To Console    ${response.status_code}    

TC003_Verify_response_has_pagination:
    ${response}=  GET On Session    gorest    /public/v1/users     params=page=1
    ${actual_body}=    Convert To String    ${response.content}
    Should Contain    ${actual_body}    pagination
    Log To Console    Response has "pagination"     
    
TC004_Verify_response_has_Valid_Json_data:
    ${response}=  GET On Session    gorest    /public/v1/users     params=page=1
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
    #Log To Console    ${list_attributes}
    
    FOR    ${item}    IN     ${list_data}
        FOR    ${i}    IN RANGE    0    20
            #Log To Console    \n${item[0][${i}]}
            ${data_item}=    Get Dictionary Keys    ${item[0][${i}]}
            Lists Should Be Equal    ${list_attributes}    ${data_item}
            Log To Console    \n From the list data,item ${i} has similar attributes   
        END              
    END

TC007_Create_new_user:
    ${header}    Create Dictionary    Content-Type=application/json    Authorization=${Token}
    ${data}=      Create Dictionary    id=195   name=Vijay Palyam195    email=vijay_palyam195@wolf-wisoky.com    gender=male    status=active       
    ${response}=    POST On Session    gorest    /public/v1/users    headers=${header}    json=${data}      
    Should Be Equal As Strings    ${response.status_code}    201
    Log To Console    ${response.status_code}
    ${actual_body}=    Convert To String    ${response.content}
    Log To Console    ${actual_body}
    
TC008_Create_same_user:
    ${header}    Create Dictionary    Content-Type=application/json    Authorization=${Token}
    ${data}=      Create Dictionary    id=195   name=Vijay Palyam195    email=vijay_palyam195@wolf-wisoky.com    gender=male    status=active       
    ${response}=    POST On Session    gorest    /public/v1/users    headers=${header}    json=${data}    expected_status=422
    Log To Console    ${response.status_code}  
    ${actual_body}=    Convert To String    ${response.content}
    Log To Console    ${actual_body}    message

TC009_Verify_Create_user_without_authentication:
    ${data}=      Create Dictionary    "id"= "121"     "name"= "Vijay Palyam"    "email"= "vijay_palyam12@wolf-wisoky.com"    "gender"= "male"    "status"= "active"       
    ${response}=    POST On Session    gorest    /public/v1/users      json=${data}    expected_status=401  
    Log To Console    ${response.status_code}  
    ${actual_body}=    Convert To String    ${response.content}
    Log To Console    ${actual_body}    message

TC010_Verify_Create_user_for_Internal_Server_Error:
    ${header}    Create Dictionary    Content-Type=x-www-form-urlencoded    Authorization=${Token}
    ${data}=      Create Dictionary    name=[188]    email=[188@task.com]    gender=female    status=active       
    ${response}=    POST On Session    gorest    /public/v1/users    headers=${header}    json=${data}    expected_status=500          
    Log To Console    ${response.status_code}
    ${actual_body}=    Convert To String    ${response.content}
    Log To Console    ${actual_body}    message

TC011_Verify_GET_user_that_doesn't_exist:
    ${response}=  GET On Session    gorest    /public/v1/user     params=name=Tenali    expected_status=404
    Log To Console    ${response.status_code}

 TC012_Verify_POST_with_non-ssl_call:
    Create Session    no_ssl    http://gorest.co.in/
    ${data}=      Create Dictionary    id=196   name=Vijay Palyam196    email=vijay_palyam196@wolf-wisoky.com    gender=male    status=active       
    ${response}=    POST On Session    no_ssl    /public/v1/users    json=${data}    expected_status=anything      
    Log To Console    ${response.status_code}

    
