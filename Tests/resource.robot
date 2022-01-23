*** Settings ***
Library   RequestsLibrary 

*** Variables ***
${Token}=    Bearer d477ac3f30a63763716361f3cabdda268d80cf2ba7c1afcc75f21d6be935a13e
&{header}  Content-Type=application/json     Authorization=${Token}
&{new_user}    name=Vijay Palyam010    email=vijay_palyam010@wolf-wisoky.com    gender=male    status=active
&{invalid_header1}    Content-Type=application/json
&{invalid_header2}    Content-Type=x-www-form-urlencoded    Authorization=${Token}
&{null_header}    null=null

*** Keywords ***
open connection and create session
    Create Session    gorest    ${base_url}    verify=True
    ${response}=  GET On Session    gorest    ${base_url}    expected_status=200 
    Log To Console    ${response.status_code}

#Below keyword is not used in any tests, as I do not have valid user credentials to get token; Instead user personal login is used to generate a token and hardcoded the same in this script
GET Token
    ${header}    Create Dictionary    Content-Type=application/json    
    ${response}=  GET On Session    gorest    consumer/login    data={"username":"xxx@gmail.com","password":"yyy"}    headers=${header}
    Should Be Equal As Strings    ${response.status_code}    200
    Element Should Exist    ${response.content}    .token
    ${TOKEN}=           Get From Dictionary     ${response.json()}      token
    Set Suite Variable      ${TOKEN}        ${TOKEN}

GET call
    [Arguments]    ${session_name}    ${relative_url}    ${params}    ${expected_status}
    ${response}=  GET On Session    ${session_name}    ${relative_url}    params=${params}    expected_status=${expected_status}
    Log To Console    ${response.status_code} 
    ${actual_body}=    Convert To String    ${response.content} 
    Return From Keyword    ${actual_body} 

POST call
    [Arguments]    ${session_name}    ${relative_url}    ${head}    ${data}    ${expected_status}
    ${response}=    POST On Session    gorest    /public/v1/users    headers=${head}    json=${data}    expected_status=${expected_status}
    Log To Console    ${response.status_code}
    ${actual_body}=    Convert To String    ${response.content}
    Log To Console    ${actual_body} 

Close All Connections 
    Log To Console    Closing all connections