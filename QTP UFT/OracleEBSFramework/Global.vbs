
'strProjectPath = Split(Environment("TestDir"),"TestCases")(0)
'strProjectTestdataPath = Split(Environment("TestDir"),"TestCases")(0) & "TestData\"
'str_ORHRXMLPath = Split(Environment("TestDir"),"TestCases")(0) &"ObjectRepository\HR.xml"
'str_ORFSXMLPath = Split(Environment("TestDir"),"TestCases")(0) &"ObjectRepository\Finance.xml"
Public str_ORFSXMLPath
Public str_ORCMNXMLPath
Public str_OREBSXMLPath
Public strProjectResultPath
Public strUserDesktop
Public StrRootFolder
Public StrFrameWorkFolder
Public strTestcasesPath
Public strTestData
Public oPage
Public oFrame
Public sFile
Public gFolderName
Public strReceiptNumber
Public RequisitionNumber
Public sInvoiceNumber
Public sBatchName
Public sResourcesPathForData
Public iBatch_Name
Public iJournal_name
Public strURL
Public strUID
Public strPWD
Public oExcel
Public oWorkbook
Public oSheet
Public objExcel
Public oActiveWorkbook
Public oActiveSheet

''''''
Public iSaleOrderNumber
Public iWarehouseNumber
Public iItemNumber
Public iTDeliveryNum
Public iTDeliveryDetail
Public intRequisitionNumber

Set Wshell = CreateObject("WScript.Shell")
strUserDesktop = Wshell.SpecialFolders("Desktop")
StrRootFolder=strUserDesktop & "\ATD"
StrFrameWorkFolder=StrRootFolder&"\OracleEBSFramework"
sResourcesPathForData=StrFrameWorkFolder&"\Resources"
gDownloadLocation= "C:\Users\"&Environment("UserName")&"\Desktop\WebADI.xls"

Dim rKey
Const MIN_WAIT = 5
Const MID_WAIT = 15
Const MID1_WAIT = 10
Const MAX_WAIT = 35

'strProjectResultPath = Split(Environment("TestDir"),"TestCases")(0) & "Results"

'strProjectResultPath = "C:\Users\CTL-USER\Desktop\ATD\OracleEBSFramework\Results"
strProjectResultPath = StrFrameWorkFolder&"\Results"
gPOFUIExcel_FilePath=sResourcesPathForData &"\POFUIExcel_Template.xlsm"
gPOFUIExcel_SheetName="PO FUI Ver4.25.11"
'gDownloadLocation= sResourcesPathForData &"\PO creation with FUI.txt"
gPOFUI_NetworkPath="\\dnasftp1.atd-us.icd\PlanningFUI\"

str_ORFSXMLPath = strProjectResultPath&"\Finance.xml"
str_ORCMNXMLPath= strProjectResultPath&"\Common.xml"
str_OREBSXMLPath = strProjectResultPath&"\OracleEBS.xml"
str_ORQAPerfXMLPath = strProjectResultPath&"\QAPerf.xml"
'str_PuttyPath = 
Environment("ERRORFLAG") = True
Set oOracleLogin = Browser("OracleApplicationsHome").Page("OracleApplicationsHome")
Set oFSObj = Browser("OracleEBS").Page("OracleEBS")
Set sTest=OracleFormWindow("InvoiceBatches").OracleTable("BtachTable")
Set gTireProsFrame=Browser("OracleEBS").Page("TireProsHome").Frame("AdAgreements")

'Dim gFolderName
On Error Resume Next
gFolderName = Environment("FolderName")
On Error Goto 0

Environment("StepFailed") = "NO"
