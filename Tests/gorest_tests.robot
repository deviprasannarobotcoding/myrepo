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
    ${response}=  GET On Session    gorest    ${base_url} 
    Should Be Equal As Strings    ${response.status_code}    200    

TC002_GET_Call_to_users_first_page:
    ${response}=  GET On Session    gorest    /public/v1/users     params=page=1
    Should Be Equal As Strings    ${response.status_code}    200

TC003_Verify_response_has_pagination:
    ${response}=  GET On Session    gorest    /public/v1/users     params=page=1
    ${actual_body}=    Convert To String    ${response.content}
    Should Contain    ${actual_body}    pagination     
    
TC004_Verify_response_has_Valid_Json_data:
    ${response}=  GET On Session    gorest    /public/v1/users     params=page=1
    ${dict}  Set Variable    ${response.json()}
    #Log To Console    ${dict}
    ${dict_keys}=    Get Dictionary Keys    ${dict}
    Log To Console    ${dict_keys}

TC005_Verify_response_has_email:
    ${response}=  GET On Session    gorest    /public/v1/users
    ${actual_body}=    Convert To String    ${response.content}
    Should Contain    ${actual_body}    email

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
    ${data}=      Create Dictionary    id=161   name=Vijay Palyam161    email=vijay_palyam161@wolf-wisoky.com    gender=male    status=active       
    ${response}=    POST On Session    gorest    /public/v1/users    headers=${header}    json=${data}      
    Should Be Equal As Strings    ${response.status_code}    201
    ${actual_body}=    Convert To String    ${response.content}
    Log To Console    ${actual_body}
    
TC008_Create_same_user:
    ${header}    Create Dictionary    Content-Type=application/json    Authorization=${Token}
    ${data}=      Create Dictionary    id=151   name=Vijay Palyam151    email=vijay_palyam151@wolf-wisoky.com    gender=male    status=active       
    ${response}=    POST On Session    gorest    /public/v1/users    headers=${header}    json=${data}    expected_status=anything      


#TC008_Verify_Create_user_without_authentication:
#     ${data}=      Create Dictionary    "id"= "121"     "name"= "Vijay Palyam"    "email"= "vijay_palyam12@wolf-wisoky.com"    "gender"= "male"    "status"= "active"       
#     ${response}=    POST On Session    gorest    /public/v1/users      data=${data}  
#     #Should Be Equal As Strings    ${response.status_code}    401
#     ${actual_body}=    Convert To String    ${response.content}
#     Log To Console    ${response.status_code}