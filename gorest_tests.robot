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
