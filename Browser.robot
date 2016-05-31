*** Settings ***
Library           Selenium2Library
Library           String

*** Test Cases ***
Open a Browser and google something
    Open Browser    https://www.google.com    firefox
    sleep    5s
    Input Text    Search    something
    Click button    Google search
