*** Settings ***
Documentation     This example demonstrates executing commands on a remote machine
Suite Setup        Open Connection And Log In
Suite Teardown     Close All Connections
Library           SSHLibrary
Library           String

*** Variables ***
${AP}             172.19.150.158
${USERNAME}       BF
${PASSWORD}       BF
@{SRV_LIST} 	  AirDisk 	AirPlay 	AirPort Management 	 	AirPrint  	AirTunes  	Apple File Sharing  	Apple Mobile Devices  	Apple TV  	iCloud Sync  	iTunes Remote  	iTunes Sharing  	Open Directory Master  	Optical Disk Sharing  	Ruckus Controller  	Screen Sharing  	Secure File Sharing  	Secure Shell (SSH)  	World Wide Web (HTTP)  	World Wide Web SSL (HTTPS)  	Workgroup Manager  	Xgrid  	  	  	  	
${MIN_SRV_NUM} 	  1
${MAX_SRV_NUM} 	 22
${MAC_ADDR_BASE} 	aa:bb:cc:11:22

*** Test Cases ***
Set bonjour fencing state enabled and confirm from get cmd and rpm keys
	[Documentation] 	Set bonjour fencing state enabled and confirm from get cmd and rpm keys
	[Tags] 				create 		state
	Set and confirm bonjour fencing state 	enable

Set bonjour fencing state disabled and confirm from get cmd and rpm keys
	[Documentation] 	Set bonjour fencing state disabled and confirm from get cmd and rpm keys
	[Tags] 				create 		state
	Set and confirm bonjour fencing state 	disable	

Create wireless entry for 21 service types, with hop=0, and verify with rpmkeys
	[Documentation] 	Create wireless entry for 21 service types, with hop=0, and verify with rpmkeys
	[Tags] 				create 		hop=0	
	set wireless with hops 	0

Create wireless entry for 21 service types, with hop=1, and verify with rpmkeys
	[Documentation] 	Create wireless entry for 21 service types, with hop=1, and verify with rpmkeys
	[Tags] 				create 		hop=1	
	set wireless with hops 	1

Create wired entry for 21 service types, with hop=0, and verify with rpmkeys
	[Documentation] 	Create wired entry for 21 service types, with hop=0, and verify with rpmkeys
	[Tags] 				Create 		hop=0	
	set wired with hops 	0

Create wired entry for 21 service types, with hop=1, and verify with rpmkeys
	[Documentation] 		Create wired entry for 21 service types, with hop=1, and verify with rpmkeys
	[Tags] 					Create 	 	hop=1	
	set wired with hops 	1

Del all wired entries
	[Documentation] 	Delete all wired entries configured for Bonjour Fencing
	[Tags] 				delete entries	
	delete all entries 	wired 

Del all wireless entries
	[Documentation] 	Delete all wireless entries configured for Bonjour Fencing
	[Tags] 				delete entries	
	delete all entries 	wireless

*** Keywords ***
Open Connection And Log In
    Open Connection    ${AP}
    Login    ${USERNAME}    ${PASSWORD}
    Write    ${USERNAME}
    Write    ${PASSWORD}
    Read Until    rkscli:


Set and confirm bonjour fencing state
	[Arguments] 	${state}
    Write    set bonjour-fencing state ${state} 
    ${output}=    Read until    OK
    run keyword if 	"${state}"=="enable" 	should contain    ${output}   	ENABLED 
    run keyword if 	"${state}"=="disable" 	should contain    ${output}   	DISABLED
    Write    get bonjour-fencing state
    ${output}=    Read until    OK
    run keyword if 	"${state}"=="enable" 	should contain    ${output}   	ENABLED 
    run keyword if 	"${state}"=="disable" 	should contain    ${output}   	DISABLED
    Write    get rpmkey wsgclient/bf_enable
    ${output}=    Read until    OK
    run keyword if 	"${state}"=="enable" 	should contain    ${output}    wsgclient/bf_enable = 1
    run keyword if 	"${state}"=="disable" 	should contain    ${output}    wsgclient/bf_enable = 0

set wireless with hops
	[Arguments] 	${HOPS}
	:FOR 	${IDX} 	IN RANGE 	${MIN_SRV_NUM} 	${MAX_SRV_NUM}
	\ 	Write 	set bonjour-fencing wireless add ${IDX} ${HOPS}
	\ 	${output}= 	Read until 	OK
	\ 	Should contain 	${output} 	Successfully add wireless entry for ${IDX}.${SRVLIST[${IDX}-1]} with hops=${HOPS}.
	\ 	Write 	get bonjour-fencing wireless
	\ 	${output}= 	Read until 	OK
	\ 	Should contain 	${output} 	${SRVLIST[${IDX}-1]}  ${HOPS}
	\ 	Write 	get rpmkey wsgclient/bf_wireless/${${IDX}-1}/service_type
	\ 	${output}= 	Read until 	OK
	\ 	Should contain 	${output} 	wsgclient/bf_wireless/${${IDX}-1}/service_type = ${SRVLIST[${IDX}-1]}

set wired with hops
	[Arguments] 	${HOPS}
	:FOR 	${IDX} 	IN RANGE 	${MIN_SRV_NUM} 	${MAX_SRV_NUM}
	\ 	Write 	set bonjour-fencing wired add ${IDX} ${HOPS} ${MAC_ADDR_BASE}:${IDX}
	\ 	${output}= 	Read until 	OK
	\ 	Should contain 	${output} 	Successfully add wired entry for ${IDX}.${SRVLIST[${IDX}-1]} with hops=${HOPS} and mac address ${MAC_ADDR_BASE}:${IDX}
	\ 	Write 	get bonjour-fencing wired
	\ 	${output}= 	Read until 	OK
	\ 	Should contain 	${output} 	${SRVLIST[${IDX}-1]}  ${HOPS}
	\ 	Write 	get rpmkey wsgclient/bf_wired/${${IDX}-1}/service_type
	\ 	${output}= 	Read until 	OK
	\ 	Should contain 	${output} 	wsgclient/bf_wired/${${IDX}-1}/service_type = ${SRVLIST[${IDX}-1]}

delete all entries 
	[Arguments] 	${type}
	:FOR 	${IDX} 	IN RANGE 	${MIN_SRV_NUM} 	${MAX_SRV_NUM}
	\ 	Write 	set bonjour-fencing ${type} del ${IDX}
	\ 	${output}= 	Read until 		OK 
	\ 	Should contain 	${output} 	Successfully deleted ${type} entry for ${IDX}.${SRVLIST[${IDX}-1]}
	\ 	Write 	get bonjour-fencing ${type} 
	\ 	${output}= 	Read until 		OK 
	\ 	Should not contain 	${output} 	${SRVLIST[${IDX}-1]}

*** Keywords ***
Find Index
   [Arguments]    ${element}    @{items}
   ${index} =    Set Variable    ${0}
   :FOR    ${item}    IN    @{items}
   \    Run Keyword If    '${item}' == '${element}'    Return From Keyword    ${index}
   \    ${index} =    Set Variable    ${index + 1}
   Return From Keyword    ${-1}    # Also [Return] would work here.
