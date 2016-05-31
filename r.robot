*** Settings ***
Documentation 		Bonjour Fencing UT rkscli Automation  	   	 
Suite Setup        Open Connection And Log In
Suite Teardown     Close All Connections
Library           SSHLibrary
Library           String

*** Variables ***
${AP}             172.19.150.158
${USERNAME}       BF
${PASSWORD}       BF
@{SRVLIST} 	  AirDisk 	AirPlay 	AirPortManagement 	 	AirPrint  	AirTunes  	AppleFileSharing  	AppleMobileDevices  	AppleTV  	iCloudSync  	iTunesRemote  	iTunesSharing  	OpenDirectoryMaster  	OpticalDiskSharing  	RuckusController  	ScreenSharing  	SecureFileSharing  	SecureShell  	WorldWideWeb  	WorldWideWebSSL  	WorkgroupManager  	Xgrid  	  	  	  	
${MIN_SRV_NUM} 	  1
${MAX_SRV_NUM} 	 22
${MAC_ADDR_BASE} 	aa:bb:cc:11:22

*** Test Cases ***
#Testing set bonjour-fencing debug enable
#	[Documentation] 	Set bonjour fencing debug enable and confirm from get cmd and rpm keys
#	[Tags] 				create 		debug
#	Set and confirm bonjour fencing debug 	enable

#Testing set bonjour-fencing debug disable 
#	[Documentation] 	Set bonjour fencing debug disable and confirm from get cmd and rpm keys
#	[Tags] 				create 		debug
#	Set and confirm bonjour fencing debug 	disable	

Testing set bonjour-fencing state enable
	[Documentation] 	Set bonjour fencing state enable and confirm from get cmd and rpm keys
	[Tags] 				create 		state
	Set and confirm bonjour fencing state 	enable

Testing set bonjour-fencing state disable 
	[Documentation] 	Set bonjour fencing state disable and confirm from get cmd and rpm keys
	[Tags] 				create 		state
	Set and confirm bonjour fencing state 	disable	


Testing set bonjour-fencing policy-name  
	[Documentation] 	Set bonjour fencing policy-name and confirm from get cmd and rpm keys
	[Tags] 				create 		policy-name
	Set and confirm bonjour fencing policy-name 	This policy is set to configure the AirPrint and AirPlay and other services.	

Testing set bonjour-fencing wireless add hop=0
	[Documentation] 	Create wireless entry for 21 service types, with hop=0, and verify with rpmkeys
	[Tags] 				create 		hop=0	
	set wireless with hops 	0

Testing set bonjour-fencing wireless add hop=1
	[Documentation] 	Create wireless entry for 21 service types, with hop=1, and verify with rpmkeys
	[Tags] 				create 		hop=1	
	set wireless with hops 	1

Testing set bonjour-fencing wireless del
	[Documentation] 	Delete all wireless entries configured for Bonjour Fencing
	[Tags] 				delete entries	
	delete all entries 	wireless

Testing set bonjour-fencing wired add hop=0
	[Documentation] 	Create wired entry for 21 service types, with hop=0, and verify with rpmkeys
	[Tags] 				Create 		hop=0	
	set wired with hops 	0

Testing set bonjour-fencing wired add hop=1
	[Documentation] 		Create wired entry for 21 service types, with hop=1, and verify with rpmkeys
	[Tags] 					Create 	 	hop=1	
	set wired with hops 	1

Testing set bonjour-fencing wired del
	[Documentation] 	Delete all wired entries configured for Bonjour Fencing
	[Tags] 				delete entries	
	delete all entries 	wired 

*** Keywords ***
Open Connection And Log In
    Open Connection    ${AP}
    Login    ${USERNAME}    ${PASSWORD}
    Write    ${USERNAME}
    Write    ${PASSWORD}
    Read Until    rkscli:


Set and confirm bonjour fencing state
	[Arguments] 	${state}
    Write    set bonjour-fencing ${state} 
    ${output}=    Read until    OK
    run keyword if 	"${state}"=="enable" 	should contain    ${output}   	ENABLED 
    run keyword if 	"${state}"=="disable" 	should contain    ${output}   	DISABLED
    Write    get bonjour-fencing 
    ${output}=    Read until    OK
    run keyword if 	"${state}"=="enable" 	should contain    ${output}   	ENABLED 
    run keyword if 	"${state}"=="disable" 	should contain    ${output}   	DISABLED
    Write    get rpmkey bonjour_fencing/enable
    ${output}=    Read until    OK
    run keyword if 	"${state}"=="enable" 	should contain    ${output}    bonjour_fencing/enable = 1
    run keyword if 	"${state}"=="disable" 	should contain    ${output}    bonjour_fencing/enable = 0

Set and confirm bonjour fencing debug 
	[Arguments] 	${state}
    Write    set bonjour-fencing debug ${state} 
    ${output}=    Read until    OK
    run keyword if 	"${state}"=="enable" 	should contain    ${output}   	ENABLED 
    run keyword if 	"${state}"=="disable" 	should contain    ${output}   	DISABLED
    Write    get bonjour-fencing debug
    ${output}=    Read until    OK
    run keyword if 	"${state}"=="enable" 	should contain    ${output}   	ENABLED 
    run keyword if 	"${state}"=="disable" 	should contain    ${output}   	DISABLED
    Write    get rpmkey bonjour_fencing/debug
    ${output}=    Read until    OK
    run keyword if 	"${state}"=="enable" 	should contain    ${output}    bonjour_fencing/debug = 1
    run keyword if 	"${state}"=="disable" 	should contain    ${output}    bonjour_fencing/debug = 0

Set and confirm bonjour fencing policy-name 
	[Arguments] 	${name}
    Write    set bonjour-fencing policy-name "${name}"
    ${output}=    Read until    OK
    Should contain    ${output}   	${name}
    Write    get bonjour-fencing policy-name 
    ${output}=    Read until    OK
    Should contain    ${output}   	${name}
    Write    get rpmkey bonjour_fencing/policy-name
    ${output}=    Read until    OK
    Should contain    ${output}    ${name}

set wireless with hops
	[Arguments] 	${HOPS}
	:FOR 	${IDX} 	IN RANGE 	${MIN_SRV_NUM} 	${MAX_SRV_NUM}
	\ 	Write 	set bonjour-fencing wireless add ${SRVLIST[${IDX}-1]} ${HOPS}
	\ 	${output}= 	Read until 	OK
	\ 	Should contain 	${output} 	Successfully added wireless entry for ${SRVLIST[${IDX}-1]} with hops=${HOPS}.
	\ 	Write 	get bonjour-fencing wireless
	\ 	${output}= 	Read until 	OK
	\ 	Should contain 	${output} 	${SRVLIST[${IDX}-1]} |       ${HOPS}
	\ 	Write 	get rpmkey bonjour_fencing/wireless/${${IDX}-1}/service-type
	\ 	${output}= 	Read until 	OK
	\ 	Should contain 	${output} 	bonjour_fencing/wireless/${${IDX}-1}/service-type = ${SRVLIST[${IDX}-1]}

set wired with hops
	[Arguments] 	${HOPS}
	:FOR 	${IDX} 	IN RANGE 	${MIN_SRV_NUM} 	${MAX_SRV_NUM}
	\ 	Write 	set bonjour-fencing wired add ${SRVLIST[${IDX}-1]} ${HOPS} ${MAC_ADDR_BASE}:${IDX}
	\ 	${output}= 	Read until 	OK
	\ 	Should contain 	${output} 	Successfully added wired entry for ${SRVLIST[${IDX}-1]} with hops=${HOPS} and mac address ${MAC_ADDR_BASE}:${IDX}
	\ 	Write 	get bonjour-fencing wired
	\ 	${output}= 	Read until 	OK
	\ 	Should contain 	${output} 	${SRVLIST[${IDX}-1]} |       ${HOPS}
	\ 	Write 	get rpmkey bonjour_fencing/wired/${${IDX}-1}/service-type
	\ 	${output}= 	Read until 	OK
	\ 	Should contain 	${output} 	bonjour_fencing/wired/${${IDX}-1}/service-type = ${SRVLIST[${IDX}-1]}

delete all entries 
	[Arguments] 	${type}
	:FOR 	${IDX} 	IN RANGE 	${MIN_SRV_NUM} 	${MAX_SRV_NUM}
	\ 	Write 	set bonjour-fencing ${type} del ${SRVLIST[${IDX}-1]}
	\ 	${output}= 	Read until 		OK 
	\ 	Should contain 	${output} 	Successfully deleted ${type} entry for ${SRVLIST[${IDX}-1]}
	\ 	Write 	get bonjour-fencing ${type} 
	\ 	${output}= 	Read until 		OK 
	\ 	Should not contain 	${output} 	"${SRVLIST[${IDX}-1]} "
