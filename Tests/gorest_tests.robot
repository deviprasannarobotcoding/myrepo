*** Settings ***
Library    RequestsLibrary  
Library    JSONLibrary
Library    Collections 
Library    OperatingSystem

*** Variables ***  
${base_url}   https://gorest.co.in/ 

*** Keywords ***

*** Test Cases ***
TC001_GET_Call_Basic_Test:
    Create Session    gorest    ${base_url}    verify=True
    ${response}=  GET On Session    gorest    ${base_url} 
    Should Be Equal As Strings    ${response.status_code}    200    

TC002_GET_users_from_first_page:
    ${response}=  GET On Session    gorest    /public/v1/users     params=page=1
    Should Be Equal As Strings    ${response.status_code}    200    

TC003_Verify_response_has_pagination:
    ${response}=  GET On Session    gorest    /public/v1/users     params=page=1
    ${actual_body}=    Convert To String    ${response.content}
    Should Contain    ${actual_body}    pagination     
    
TC004_Verify_response_has_Valid_Json_data:
    ${response}=  GET On Session    gorest    /public/v1/users     params=page=1
    ${dict}  Set Variable    ${response.json()}
    Log To Console    ${dict}

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
    Log To Console    ${list_attributes}
    
    FOR    ${item}    IN     ${list_data}
        FOR    ${i}    IN RANGE    0    20
            #Log To Console    \n${item[0][${i}]}
            ${data_item}=    Get Dictionary Keys    ${item[0][${i}]}
            Lists Should Be Equal    ${list_attributes}    ${data_item}
            Log To Console    \n From the list data,item ${i} has similar attributes   
        END              
    END
        