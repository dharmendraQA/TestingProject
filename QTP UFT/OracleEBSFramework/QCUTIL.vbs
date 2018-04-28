On Error Resume Next
'******************************************************************************************************************************************************************************************************
' QC Utli
''******************************************************************************************************************************************************************************************************
'Desciption of Library :  Used to to all operation on QC
'******************************************************************************************************************************************************************************************************
'Total No. of  Functions:9
'******************************************************************************************************************************************************************************************************
'Functions and their description
'Func_LoginToQC	Used to Login into QC by Scripting
'Func_ExportSummaryLogToQC	Used to Export the Summary Log into Quality Center
'Func_ExportDetailedLogToQC	Used to Export the Detailed Log into Quality Center
'Func_ExportErrorSnapShotToQC	Used to Export the Error Snap Shot into Quality Center
'Func_GetFolderAttachmentPath	Used to download the file from QC to Temp Directory
'Func_AddTransactionTypeFolderInToQC	Used to Add the TransactionType folder in QC
'Func_AddScenarioFolderInToQC	Used to Add the Scenario folder in QC
'Func_ExportFilesIntoQC()
'Func_QCStatusFail()


'******************************************************************************************************************************************************************************************************************************************
'	Function Name						:						  Func_GetFolderAttachmentPath
'	Objective								:							 Used to download the file from QC to Temp Directory
'	Input Parameters				:							  sTDFolderPath, sTDAttachmentName
'	Output Parameters			:							   Temp Path  where the file is downloaded
'	Date Created					:								26-Aug-2013
'	QTP Version						:								11.0
'	QC Version						:								  QC 11 
'	Pre-requisites					:								NIL  
'	Created By						:				 				
'	Modification Date		:		   
'******************************************************************************************************************************************************************************************************************************************

Public Function Func_GetFolderAttachmentPath(sTDFolderPath, sTDAttachmentName)
	Dim oAttachmentFactory, oAttachment, oAttachmentList, oAttachmentFilter, oTreeManager, oSysTreeNode, iNdId,sPath
	Set oTreeManager = QCUtil.TDConnection.TreeManager 
	Set oSysTreeNode = oTreeManager.NodeByPath(sTDFolderPath) 
	Set oAttachmentFactory = oSysTreeNode.Attachments 
	Set oAttachmentFilter = oAttachmentFactory.Filter
	iNdId = oSysTreeNode.NodeID 
	oAttachmentFilter.Filter("CR_REFERENCE") = "'ALL_LISTS_" & iNdId & "_" & sTDAttachmentName & "'" 
	Set oAttachmentList = oAttachmentFilter.NewList 

	If oAttachmentList.Count > 0 Then 
		Set oAttachment = oAttachmentList.Item(1) 
		oAttachment.Load True, "" 
		sPath = oAttachment.FileName 
    End If
	Func_GetFolderAttachmentPath = sPath
	Set oAttachmentFactory = Nothing 
	Set oAttachment = Nothing 
	Set oAttachmentList = Nothing 
	Set oAttachmentFilter = Nothing 
	Set oTreeManager = Nothing 
	Set oSysTreeNode = Nothing 
End Function

Public Function fnGetFolderAttachmentPath(sTDFolderPath, sTDAttachmentName)
	Dim oAttachmentFactory, oAttachment, oAttachmentList, oAttachmentFilter, oTreeManager, oSysTreeNode, iNdId,sPath
	Set oTreeManager = QCUtil.TDConnection.TreeManager 
	Set oSysTreeNode = oTreeManager.NodeByPath("Subject\"&sTDFolderPath) 
	Set oAttachmentFactory = oSysTreeNode.Attachments 
	Set oAttachmentFilter = oAttachmentFactory.Filter
	iNdId = oSysTreeNode.NodeID 
	oAttachmentFilter.Filter("CR_REFERENCE") = "'ALL_LISTS_" & iNdId & "_" & sTDAttachmentName & "'" 
	Set oAttachmentList = oAttachmentFilter.NewList 
	If oAttachmentList.Count > 0 Then 
		Set oAttachment = oAttachmentList.Item(1) 
		oAttachment.Load True, "" 
		sPath = oAttachment.FileName 
		
		Set strObj=CreateObject("Scripting.FileSystemObject")
'		strObj.CopyFile sPath,strTestData&"\"
		strDestination=strTestData &"\"& Environment("TestName") &".xls"
'		strObj.MoveFile sPath,strDestination
		strObj.CopyFile sPath,strDestination
	End If
'	fnGetFolderAttachmentPath = sPath
	fnGetFolderAttachmentPath = strDestination
	Set oAttachmentFactory = Nothing 
	Set oAttachment = Nothing 
	Set oAttachmentList = Nothing 
	Set oAttachmentFilter = Nothing 
	Set oTreeManager = Nothing 
	Set oSysTreeNode = Nothing 
End Function

'******************************************************************************************************************************************************************************************************************************************
'	Function Name						:						  Func_ExportDetailedLogToQC
'	Objective							:							 Used to Upload the Detailed Report into QC
'	Input Parameters					:							 NIL
'	Output Parameters					:								NIL
'	Date Created						:								26-Aug-2013
'	QTP Version							:								11.0
'	QC Version							:								  QC 11 
'	Pre-requisites						:								NIL  
'	Created By							:								
'	Modification Date					:		   
'******************************************************************************************************************************************************************************************************************************************

Function Func_ExportDetailedLogToQC()
			On Error Resume Next 
			Set oQC = QCUtil.TDconnection 
			Set oTreeManager = oQC.TreeManager 
			Set oRoot = oTreeManager.TreeRoot("Subject")
			Set oChildNode = oRoot.FindChildNode("Stroz Automation Project")
			Set oChildNode1 = oChildNode.FindChildNode("HTMLResults")
			Set oChildNode2 = oChildNode1.FindChildNode(Environment("SCENARIOID"))
			Set oFoldAttachments = oChildNode2.Attachments
			Set oFileAttachment = oFoldAttachments.AddItem(Null)
			oFileAttachment.FileName = Environment("DETAILEDREPORTHTML")
			oFileAttachment.Description = Environment.Value("LocalHostName")
			oFileAttachment.Type = 1
			oFileAttachment.Post
End Function


'******************************************************************************************************************************************************************************************************************************************
'	Function Name						:						  Func_ExportSearchResultsToQC
'	Objective								:							 Used to Upload the Detailed Report into QC
'	Input Parameters				:							 NIL
'	Output Parameters			:								NIL
'	Date Created					:								26-Aug-2013
'	QTP Version						:								11.0
'	QC Version						:								  QC 11 
'	Pre-requisites					:								NIL  
'	Created By						:								
'	Modification Date		:		   
'******************************************************************************************************************************************************************************************************************************************
Function Func_ExportSearchResultsToQC()
			On Error Resume Next 
			Set oQC = QCUtil.TDconnection 
			Set oTreeManager = oQC.TreeManager 
			Set oRoot = oTreeManager.TreeRoot("Subject")
			Set oChildNode = oRoot.FindChildNode("Stroz Automation Project")
			Set oChildNode1 = oChildNode.FindChildNode("HTMLResults")
			Set oChildNode2 = oChildNode1.FindChildNode(Environment("SCENARIOID"))
			Set oFoldAttachments = oChildNode2.Attachments
			Set oFileAttachment = oFoldAttachments.AddItem(Null)
			oFileAttachment.FileName = Environment("SEARCHRESULTDESTPATH")
			oFileAttachment.Description = Environment.Value("LocalHostName")
			oFileAttachment.Type = 1
			oFileAttachment.Post
End Function

'******************************************************************************************************************************************************************************************************************************************
'	Function Name						:						  Func_ExportSummaryLogToQC
'	Objective							:						  Used to Upload the Summary Report into QC
'	Input Parameters					:						  NIL
'	Output Parameters					:						  NIL
'	Date Created						:						 26-Aug-2013
'	QTP Version							:						 11.0
'	QC Version							:						 QC 11 
'	Pre-requisites						:						NIL  
'	Created By							:								
'	Modification Date					:		   
'******************************************************************************************************************************************************************************************************************************************
Function Func_ExportSummaryLogToQC()
			On Error Resume Next 
			Set oQC = QCUtil.TDconnection 
			Set oTreeManager = oQC.TreeManager 
			Set oRoot = oTreeManager.TreeRoot("Subject")
			Set oChildNode = oRoot.FindChildNode("Stroz Automation Project")
			Set oChildNode1 = oChildNode.FindChildNode("HTMLResults")
			Set oFoldAttachments = oChildNode1.Attachments
			Set oFileAttachment = oFoldAttachments.AddItem(Null)
			oFileAttachment.FileName = Environment("SUMMARYREPORTHTML")
			oFileAttachment.Description = Environment.Value("LocalHostName")
			oFileAttachment.Type = 1
			oFileAttachment.Post
End Function


'******************************************************************************************************************************************************************************************************************************************
'	Function Name						:						  Func_ExportErrorSnapShotToQC
'	Objective								:							 Used to upload the Snap Shot in to QC
'	Input Parameters				:							 NIL
'	Output Parameters			:								NIL
'	Date Created					:								26-Aug-2013
'	QTP Version						:								11.0
'	QC Version						:								  QC 11 
'	Pre-requisites					:								NIL  
'	Created By						:								
'	Modification Date		:		   
'******************************************************************************************************************************************************************************************************************************************
Function Func_ExportErrorSnapShotToQC(sQCUploadPath)
			On Error Resume Next 
			Set oQC = QCUtil.TDconnection 
			Set oTreeManager = oQC.TreeManager 
			Set oRoot = oTreeManager.TreeRoot("Subject")
			Set oChildNode = oRoot.FindChildNode("Stroz Automation Project")
			Set oChildNode1 = oChildNode.FindChildNode("HTMLResults")
			Set oChildNode2 = oChildNode1.FindChildNode(Environment("SCENARIOID"))
			Set oFoldAttachments = oChildNode2.Attachments
			
			Set oFileAttachment = oFoldAttachments.AddItem(Null)
			oFileAttachment.FileName = sQCUploadPath
			oFileAttachment.Description = Environment.Value("LocalHostName")
			oFileAttachment.Type = 1
			oFileAttachment.Post
End Function

'******************************************************************************************************************************************************************************************************************************************
'	Function Name						:						  Func_LoginToQC
'	Objective								:							 Used to Login into QC Using QTP Script
'	Input Parameters				:							 sQCURL, sQCUserName, sQCPassword, sQCProjectName, sQCDomainName
'	Output Parameters			:								NIL
'	Date Created					:								26-Aug-2013
'	QTP Version						:								11.0
'	QC Version						:								  QC 11 
'	Pre-requisites					:								NIL  
'	Created By						:								
'	Modification Date		:		   
'******************************************************************************************************************************************************************************************************************************************

Public Function Func_LoginToQC(sQCURL,sQCUserName,sQCPassword,sQCProjectName,sQCDomainName)
	On Error Resume Next
	Dim oQCConnection
	Set oQCConnection = CreateObject("TDApiOle80.TDConnection")
	oQCConnection.InitConnectionEx sQCURL
	oQCConnection.Login sQCUserName, sQCPassword	
	If (oQCConnection.LoggedIn <> True) Then
			MsgBox "QC User Authentication Failed. The execution will terminate"
			ExitTest()
	End If	
	oQCConnection.Connect sQCDomainName, sQCProjectName
	' Call the Function Required
        	
	oQCConnection.Logout
	oQCConnection.Disconnect
	oQCConnection.ReleaseConnection
	Err.Clear
End Function

'******************************************************************************************************************************************************************************************************************************************
'	Function Name						:						  Func_AddTransactionTypeFolderInToQC
'	Objective								:							 Used to Add Transaction Type Folder into QC    
'	Input Parameters				:							 NIL
'	Output Parameters			:								Folder is Created in QC
'	Date Created					:								26-Aug-2013
'	QTP Version						:								11.0
'	QC Version						:								  QC 11 
'	Pre-requisites					:								NIL  
'	Created By						:								
'	Modification Date		:		   
'******************************************************************************************************************************************************************************************************************************************

Public Function Func_AddTransactionTypeFolderInToQC()

				On Error Resume Next
				Set oQC = QCUtil.QCConnection 
				Set oTreeManager = oQC.TreeManager
				Set oRootPath = oTreeManager.TreeRoot("Subject")
				Set oChildNode = oRootPath.FindChildNode("Stroz Automation Project")
				Set oChildNode1 = oChildNode.FindChildNode("HTMLResults")
'				Set oChildNode2 = oChildNode1.AddNode(Environment("TRANSACTIONTYPE"))
				oChildNode1.Post
				oChildNode1.Refresh
				Err.Clear

End Function

'******************************************************************************************************************************************************************************************************************************************
'	Function Name						:						   Func_AddScenarioFolderInToQC
'	Objective								:							  Used to Add Scenario ID Folder into QC    
'	Input Parameters				:							   NIL
'	Output Parameters			:								Scenario ID Folder Created in QC
'	Date Created					:								26-Aug-2013
'	QTP Version						:								11.0
'	QC Version						:								  QC 11 
'	Pre-requisites					:								NIL  
'	Created By						:								
'	Modification Date		:		   
'******************************************************************************************************************************************************************************************************************************************

Public Function Func_AddScenarioFolderInToQC()

				On Error Resume Next
				Set oQC = QCUtil.QCConnection 
				Set oTreeManager = oQC.TreeManager
				Set oRootPath = oTreeManager.TreeRoot("Subject")
				Set oChildNode = oRootPath.FindChildNode("Stroz Automation Project")
				Set oChildNode1 = oChildNode.FindChildNode("HTMLResults")
'				Set oChildNode2 = oChildNode1.FindChildNode(Environment("TRANSACTIONTYPE"))
				Set oChildNode2 = oChildNode1.AddNode(Environment("SCENARIOID"))
				oChildNode2.Post
				Err.Clear

End Function

'******************************************************************************************************************************************************************************************************************************************
'	Function Name						:						   Func_ExportFilesIntoQC
'	Objective								:							  Used to ExportLogs in to QC
'	Input Parameters				:							   NIL
'	Output Parameters			:								NIL
'	Date Created					:								26-Aug-2013
'	QTP Version						:								11.0
'	QC Version						:								  QC 11 
'	Pre-requisites					:								NIL  
'	Created By						:								
'	Modification Date		:		   
'******************************************************************************************************************************************************************************************************************************************

Public Function Func_ExportFilesIntoQC()
	Call Func_ExportDetailedLogToQC()
	Call Func_ExportSummaryLogToQC()
End Function

''******************************************************************************************************************************************************************************************************************************************
''	Function Name						:						   Func_QCStatusFail
''	Objective								:							  Used to Update the Status in QC
''	Input Parameters				:							   NIL
''	Output Parameters			:								NIL
''	Date Created					:								26-Aug-2013
''	QTP Version						:								11.0
''	QC Version						:								  QC 11 
''	Pre-requisites					:								NIL  
''	Created By						:								
''	Modification Date		:		   
''******************************************************************************************************************************************************************************************************************************************
'
'Public Function Func_QCStatusFail()
'					On Error Resume Next
'					Dim objStepName
'					Dim objCurrentRun
'					Dim strMyStep
'					Set objCurrentRun = QCutil.CurrentRun
'	
'					Set objStepName = objCurrentRun.StepFactory
'					Set strAtt = objStepName.AddItem(null)
'					strAtt.Name = aStepname
'					strAtt.post
'					objCurrentRun.Status = "Failed"
'					strMyStep.Post
'					Set objCurrentRun = Nothing
'					Set objStepName = Nothing
'End Function


'############################################################################# End of QC Functions ###############################################################################





Function fnExportDetailedLogToQC(strFilePath)
	wait(5)
	On Error Resume Next 
	Set oQC = QCUtil.QCConnection 
	Set oTreeManager = oQC.TreeManager 
	Set oRoot = oTreeManager.TreeRoot("Subject")
	Set oRoot1 = oRoot.FindChildNode("EBSResourcesFramework")
	Set oChildNode = oRoot1.FindChildNode("Reports")
	wait(3)
	Set oFoldAttachments = oChildNode.Attachments
	wait(3)
	Set oFileAttachment = oFoldAttachments.AddItem(Null)
	wait(3)
	oFileAttachment.FileName =strFilePath
	oFileAttachment.Description = Environment.Value("LocalHostName")
	oFileAttachment.Type = 1
	oFileAttachment.Post
	oFileAttachment.Refresh
	oRoot.Refresh
		wait(10)
		Set oFileAttachment =  Nothing
		Set oChildNode =  Nothing
		Set oRoot =  Nothing
		Set oTreeManager =  Nothing
		Set oQC =  Nothing
End Function



'===========
''************************************************************************************************************************************************
''	Function Name	 	 :		fnZipFolder
''	Objective			 :		Used to zip the result folder
''	Input Parameters	 :		NIL
''	Output Parameters	 :		NIL
''	Date Created		 :		26-Aug-2013
''	QTP Version			 :		12.53
''	QC Version			 :		QC 11.52
''	Pre-requisites		 :		NIL  
''	Created By			 :		Narendra						
''	Modification Date	 :		   
''************************************************************************************************************************************************

Public Function fnZipFolder(strSource,strTarget)
	' make sure source folder has \ at end
	If Right(strSource, 1) <> "\" Then
		strSource = strSource & "\"
	End If
	Set objFSO = CreateObject("Scripting.FileSystemObject")
	Set zip = objFSO.OpenTextFile(strTarget, 2, vbtrue)
	' this is the header to designate a file as a zip
	zip.Write "PK" & Chr(5) & Chr(6) & String( 18, Chr(0) )
	zip.Close
	Set zip = nothing
	Wait(5)
	Set objApp = CreateObject( "Shell.Application" )
	intSkipped = 0
	' Loop over items within folder and use CopyHere to put them into the zip folder
	For Each objItem in objApp.NameSpace( strSource ).Items
		'msgbox objItem
		Wait(5)
		If objItem.IsFolder Then
			Set objFolder = objFSO.GetFolder( objItem.Path )
			' if this folder is empty, then skip it as it can't compress empty folders
			If objFolder.Files.Count + objFolder.SubFolders.Count = 0 Then
				intSkipped = intSkipped + 1
			Else
				objApp.NameSpace( strTarget ).CopyHere objItem
			End If
		Else
			objApp.NameSpace( strTarget ).CopyHere objItem
		End If
	Next
	intSrcItems = objApp.NameSpace( strSource ).Items.Count
	Wait(5)
	' delay until at least items at the top level are available
	Do Until objApp.NameSpace( strTarget ).Items.Count + intSkipped = intSrcItems
	   Wait(2)
	Loop
	'cleanup
	Set objItem = nothing
	Set objFolder = nothing
	Set objApp = nothing
	Set objFSO = nothing
End Function


' This function no longer in use, function below this with same name will be used

Public Function fnUploadReportObsolete(pathToZipFile, dirToZip)
	'WScript.Echo "Creating zip  (" & pathToZipFile & ") from (" & dirToZip & ")"
 
   Dim fso
   Set fso = CreateObject("Scripting.FileSystemObject")
   pathToZipFile = fso.GetAbsolutePathName(pathToZipFile)
   dirToZip = fso.GetAbsolutePathName(dirToZip)
 
   If fso.FileExists(pathToZipFile) Then
       fso.DeleteFile pathToZipFile
   End If 
   If Not fso.FolderExists(dirToZip) Then
       Exit Function
   End If
 
   Set fso = CreateObject("Scripting.FileSystemObject")

   Set file = fso.CreateTextFile(pathToZipFile&".zip")
 
   file.Write Chr(80) & Chr(75) & Chr(5) & Chr(6) & String(18, 0)
 
   file.Close
   Set fso = Nothing
   Set file = Nothing

   set sa = CreateObject("Shell.Application")
 
   Dim zip
   Set zip = sa.NameSpace(pathToZipFile&".zip")
 
   Dim d
   Set d = sa.NameSpace(dirToZip)
 
   zip.CopyHere d.items, 4
 
   Do Until d.Items.Count <= zip.Items.Count
       Wait 1
   Loop
   
   Set nowTest = QCUtil.CurrentTestSet
   Set attachmentPath = nowTest.Attachments
   Set nowAttachment = attachmentPath.AddItem(Null) 
   'Replace with the path to your file:
   nowAttachment.FileName = pathToZipFile&".zip"
   nowAttachment.Type = 1
   nowAttachment.Post()
End Function

'************************************************************************************************************************************************
'	Function Name	 	 :		fnUploadReport
'	Objective			 :		Used to Update the Status in QC
'	Input Parameters	 :		NIL
'	Output Parameters	 :		NIL
'	Date Created		 :		26-Aug-2013
'	QTP Version			 :		11.0
'	QC Version			 :		QC 11 
'	Pre-requisites		 :		NIL  
'	Created By			 :								
'	Modification Date	 :		   
'************************************************************************************************************************************************
Public Function fnUploadReport(pathToZipFile, dirToZip)
	
'   Call fnCheckTestFail()
   Dim fso
   Set fso = CreateObject("Scripting.FileSystemObject")
   pathToZipFile = fso.GetAbsolutePathName(pathToZipFile)
   dirToZip = fso.GetAbsolutePathName(dirToZip)
 
   If fso.FileExists(pathToZipFile) Then
       fso.DeleteFile pathToZipFile
   End If 
   If Not fso.FolderExists(dirToZip) Then
       Exit Function
   End If
 
   Set fso = CreateObject("Scripting.FileSystemObject")

   Set file = fso.CreateTextFile(pathToZipFile&".zip")
 
   file.Write Chr(80) & Chr(75) & Chr(5) & Chr(6) & String(18, 0)
 
   file.Close
   Set fso = Nothing
   Set file = Nothing

   set sa = CreateObject("Shell.Application")
 
   Dim zip
   Set zip = sa.NameSpace(pathToZipFile&".zip")
 
   Dim d
   Set d = sa.NameSpace(dirToZip)
 
   zip.CopyHere d.items, 4
 
   Do Until d.Items.Count <= zip.Items.Count
       Wait 1
   Loop
   
   If Setting("IsInTestDirectorTest")<>Empty Then ''Updated By Pradeep on 11th July. To Update the Run Status flag at the end of execution	
   
	Dim TDrun, attf, att
	Set TDrun =QCUtil.CurrentRun	    
	Set attf = TDrun.Attachments
	Set att = attf.AddItem(Null)
	
	att.FileName = pathToZipFile&".zip"
	att.Type = 1
	att.Post
	att.Save False
	
	If Environment("StepFailed") = "YES" Then
		TDrun.Status = "Failed"
		TDrun.Field("RN_STATUS") = "Failed"
		TDrun.Post
		TDrun.Refresh
		Environment("StepFailed") = "NO"
	End If 
    
   End If 
End Function


'************************************************************************************************************************************************
'	Function Name	 	 :		fnCheckTestFail
'	Objective			 :		Used to update status in QC
'	Input Parameters	 :		NIL
'	Output Parameters	 :		NIL
'	Date Created		 :		12-Dec-2016
'	QTP Version			 :		11.0
'	QC Version			 :		QC 11 
'	Pre-requisites		 :		NIL  
'	Created By			 :		Gallop						
'	Modification Date	 :		   
'************************************************************************************************************************************************

Public Function fnCheckTestFail()
	
	Set objFso = CreateObject("Scripting.FileSystemObject")
	blnFailed = 0
	If objFso.FileExists(strTestcasesPath&"\"& Environment.Value("TestName")&".html") Then
		Set objResFile = objFso.OpenTextFile(strTestcasesPath&"\"& Environment.Value("TestName")&".html")
'		Set objTest = objFso1.CreateTextFile ("C:\Sample.txt")
'		objTest.WriteLine strTestcasesPath&"\"& Environment.Value("TestName")&".html" &vbCrlf
		
		strResTxt = objResFile.ReadAll
		If Instr(strResTxt, "Fail.png") <> 0 Then
			blnFailed = 1
'			objTest.WriteLine "Failed "&blnFailed			
		End If
'		objTest.Close
		If blnFailed = 1 Then
			Set abc = QCUtil.CurrentTest()
			abc.ExecStatus =  "Failed"
			blnFailed = 0
			abc = nothing
		End If
	End If	
End Function

'************************************************************************************************************************************************
'	Function Name	 	 :		fnOpenPutty
'	Objective			 :		Used to open Putty utility and set the configuration
'	Input Parameters	 :		NIL
'	Output Parameters	 :		NIL
'	Date Created		 :		4-Aug-2016
'	QTP Version			 :		11.0
'	QC Version			 :		QC 11.53
'	Pre-requisites		 :		NIL  
'	Created By			 :								
'	Modification Date	 :		   
'************************************************************************************************************************************************
Public Function fnOpenPutty(strApp)
	If Window("PuTTY Configuration").Exist(2) Then
		Window("PuTTY Configuration").Close
	ElseIf TeWindow("TeWindow").Exist(2) Then
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micAltDwn + micF4 + micAltUp
		If Dialog("PuTTY Exit Confirmation").Exist Then
			Dialog("PuTTY Exit Confirmation").WinButton("OK").Click:Wait 2
		End If
	End If
'	Wait(MIN_WAIT)
	Systemutil.Run (StrFrameWorkFolder&"\Resources\putty.exe")
'	Invokeapplication (strProjectResultPath&"\Resources\putty.exe")
	Wait 5
	If Ucase(strApp) = "SSH" Then
		Window("PuTTY Configuration").WinEdit("txt_HostName").Set "ZQA.test.icd"
		Window("PuTTY Configuration").WinRadioButton("rad_SSH").Set
	ElseIf Ucase(strApp) = "TELNET" Then
		Window("PuTTY Configuration").WinEdit("txt_HostName").Set "WMSQA.test.icd"
		Window("PuTTY Configuration").WinRadioButton("rad_Telnet").Set
	End If
	Wait 5
	Window("PuTTY Configuration").WinTreeView("tvw_Category:").Select 1
	Window("PuTTY Configuration").WinRadioButton("rad_AllSessionOutput").Set
	Set objFSO = createobject("Scripting.filesystemobject")
'	Wait(MIN_WAIT)
	If objFSO.FileExists(StrFrameWorkFolder&"\Resources\Log.txt")Then
	   objFSO.DeleteFile(StrFrameWorkFolder&"\Resources\Log.txt")
	   objFSO.CreateTextFile(StrFrameWorkFolder&"\Resources\Log.txt")
'	   objFSO.Close
	End If
	Wait 5
	Window("PuTTY Configuration").WinEdit("txt_LogFileName:").Set StrFrameWorkFolder&"\Resources\Log.txt"
	Window("PuTTY Configuration").WinTreeView("tvw_Category:").Select 3
	Window("PuTTY Configuration").WinRadioButton("rad_VT100+").Set
	Window("PuTTY Configuration").WinButton("btn_Open").Click
'	wait(MIN_WAIT)
	If Dialog("PuTTY Log to File").WinButton("btn_Yes").Exist(MIN_WAIT) Then
		Dialog("PuTTY Log to File").WinButton("btn_Yes").Highlight
		Dialog("PuTTY Log to File").WinButton("btn_Yes").Click
	End If
'	Wait(MIN_WAIT)
	If TeWindow("TeWindow").Exist(MIN_WAIT) Then
		rptWriteReport "Pass", "Checking for emulator" , "Emulator window is displayed"
		fnReportStepALM "Emulator window","Passed","Emulator window display","Emulator window should be displayed","Emulator window is displayed"
'	Else
'		rptWriteReport "Fail", "Checking for SystemZ emulator" , "SystemZ window is not displayed"
'		fnReportStepALM "Systemz window","Failed","SystemZ window display","Systemz window should be displayed","Systemz window is not displayed"
'		ExitAction()
	End If	
'	Wait(MAX_WAIT)
	
End Function


'************************************************************************************************************************************************
'	Function Name	 	 :		fnOpenPuttyfnl
'	Objective			 :		Used to open Putty utility and set the configuration
'	Input Parameters	 :		NIL
'	Output Parameters	 :		NIL
'	Date Created		 :		4-Aug-2016
'	QTP Version			 :		11.0
'	QC Version			 :		QC 11.53
'	Pre-requisites		 :		NIL  
'	Created By			 :								
'	Modification Date	 :		   
'************************************************************************************************************************************************
Public Function fnOpenPuttyfnl(strApp)
	If Window("PuTTY Configuration").Exist(2) Then
		Window("PuTTY Configuration").Close
	ElseIf TeWindow("TeWindow").Exist(2) Then
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micAltDwn + micF4 + micAltUp
		If Dialog("PuTTY Exit Confirmation").Exist Then
			Dialog("PuTTY Exit Confirmation").WinButton("OK").Click
		End If
	End If
	Systemutil.Run (StrFrameWorkFolder&"\Resources\putty.exe")
'	Invokeapplication (strProjectResultPath&"\Resources\putty.exe")
	If Ucase(strApp) = "SSH" Then
		Window("PuTTY Configuration").WinEdit("txt_HostName").Set "ZQA.test.icd"
		Window("PuTTY Configuration").WinRadioButton("rad_SSH").Set
	ElseIf Ucase(strApp) = "TELNET" Then
		Window("PuTTY Configuration").WinEdit("txt_HostName").Set "WMSQA.test.icd"
		Window("PuTTY Configuration").WinRadioButton("rad_Telnet").Set
	End If
	Wait(2)
	Window("PuTTY Configuration").WinTreeView("tvw_Category:").Select 1
	Window("PuTTY Configuration").WinRadioButton("rad_AllSessionOutput").Set
	Set objFSO = createobject("Scripting.filesystemobject")
	Wait(2)
	If objFSO.FileExists(StrFrameWorkFolder&"\Resources\Log.txt")Then
	   objFSO.DeleteFile(StrFrameWorkFolder&"\Resources\Log.txt")
	   objFSO.CreateTextFile(StrFrameWorkFolder&"\Resources\Log.txt")
'	   objFSO.Close
	End If
	Wait(2)
	Window("PuTTY Configuration").WinEdit("txt_LogFileName:").Set StrFrameWorkFolder&"\Resources\Log.txt"
	Window("PuTTY Configuration").WinTreeView("tvw_Category:").Select 3
	Window("PuTTY Configuration").WinRadioButton("rad_VT100+").Set
	Window("PuTTY Configuration").WinButton("btn_Open").Click
	Wait(2)
	If Dialog("PuTTY Log to File").WinButton("btn_Yes").Exist(2) Then
		Dialog("PuTTY Log to File").WinButton("btn_Yes").Highlight
		Dialog("PuTTY Log to File").WinButton("btn_Yes").Click
	End If
	Wait(2)
	If TeWindow("TeWindow").Exist(2) Then
		rptWriteReport "Pass", "Checking for emulator" , "Emulator window is displayed"
		fnReportStepALM "Emulator window","Passed","Emulator window display","Emulator window should be displayed","Emulator window is displayed"
'	Else
'		rptWriteReport "Fail", "Checking for SystemZ emulator" , "SystemZ window is not displayed"
'		fnReportStepALM "Systemz window","Failed","SystemZ window display","Systemz window should be displayed","Systemz window is not displayed"
'		ExitAction()
	End If	
	Wait(2)
End Function


'************************************************************************************************************************************************
'	Function Name	 	 :		fnNavigateTelnetDrop
'	Objective			 :		Used to Drop shipment into Telnet
'	Input Parameters	 :		NIL
'	Output Parameters	 :		NIL
'	Date Created		 :		05-April-2017
'	QTP Version			 :		11.0
'	QC Version			 :		QC 11.53
'	Pre-requisites		 :		NIL  
'	Created By			 :		Balaji						
'	Modification Date	 :		   
'************************************************************************************************************************************************
Public Function fnNavigateTelnetDrop(DictObj)
	Set objFSO = createobject("Scripting.filesystemobject")
	Set objFile = objFSO.OpenTextFile (StrFrameWorkFolder&"\Resources\Log.txt")
	strSession = objFile.ReadAll	
	Wait(MIN_WAIT)
			If Instr(strSession, "old session") > 0 Then
				TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type "N"
				wait 1
				TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
				rptWriteReport "Pass", "New Session" , "Navigated to new session"
				fnReportStepALM "Navigate Session","Passed","Session Navigate","Should navigate to new session","Navigated to new session"		
			Else
				TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn		
			End If	
			Call fnSynUntilFieldExists(Trim("Ship"),10)
			wait 1
			Set objFSO = createobject("Scripting.filesystemobject")
			Set objFile = objFSO.OpenTextFile(StrFrameWorkFolder&"\Resources\Log.txt")
			sData= objFile.ReadAll	
				If Instr(sData,Trim("Pick"))>=0 Then
					Call rptWriteReport("PASSWITHSCREENSHOT", "Verifying 'Pick field'","'Pick field' is available")
					Call fnReportStepALM("Verifying 'Pick field'","Passed","'Pick field'","'Pick field' should be displayed","'Pick field' is available")
					TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type "5"
					wait 2
					TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
				Else
					Call rptWriteReport ("Fail", "Verifying 'Pick field'","'Pick field' is not available")
					Call fnReportStepALM ("Verifying 'Pick field'","Failed","'Pick field'","'Pick field' should be displayed","'Pick field' is not available")
				End If			
			Call fnSynUntilFieldExists(Trim("Select Organization"),5)
		wait 3
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type DictObj("Organization_Number"&rKey)	
		wait 2
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
		Call fnSynUntilFieldExists(Trim("Ship Confirm"),5)	
		rptWriteReport "Pass", "Enter Organization" , "Entered organization "&DictObj("Organization_Number"&rKey)
		fnReportStepALM "Enter Organization","Passed","Enter Organization","Should Enter Organization","Organization entered "&DictObj("Organization_Number"&rKey)			
End Function
'************************************************************************************************************************************************
'	Function Name	 	 :		fnOpenPuttyLst
'	Objective			 :		Used to open Putty utility and set the configuration
'	Input Parameters	 :		NIL
'	Output Parameters	 :		NIL
'	Date Created		 :		09-Mar-2017
'	QTP Version			 :		11.0
'	QC Version			 :		QC 11.53
'	Pre-requisites		 :		NIL  
'	Created By			 :		Balaji Veeravalli						
'	Modification Date	 :		   
'************************************************************************************************************************************************
Public Function fnOpenPuttyLst(strApp)
	If Window("PuTTY Configuration").Exist(2) Then
		Window("PuTTY Configuration").Close
	ElseIf TeWindow("TeWindow").Exist(2) Then
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micAltDwn + micF4 + micAltUp
		If Dialog("PuTTY Exit Confirmation").Exist Then
			Dialog("PuTTY Exit Confirmation").WinButton("OK").Click
		End If
	End If
	Wait(10)
	Systemutil.Run (StrFrameWorkFolder&"\Resources\putty.exe")
'	Invokeapplication (strProjectResultPath&"\Resources\putty.exe")
	Wait(10)
		If Ucase(strApp) = "SSH" Then
			Window("PuTTY Configuration").WinEdit("txt_HostName").Set "ZQA.test.icd"
			Window("PuTTY Configuration").WinRadioButton("rad_SSH").Set		
		ElseIf Ucase(strApp) = "TELNET" Then		
			Window("PuTTY Configuration").WinEdit("txt_HostName").Set "WMSQA.test.icd"
			Window("PuTTY Configuration").WinRadioButton("rad_Telnet").Set
		End If
	Wait(MID_WAIT)
	Window("PuTTY Configuration").WinTreeView("tvw_Category:").Select "1"
	Wait(MIN_WAIT)
	Window("PuTTY Configuration").WinRadioButton("rad_AllSessionOutput").Set
	Wait(MIN_WAIT)
	Set objFSO = createobject("Scripting.filesystemobject")
	Wait(MID_WAIT)
		If objFSO.FileExists(StrFrameWorkFolder&"\Resources\Log.txt")Then
		   objFSO.DeleteFile(StrFrameWorkFolder&"\Resources\Log.txt")
		   Wait(MIN_WAIT)
		   objFSO.CreateTextFile(StrFrameWorkFolder&"\Resources\Log.txt")
	'	   objFSO.Close
		End If
	Wait(MID_WAIT)
	Window("PuTTY Configuration").WinEdit("txt_LogFileName:").Set StrFrameWorkFolder&"\Resources\Log.txt"
	wait 3
	Window("PuTTY Configuration").WinTreeView("tvw_Category:").Select "Terminal;Keyboard"
	wait 3
	Window("PuTTY Configuration").WinRadioButton("rad_VT100+").Set
	wait 3
	Window("PuTTY Configuration").WinButton("btn_Open").Click
	wait(MID_WAIT)
		If Dialog("PuTTY Log to File").WinButton("btn_Yes").Exist(2) Then
			Dialog("PuTTY Log to File").WinButton("btn_Yes").Highlight
			Dialog("PuTTY Log to File").WinButton("btn_Yes").Click
		End If
	Wait(MID_WAIT)
	If TeWindow("TeWindow").Exist(2) Then
		rptWriteReport "Pass", "Checking for emulator" , "Emulator window is displayed"
		fnReportStepALM "Emulator window","Passed","Emulator window display","Emulator window should be displayed","Emulator window is displayed"
'	Else
'		rptWriteReport "Fail", "Checking for SystemZ emulator" , "SystemZ window is not displayed"
'		fnReportStepALM "Systemz window","Failed","SystemZ window display","Systemz window should be displayed","Systemz window is not displayed"
'		ExitAction()
	End If	
	Wait(MID_WAIT)	
End Function
'************************************************************************************************************************************************
'	Function Name	 	 :		fnPuttyLogin
'	Objective			 :		Used to log into Putty utility for SystemZ
'	Input Parameters	 :		NIL
'	Output Parameters	 :		NIL
'	Date Created		 :		4-Aug-2016
'	QTP Version			 :		11.0
'	QC Version			 :		QC 11.53
'	Pre-requisites		 :		NIL  
'	Created By			 :								
'	Modification Date	 :		   
'************************************************************************************************************************************************
Public Function fnPuttyLogin(sUserName, sPassword)
	TeWindow("TeWindow").Activate
	Wait(MIN_WAIT)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type sUserName
	wait 2
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	Wait(MIN_WAIT)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type sPassword
	wait 2
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	Wait(MIN_WAIT)
	If TeWindow("TeWindow").Exist(2) Then
		rptWriteReport "Pass", "SystemZ Login" , "Logged into SystemZ"
		fnReportStepALM "SystemZ Login","Passed","SystemZ Login","User should login to SystemZ","User has logged into SystemZ"
	End If	
	Wait(MIN_WAIT)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type "z"
	wait 1
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	Wait(MIN_WAIT)
End Function

Public Function fnPuttyLoginfnl(sUserName, sPassword)
	TeWindow("TeWindow").Activate	
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type sUserName
	wait 2
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	Wait(MIN_WAIT)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type sPassword
	wait 2
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	If TeWindow("TeWindow").Exist(2) Then
		rptWriteReport "Pass", "SystemZ Login" , "Logged into SystemZ"
		fnReportStepALM "SystemZ Login","Passed","SystemZ Login","User should login to SystemZ","User has logged into SystemZ"
	End If	
	wait 2
	'Commenting as it does not require for nb2 user
'	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type "z"
'	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
'	Wait(2)
End Function


'************************************************************************************************************************************************
'	Function Name	 	 :		fnNavigateGenerateOrder
'	Objective			 :		Used to log into Putty utility
'	Input Parameters	 :		NIL
'	Output Parameters	 :		NIL
'	Date Created		 :		4-Aug-2016
'	QTP Version			 :		11.0
'	QC Version			 :		QC 11.53
'	Pre-requisites		 :		NIL  
'	Created By			 :								
'	Modification Date	 :		   
'************************************************************************************************************************************************

Public Function fnNavigateGenerateOrder(iOrgNumber)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type "chgsyn"
	wait 2
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	Wait(MIN_WAIT)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type iOrgNumber
	wait 2
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	Wait(MIN_WAIT)
	If TeWindow("TeWindow").Exist(2) Then
		rptWriteReport "Pass", "Change Organization" , "Organization changed to "&iOrgNumber
		Call rptWriteReport("PASSWITHSCREENSHOT","Change Organization","Organization changed to"&iOrgNumber)
		fnReportStepALM "Change Organization","Passed","Organization Change","Organization should be changed","Organization is changed to "&iOrgNumber
	End If
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	wait 1
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type "1"		
	wait 1
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	Wait(MIN_WAIT)
	If TeWindow("TeWindow").Exist(2) Then
		rptWriteReport "Pass", "Pick ticket menu" , "Pick ticket menu is displayed "
		Call rptWriteReport("PASSWITHSCREENSHOT", "Pick ticket menu" , "Pick ticket menu is displayed ")
		fnReportStepALM "Pick ticket","Passed","Pick ticket Screen","Pick ticket Screen should display","Pick ticket Screen is displayed"
	End If
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type "1"
	wait 1
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	Wait(MIN_WAIT)
	If TeWindow("TeWindow").Exist(2) Then
		rptWriteReport "Pass", "Customer Screen" , "Customer Screen is opened "
		fnReportStepALM "Customer Screen","Passed","Customer Screen display","Customer Screen should display","Customer Screen is displayed"
	End If	
End Function

Public Function fnNavigateGenerateOrderfnl(iOrgNumber)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type "chgsyn"
	wait 2
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	wait 2
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type iOrgNumber
	wait 1
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	wait 2
	If TeWindow("TeWindow").Exist(2) Then
		rptWriteReport "Pass", "Change Organization" , "Organization changed to "&iOrgNumber
		Call rptWriteReport("PASSWITHSCREENSHOT","Change Organization","Organization changed to"&iOrgNumber)
		fnReportStepALM "Change Organization","Passed","Organization Change","Organization should be changed","Organization is changed to "&iOrgNumber
	End If
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	wait 1
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type "1"		
	wait 1
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	wait 2
	If TeWindow("TeWindow").Exist(2) Then
		rptWriteReport "Pass", "Pick ticket menu" , "Pick ticket menu is displayed "
		Call rptWriteReport("PASSWITHSCREENSHOT", "Pick ticket menu" , "Pick ticket menu is displayed ")
		fnReportStepALM "Pick ticket","Passed","Pick ticket Screen","Pick ticket Screen should display","Pick ticket Screen is displayed"
	End If
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type "1"
	wait 1
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	wait 2
	If TeWindow("TeWindow").Exist(2) Then
		rptWriteReport "Pass", "Customer Screen" , "Customer Screen is opened "
		fnReportStepALM "Customer Screen","Passed","Customer Screen display","Customer Screen should display","Customer Screen is displayed"
	End If	
End Function

'************************************************************************************************************************************************
'	Function Name	 	 :		fnCreateOrder
'	Objective			 :		Used to log into Putty utility
'	Input Parameters	 :		NIL
'	Output Parameters	 :		NIL
'	Date Created		 :		5-Aug-2016
'	QTP Version			 :		11.0
'	QC Version			 :		QC 11.53
'	Pre-requisites		 :		NIL  
'	Created By			 :								
'	Modification Date	 :		   
'************************************************************************************************************************************************
Public Function fnCreateOrder(iCustomerNo, iProductNo, iQuantity)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type iCustomerNo	
	wait 1
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	Wait(MIN_WAIT)
	If TeWindow("TeWindow").Exist(2) Then
		rptWriteReport "Pass", "Customer Number" , "Customer number is entered "&iCustomerNo
		Call rptWriteReport("PASSWITHSCREENSHOT", "Customer Number" , "Customer number is entered "&iCustomerNo)
		fnReportStepALM "Customer number ","Passed","Enter Customer Number","Customer Number should be entered","Customer Number is entered "&iCustomerNo
	End If
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type iProductNo
	wait 1
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn	
	Wait(MIN_WAIT)
	If TeWindow("TeWindow").Exist(2) Then
		rptWriteReport "Pass", "Product Number" , "Product number is entered "&iProductNo
		Call rptWriteReport("PASSWITHSCREENSHOT", "Product number" , "Product number is entered "&iProductNo)
		fnReportStepALM "Product number ","Passed","Enter Product Number","Product Number should be entered","Product Number is entered "&iProductNo
	End If
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type iQuantity
	Wait(MIN_WAIT)
	If TeWindow("TeWindow").Exist(2) Then
		rptWriteReport "Pass", "Quantity Number" , "Quantity is entered "&iQuantity
		fnReportStepALM "Quantity ","Passed","Enter Quantity "," Quantity should be entered"," Quantity is entered "&iQuantity
		Call rptWriteReport("PASSWITHSCREENSHOT", "Enter Quantity" , " Quantity is entered "&iQuantity)
	End If
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn	
	Wait(MIN_WAIT)		
'	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn	
'	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn	
	Set objFSO = createobject("Scripting.filesystemobject")
	set objFile = objFSO.OpenTextFile (StrFrameWorkFolder&"\Resources\Log.txt")
	strData = objFile.ReadAll
		If Instr(strData, "Generate a transfer request") > 0 then
			TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type "Y"
		ElseIf Instr(strData,"Will this be a booking order") >0 Then
			TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type "N"
			wait 1
'			TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
		Else
			TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
		End If	
	Wait(MID_WAIT)
End Function

'************************************************************************************************************************************************
'	Function Name	 	 :		fnCreateOrderGenericSales
'	Objective			 :		Used to log into Putty utility
'	Input Parameters	 :		NIL
'	Output Parameters	 :		NIL
'	Date Created		 :		5-Aug-2016
'	QTP Version			 :		11.0
'	QC Version			 :		QC 11.53
'	Pre-requisites		 :		NIL  
'	Created By			 :								
'	Modification Date	 :		   
'************************************************************************************************************************************************
Public Function fnCreateOrderGenericSales(iCustomerNo, iProductNo, iQuantity)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type iCustomerNo	
	wait 2
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	Wait(MIN_WAIT)
	If TeWindow("TeWindow").Exist(2) Then
		rptWriteReport "Pass", "Customer Number" , "Customer number is entered "&iCustomerNo
		Call rptWriteReport("PASSWITHSCREENSHOT", "Customer Number" , "Customer number is entered "&iCustomerNo)
		fnReportStepALM "Customer number ","Passed","Enter Customer Number","Customer Number should be entered","Customer Number is entered "&iCustomerNo
	End If
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type iProductNo
	wait 2
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn	
	Wait(MIN_WAIT)
	If TeWindow("TeWindow").Exist(2) Then
		rptWriteReport "Pass", "Product Number" , "Product number is entered "&iProductNo
		Call rptWriteReport("PASSWITHSCREENSHOT", "Product number" , "Product number is entered "&iProductNo)
		fnReportStepALM "Product number ","Passed","Enter Product Number","Product Number should be entered","Product Number is entered "&iProductNo
	End If
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type iQuantity
	Wait(MIN_WAIT)
	If TeWindow("TeWindow").Exist(2) Then
		rptWriteReport "Pass", "Quantity Number" , "Quantity is entered "&iQuantity
		fnReportStepALM "Quantity ","Passed","Enter Quantity "," Quantity should be entered"," Quantity is entered "&iQuantity
		Call rptWriteReport("PASSWITHSCREENSHOT", "Enter Quantity" , " Quantity is entered "&iQuantity)
	End If
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn	
	Wait(MIN_WAIT)
	
	Set objFSO = createobject("Scripting.filesystemobject")''''Added by Pradeep on 6th July. Code to Press Y for booking order
	set objFile = objFSO.OpenTextFile (StrFrameWorkFolder&"\Resources\Log.txt")
	strData = objFile.ReadAll
	If Instr(strData, "Will this be a booking order") > 0 AND Instr(Ucase(Environment.Value("ActionName")),"ISO")>0 then
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type "Y":Wait 2
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn:Wait(MIN_WAIT)
	End If	
	
	Set objFSO = createobject("Scripting.filesystemobject")
	set objFile = objFSO.OpenTextFile (StrFrameWorkFolder&"\Resources\Log.txt")
	strData = objFile.ReadAll
		If Instr(strData, "Generate a transfer") > 0 then
			TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type "Y"
		ElseIf Instr(strData,"Will this be a booking order") >0 Then
			TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type "N"
			wait 1
''			TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
		Else
			TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
		End If	
'	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type "Y"
'	Wait(MIN_WAIT)
''	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn	
'	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn	
'	Set objFSO = createobject("Scripting.filesystemobject")
'	set objFile = objFSO.OpenTextFile (StrFrameWorkFolder&"\Resources\Log.txt")
'	strData = objFile.ReadAll
'	intGenerateTransfer= Instr(strData, "Generate a transfer")
'	If intGenerateTransfer > 0 then
'		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type "Y"
'	End If
	Wait(MIN_WAIT)
End Function

'************************************************************************************************************************************************
'	Function Name	 	 :		fnSubmitOrderGenericSalesOrderLTL
'	Objective			 :		Used to submit the order in Putty
'	Input Parameters	 :		NIL
'	Output Parameters	 :		NIL
'	Date Created		 :		23-Mar-2017
'	QTP Version			 :		12.0
'	QC Version			 :		QC 11.53
'	Pre-requisites		 :		NIL  
'	Created By			 :		Balaji Veeravalli						
'	Modification Date	 :		   
'************************************************************************************************************************************************
Public Sub fnSubmitOrderGenericSalesOrderLTL(DictObj)
	Set objFSO = createobject("Scripting.filesystemobject")
	set objFile = objFSO.OpenTextFile (StrFrameWorkFolder&"\Resources\Log.txt")
	strDataMethod = objFile.ReadAll
'	intShip = Instr(strDataMethod, "Shipping Method")
	Wait(MIN_WAIT)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micF1
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync	
		If TeWindow("TeWindow").Exist(2) Then
			rptWriteReport "Pass", "Press F1" , "Presses function key F1 "
			Call rptWriteReport("PASSWITHSCREENSHOT", "Press F1" , "Presses function key F1 ")
			fnReportStepALM "Press F1 ","Passed","Press function key F1 "," Function key F1 should be pressed"," Function key F1 is pressed"
		End If
	Wait(8)	
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micDwn
	wait 1
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type DictObj.Item("ShippingMethod"&rKey) 
	wait 1
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn 
	wait 5
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micDwn
	wait 1
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micDwn
	wait 1
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micDwn
	Wait(MAX_WAIT)
	Set objFSO = createobject("Scripting.filesystemobject")
	set objFile = objFSO.OpenTextFile (StrFrameWorkFolder&"\Resources\Log.txt")
	strData = objFile.ReadAll
	strSubmitLog = Instr(strData, "BOOKED")
		If strSubmitLog > 0 then
			rptWriteReport "Pass", "Checking for order submission" , "Order Submitted"
			Call rptWriteReport("PASSWITHSCREENSHOT", "Checking for order submission" ,"Order Submitted")
			fnReportStepALM "Submit Order","Passed","Order submission from SystemZ","Order should be submitted","Order is submitted"
		Else		
			rptWriteReport "Fail", "Checking for order submission" , "Order is not Submitted"
			fnReportStepALM "Submit Order","Failed","Order submission from SystemZ","Order should be submitted","Order is submitted"
		End If
End Sub
'************************************************************************************************************************************************
'	Function Name	 	 :		fnSubmitOrderGenericSalesOrderFedex
'	Objective			 :		Used to submit the order in Putty
'	Input Parameters	 :		NIL
'	Output Parameters	 :		NIL
'	Date Created		 :		23-Mar-2017
'	QTP Version			 :		12.0
'	QC Version			 :		QC 11.53
'	Pre-requisites		 :		NIL  
'	Created By			 :		Balaji Veeravalli						
'	Modification Date	 :		   
'************************************************************************************************************************************************
Public Sub fnSubmitOrderGenericSalesOrderFedex(DictObj)
	Set objFSO = createobject("Scripting.filesystemobject")
	set objFile = objFSO.OpenTextFile (StrFrameWorkFolder&"\Resources\Log.txt")
	strDataMethod = objFile.ReadAll
'	intShip = Instr(strDataMethod, "Shipping Method")
	Wait(MIN_WAIT)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micF1
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync	
	If TeWindow("TeWindow").Exist(2) Then
		rptWriteReport "Pass", "Press F1" , "Presses function key F1 "
		Call rptWriteReport("PASSWITHSCREENSHOT", "Press F1" , "Presses function key F1 ")
		fnReportStepALM "Press F1 ","Passed","Press function key F1 "," Function key F1 should be pressed"," Function key F1 is pressed"
	End If
	Wait(10)	
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micDwn
	wait 1
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type DictObj.Item("ShippingMethod"&rKey) 
	wait 1
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn 
	Wait(MAX_WAIT)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micDwn
	wait 1
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micDwn
	wait 1
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micDwn
	wait 1
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micDwn
	Wait(MAX_WAIT)
	Set objFSO = createobject("Scripting.filesystemobject")
	set objFile = objFSO.OpenTextFile (StrFrameWorkFolder&"\Resources\Log.txt")
	strData = objFile.ReadAll
	strSubmitLog = Instr(strData, "BOOKED")
		If strSubmitLog > 0 then
			rptWriteReport "Pass", "Checking for order submission" , "Order Submitted"
			Call rptWriteReport("PASSWITHSCREENSHOT", "Checking for order submission" ,"Order Submitted")
			fnReportStepALM "Submit Order","Passed","Order submission from SystemZ","Order should be submitted","Order is submitted"
		Else		
			rptWriteReport "Fail", "Checking for order submission" , "Order is not Submitted"
			fnReportStepALM "Submit Order","Failed","Order submission from SystemZ","Order should be submitted","Order is submitted"
		End If
End Sub


'************************************************************************************************************************************************
'	Function Name	 	 :		fnCreateOrders
'	Objective			 :		Used to log into Putty utility
'	Input Parameters	 :		NIL
'	Output Parameters	 :		NIL
'	Date Created		 :		5-Aug-2016
'	QTP Version			 :		11.0
'	QC Version			 :		QC 11.53
'	Pre-requisites		 :		NIL  
'	Created By			 :								
'	Modification Date	 :		   
'************************************************************************************************************************************************
Public Function fnCreateOrders(iCustomerNo, iProductNo, iQuantity)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type iCustomerNo	
	wait 1
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	Wait(MIN_WAIT)
		If TeWindow("TeWindow").Exist(2) Then
			rptWriteReport "Pass", "Customer Number" , "Customer number is entered "&iCustomerNo
			fnReportStepALM "Customer number ","Passed","Enter Customer Number","Customer Number should be entered","Customer Number is entered "&iCustomerNo
		End If
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type iProductNo
	wait 1
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn	
	Wait(MIN_WAIT)
		If TeWindow("TeWindow").Exist(2) Then
			rptWriteReport "Pass", "Product Number" , "Product number is entered "&iProductNo
			fnReportStepALM "Product number ","Passed","Enter Product Number","Product Number should be entered","Product Number is entered "&iProductNo
		End If
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type iQuantity
	Wait(MIN_WAIT)
		If TeWindow("TeWindow").Exist(2) Then
			rptWriteReport "Pass", "Quantity Number" , "Quantity is entered "&iQuantity
			fnReportStepALM "Quantity ","Passed","Enter Quantity "," Quantity should be entered"," Quantity is entered "&iQuantity
		End If	
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn	
	Wait(MIN_WAIT)
End Function


'************************************************************************************************************************************************
'	Function Name	 	 :		fnCreateOrder1
'	Objective			 :		Used to log into Putty utility
'	Input Parameters	 :		NIL
'	Output Parameters	 :		NIL
'	Date Created		 :		5-Aug-2016
'	QTP Version			 :		11.0
'	QC Version			 :		QC 11.53
'	Pre-requisites		 :		NIL  
'	Created By			 :								
'	Modification Date	 :		   
'************************************************************************************************************************************************
Public Function fnCreateOrder1(iCustomerNo, iProductNo, iQuantity)
	wait(MID_WAIT)		
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type iCustomerNo	
	wait 1
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	Wait(MIN_WAIT)
		If TeWindow("TeWindow").Exist(2) Then
			rptWriteReport "Pass", "Customer Number" , "Customer number is entered "&iCustomerNo
			fnReportStepALM "Customer number ","Passed","Enter Customer Number","Customer Number should be entered","Customer Number is entered "&iCustomerNo
		End If
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type iProductNo
	wait 1
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn	
	Wait(MIN_WAIT)
		If TeWindow("TeWindow").Exist(2) Then
			rptWriteReport "Pass", "Product Number" , "Product number is entered "&iProductNo
			fnReportStepALM "Product number ","Passed","Enter Product Number","Product Number should be entered","Product Number is entered "&iProductNo
		End If
		intOutProductQty=fnProductValuefromPutty()
		If intOutProductQty-1 > 0 Then
			Qty=intOutProductQty-1
		End If	
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type Qty
	Wait(MIN_WAIT)
		If TeWindow("TeWindow").Exist(2) Then
			rptWriteReport "Pass", "Quantity Number" , "Quantity is entered "&Qty
			fnReportStepALM "Quantity ","Passed","Enter Quantity "," Quantity should be entered"," Quantity is entered "&Qty
		End If
	
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn	
	Wait(MIN_WAIT)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn	
	wait 1
	Set objFSO = createobject("Scripting.filesystemobject")
	set objFile = objFSO.OpenTextFile (StrFrameWorkFolder&"\Resources\Log.txt")
	strData = objFile.ReadAll
'	If Instr(strData, "Generate a transfer") = 0 then
		If Instr(strData, "Generate") = 0 then
			TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
		End If
	Wait(MAX_WAIT)
End Function

'************************************************************************************************************************************************
'	Function Name	 	 :		fnSubmitOrder
'	Objective			 :		Used to submit the order in Putty
'	Input Parameters	 :		NIL
'	Output Parameters	 :		NIL
'	Date Created		 :		5-Aug-2016
'	QTP Version			 :		11.0
'	QC Version			 :		QC 11.53
'	Pre-requisites		 :		NIL  
'	Created By			 :								
'	Modification Date	 :		   
'************************************************************************************************************************************************

Public Function fnSubmitOrder()
	Set objFSO = createobject("Scripting.filesystemobject")
	set objFile = objFSO.OpenTextFile (StrFrameWorkFolder&"\Resources\Log.txt")
	strData = objFile.ReadAll
	If Instr(strData, "Generate a transfer request") > 0 then
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type "Y"
	End If 
	Set objFile= Nothing
	fnSynUntilFieldExists "Shipping Method", 10
	set objFile = objFSO.OpenTextFile (StrFrameWorkFolder&"\Resources\Log.txt")
	strDataMethod = objFile.ReadAll
	intShip = Instr(strDataMethod, "Shipping Method")	
	If intShip > 0 Then
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	End If
	Wait(MIN_WAIT)
	objFile.Close
	Set objFSO= nothing	
	Set objFSO = createobject("Scripting.filesystemobject")
	set objFile = objFSO.OpenTextFile (StrFrameWorkFolder&"\Resources\Log.txt")
	strDataMethod = objFile.ReadAll
	intShip = Instr(strDataMethod, "Are you sure the customer will PICKUP")
	If intShip > 0 Then
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type "Y"
	End If
'	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	Wait(MIN_WAIT)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micF1	
		If TeWindow("TeWindow").Exist(2) Then
			rptWriteReport "Pass", "Press F1" , "Presses function key F1 "
			Call rptWriteReport("PASSWITHSCREENSHOT", "Press F1" , "Presses function key F1 ")
			fnReportStepALM "Press F1 ","Passed","Press function key F1 "," Function key F1 should be pressed"," Function key F1 is pressed"
		End If
	Wait(MAX_WAIT)	
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micDwn	
	wait 1
	'For Creating order with shipping method - narendra (Comment if not required)
'	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type Environment("ShippingMethod")
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	wait 3	
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micDwn
	wait 1
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micDwn
	wait 1
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micDwn
	wait 1
'	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micDwn
'	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micDwn
'	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	Wait(MAX_WAIT)
	Set objFSO = createobject("Scripting.filesystemobject")
	set objFile = objFSO.OpenTextFile (StrFrameWorkFolder&"\Resources\Log.txt")
	strData = objFile.ReadAll
	strSubmitLog = Instr(strData, "BOOKED")
	If strSubmitLog >= 0 then
		rptWriteReport "Pass", "Checking for order submission" , "Order Submitted"
		Call rptWriteReport("PASSWITHSCREENSHOT", "Checking for order submission" ,"Order Submitted")
		fnReportStepALM "Submit Order","Passed","Order submission from SystemZ","Order should be submitted","Order is submitted"
	Else		
		rptWriteReport "Fail", "Checking for order submission" , "Order is not Submitted"
		fnReportStepALM "Submit Order","Failed","Order submission from SystemZ","Order should be submitted","Order is submitted"
	End If
End Function


'************************************************************************************************************************************************
'	Function Name	 	 :		fnSubmitOrderGenericSalesOrder
'	Objective			 :		Used to submit the order in Putty
'	Input Parameters	 :		NIL
'	Output Parameters	 :		NIL
'	Date Created		 :		09-Mar-2017
'	QTP Version			 :		12.0
'	QC Version			 :		QC 11.53
'	Pre-requisites		 :		NIL  
'	Created By			 :		Balaji Veeravalli						
'	Modification Date	 :		   
'************************************************************************************************************************************************
Public Function fnSubmitOrderGenericSalesOrder()
	Set objFSO = createobject("Scripting.filesystemobject")
	set objFile = objFSO.OpenTextFile (StrFrameWorkFolder&"\Resources\Log.txt")
	strDataMethod = objFile.ReadAll
	intShip = Instr(strDataMethod, "Shipping Method")
	Wait(MIN_WAIT)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micF1
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync	
	If TeWindow("TeWindow").Exist(2) Then
		rptWriteReport "Pass", "Press F1" , "Presses function key F1 "
		Call rptWriteReport("PASSWITHSCREENSHOT", "Press F1" , "Presses function key F1 ")
		fnReportStepALM "Press F1 ","Passed","Press function key F1 "," Function key F1 should be pressed"," Function key F1 is pressed"
	End If
	Wait(MID_WAIT)	
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micDwn
	wait 1
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micDwn
	wait 1
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micDwn
	wait 1
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micDwn
	wait 1
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micDwn
	Wait(MAX_WAIT)
	Set objFSO = createobject("Scripting.filesystemobject")
	set objFile = objFSO.OpenTextFile (StrFrameWorkFolder&"\Resources\Log.txt")
	strData = objFile.ReadAll
	strSubmitLog = Instr(strData, "BOOKED")
		If strSubmitLog > 0 then
			rptWriteReport "Pass", "Checking for order submission" , "Order Submitted"
			Call rptWriteReport("PASSWITHSCREENSHOT", "Checking for order submission" ,"Order Submitted")
			fnReportStepALM "Submit Order","Passed","Order submission from SystemZ","Order should be submitted","Order is submitted"
		Else		
			rptWriteReport "Fail", "Checking for order submission" , "Order is not Submitted"
			fnReportStepALM "Submit Order","Failed","Order submission from SystemZ","Order should be submitted","Order is submitted"
		End If
End Function
'************************************************************************************************************************************************
'	Function Name	 	 :		fnSubmitOrderDCDirect
'	Objective			 :		Used to submit the order in Putty
'	Input Parameters	 :		NIL
'	Output Parameters	 :		NIL
'	Date Created		 :		5-Aug-2016
'	QTP Version			 :		11.0
'	QC Version			 :		QC 11.53
'	Pre-requisites		 :		NIL  
'	Created By			 :		Balaji						
'	Modification Date	 :		   
'************************************************************************************************************************************************
Public Function fnSubmitOrderDCDirect()
	Set objFSO = createobject("Scripting.filesystemobject")
	set objFile = objFSO.OpenTextFile (StrFrameWorkFolder&"\Resources\Log.txt")
	strDataMethod = objFile.ReadAll
	intShip = Instr(strDataMethod, "Shipping Method")
	If intShip > 0 Then
	'	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micDwn   '''''Commented by Balaji
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn		
		Wait(MIN_WAIT)		
	End If
'''''Expedit
TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn
Wait 8
	If TeWindow("TeWindow").Exist(2) Then
		rptWriteReport "Pass", "Press F1" , "Presses function key F1 "
		Call rptWriteReport("PASSWITHSCREENSHOT", "Press F1" , "Presses function key F1 ")
		fnReportStepALM "Press F1 ","Passed","Press function key F1 "," Function key F1 should be pressed"," Function key F1 is pressed"
	End If		
	'''''F1   
TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micF1 
TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync
Wait 5
TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micDwn 
wait 1
TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micDwn 
wait 1
TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micDwn 
wait 1
TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micDwn 
Wait 1
TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micDwn 
Wait 1
TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn
Call fnSynUntilFieldExists(Trim("DC DIRECT"),90)
	Set objFSO = createobject("Scripting.filesystemobject")
	set objFile = objFSO.OpenTextFile (StrFrameWorkFolder&"\Resources\Log.txt")
	strData = objFile.ReadAll
	strSubmitLog = Instr(strData, "BOOKED")
	If strSubmitLog > 0 then
		rptWriteReport "Pass", "Checking for order submission" , "Order Submitted"
		Call rptWriteReport("PASSWITHSCREENSHOT", "Checking for order submission" ,"Order Submitted")
		fnReportStepALM "Submit Order","Passed","Order submission from SystemZ","Order should be submitted","Order is submitted"
	Else		
		rptWriteReport "Fail", "Checking for order submission" , "Order is not Submitted"
		fnReportStepALM "Submit Order","Failed","Order submission from SystemZ","Order should be submitted","Order is submitted"
	End If
End Function


Public Function fnSubmitOrders()	
	Wait(MAX_WAIT)
	Set objFSO = createobject("Scripting.filesystemobject")
	set objFile = objFSO.OpenTextFile (StrFrameWorkFolder&"\Resources\Log.txt")
	strData = objFile.ReadAll
	strSubmitLog = Instr(strData, "BOOKED")
	If strSubmitLog > 0 then		
		Call fnReportStepALM("Submit Order", "Passed", "Order submission from System-Z", "Order Should be Submitted","Order is Submiited")
		Call rptWriteReport("PASSWITHSCREENSHOT", "Order submission verification" , "Order is Submiited")
	Else
		Call fnReportStepALM("Submit Order", "Failed", "Order submission from System-Z", "Order Should be Submitted","Order is not Submiited")
		Call rptWriteReport("Fail", "Order submission verification" , "Order is not Submiited")
	End If
End Function

'************************************************************************************************************************************************
'	Function Name	 	 :		fnGetOrderNumber
'	Objective			 :		Used to submit the order in Putty
'	Input Parameters	 :		NIL
'	Output Parameters	 :		NIL
'	Date Created		 :		5-Aug-2016
'	QTP Version			 :		11.0
'	QC Version			 :		QC 11.53
'	Pre-requisites		 :		NIL  
'	Created By			 :								
'	Modification Date	 :		   
'************************************************************************************************************************************************
Public Function fnGetOrderNumber()
	TeWindow("TeWindow").Activate
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micEsc
	Wait(MIN_WAIT)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micAltDwn + micF4 + micAltUp
		If Dialog("PuTTY Exit Confirmation").Exist(2) Then
			Dialog("PuTTY Exit Confirmation").WinButton("OK").Click
		End If
	Set objFSO = createobject("Scripting.filesystemobject")
	set objFile = objFSO.OpenTextFile (StrFrameWorkFolder&"\Resources\Log.txt")
	strData = objFile.ReadAll
'			Wait(MIN_WAIT)
'			strOrderString = Split(strData, "REGULAR")
'			Wait(MIN_WAIT)
'			strOrderNumString = Split(strOrderString(2), "BOOKED")
'			strOrderNo = Mid(Trim(strOrderNumString(1)), 23, 9)
		strOrderString = Split(strData, "ORDER/RSVD")		'-----Added by Balaji Veeravalli
		strOrderStrings=Split(strOrderString(1), "H")
		strOrderNo = Mid(Trim(strOrderStrings(1)),1, 9)
	Wait(MIN_WAIT)
	fnGetOrderNumber = strOrderNo
		If strOrderNo <> "" Then
	'		rptWriteReport "Pass", "Checking for order number creation" , "Order number "&strOrderNo&" created"
			Call rptWriteReport("PASSWITHSCREENSHOT", "Checking for order number creation" , "Order number "&strOrderNo&" created")
			fnReportStepALM "Order Creation","Passed","Order number creation from SystemZ","Order Number should be created","Order Number "&strOrderNo&" is created"
		Else
			rptWriteReport "Fail", "Checking for order number creation" , "Order number "&strOrderNo&" created"
			fnReportStepALM "Order Creation","Failed","Order number creation from SystemZ","Order Number should be created","Order Number is not created"			
		End If	
End Function

'************************************************************************************************************************************************
'	Function Name	 	 :		fnGetOrderNumberGSO
'	Objective			 :		Used to submit the order in Putty
'	Input Parameters	 :		NIL
'	Output Parameters	 :		NIL
'	Date Created		 :		27-Mar-2017
'	QTP Version			 :		11.0
'	QC Version			 :		QC 11.53
'	Pre-requisites		 :		NIL  
'	Created By			 :		Balaji Veeravalli						
'	Modification Date	 :		   
'************************************************************************************************************************************************
Public Function fnGetOrderNumberGSO()
	TeWindow("TeWindow").Activate
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micEsc
	Wait(MIN_WAIT)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micAltDwn + micF4 + micAltUp
	If Dialog("PuTTY Exit Confirmation").Exist(2) Then
		Dialog("PuTTY Exit Confirmation").WinButton("OK").Click
	End If
	Set objFSO = createobject("Scripting.filesystemobject")
	set objFile = objFSO.OpenTextFile (StrFrameWorkFolder&"\Resources\Log.txt")
	strData = objFile.ReadAll
	Wait(MIN_WAIT)
'	strOrderString = Split(strData, "REGULAR")
	strOrderString = Split(strData, "ORDER/RSVD")
	Wait(MIN_WAIT)
	strOrderStrings=Split(strOrderString(1), "H")
	Wait(MIN_WAIT)
	strOrderNo = Mid(Trim(strOrderStrings(1)),1, 9)
	Wait(MIN_WAIT)
	fnGetOrderNumberGSO = trim(strOrderNo)
		If strOrderNo <> "" Then
	'		rptWriteReport "Pass", "Checking for order number creation" , "Order number "&strOrderNo&" created"
			Call rptWriteReport("PASSWITHSCREENSHOT", "Checking for order number creation" , "Order number "&strOrderNo&" created")
			fnReportStepALM "Order Creation","Passed","Order number creation from SystemZ","Order Number should be created","Order Number "&strOrderNo&" is created"
		Else
			rptWriteReport "Fail", "Checking for order number creation" , "Order number "&strOrderNo&" created"
			fnReportStepALM "Order Creation","Failed","Order number creation from SystemZ","Order Number should be created","Order Number is not created"		
		End If	
End Function

'************************************************************************************************************************************************
'	Function Name	 	 :		fnGetTransferOrderNumber
'	Objective			 :		Used to submit the order in Putty
'	Input Parameters	 :		NIL
'	Output Parameters	 :		NIL
'	Date Created		 :		5-Aug-2016
'	QTP Version			 :		11.0
'	QC Version			 :		QC 11.53
'	Pre-requisites		 :		NIL  
'	Created By			 :								
'	Modification Date	 :		   
'************************************************************************************************************************************************

Public Function fnGetTransferOrderNumber()
	If TeWindow("TeWindow").Exist(2) Then
		TeWindow("TeWindow").Activate
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micEsc
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micAltDwn + micF4 + micAltUp
		If Dialog("PuTTY Exit Confirmation").Exist Then
			Dialog("PuTTY Exit Confirmation").WinButton("OK").Click
		End If
	End If	
	
	
	Set objFSO = createobject("Scripting.filesystemobject")
	set objFile = objFSO.OpenTextFile (StrFrameWorkFolder&"\Resources\Log.txt")
	strData = objFile.ReadAll
	strOrderString = Split(strData, "BOOKED")
	strOrderNumString = Split(strOrderString(1), "BRANCH TRANSFER")
	strOrderNo = Mid(Trim(strOrderNumString(0)), 8, 9)
	fnGetTransferOrderNumber = strOrderNo
	
	If strOrderNo <> "" Then
		Call rptWriteReport("PASSWITHSCREENSHOT", "Checking for order number creation" ,"Transfer Order number "&strOrderNo&" created")
		fnReportStepALM "Transfer Order Creation","Passed","Transfer Order number creation from SystemZ","Transafer Order Number should be created","Transfer Order Number "&strOrderNo&" is created"
	Else
		rptWriteReport "Fail", "Checking for transfer order number creation" , "Transfer Order number "&strOrderNo&" is not created"
		fnReportStepALM "Transfer Order Creation","Failed","Transfer Order number creation from SystemZ","Transafer Order Number should be created","Order Number is not created"
		
	End If
	
End Function

'************************************************************************************************************************************************
'	Function Name	 	 :		fnValidateTransfer
'	Objective			 :		Used to submit the order in Putty
'	Input Parameters	 :		NIL
'	Output Parameters	 :		NIL
'	Date Created		 :		5-Aug-2016
'	QTP Version			 :		11.0
'	QC Version			 :		QC 11.53
'	Pre-requisites		 :		NIL  
'	Created By			 :								
'	Modification Date	 :		   
'************************************************************************************************************************************************

Public Function fnValidateTransfer()
	
	Set objFSO = createobject("Scripting.filesystemobject")
	set objFile = objFSO.OpenTextFile (StrFrameWorkFolder&"\Resources\Log.txt")
	strData = objFile.ReadAll
	If Instr(strData, "Generate a transfer") > 0 then
		rptWriteReport "Pass", "Checking for Generate a transfer request for the remaining" , "Generate a transfer request for the remaining message is displayed"
		Call rptWriteReport("PASSWITHSCREENSHOT", "Checking for Generate a transfer request for the remaining" , "Generate a transfer request for the remaining message is displayed")
		fnReportStepALM "Transfer Messsage","Passed","Generate a transfer request for the remaining message","Generate a transfer request for the remaining message should be displayed","Generate a transfer request for the remaining message is displayed"
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	Else
		rptWriteReport "Fail", "Checking for Generate a transfer request for the remaining" , "Generate a transfer request for the remaining message is not displayed"
		fnReportStepALM "Transfer Messsage","Failed","Generate a transfer request for the remaining message","Generate a transfer request for the remaining message should be displayed","Generate a transfer request for the remaining message is not displayed"
	End If
	TeWindow("TeWindow").Activate
	'TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type "Y"
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
End Function


'************************************************************************************************************************************************
'	Function Name	 	 :		fnValidateTransferDC
'	Objective			 :		Used to submit the order in Putty
'	Input Parameters	 :		NIL
'	Output Parameters	 :		NIL
'	Date Created		 :		07-Mar-2017
'	QTP Version			 :		11.0
'	QC Version			 :		QC 11.53
'	Pre-requisites		 :		NIL  
'	Created By			 :		Balaji						
'	Modification Date	 :		   
'************************************************************************************************************************************************

Public Function fnValidateTransferDC()	
	Set objFSO = createobject("Scripting.filesystemobject")
	set objFile = objFSO.OpenTextFile (StrFrameWorkFolder&"\Resources\Log.txt")
	strData = objFile.ReadAll
		If Instr(strData, "Generate a transfer") > 0 then
			rptWriteReport "Pass", "Checking for Generate a transfer request for the remaining" , "Generate a transfer request for the remaining message is displayed"
			Call rptWriteReport("PASSWITHSCREENSHOT", "Checking for Generate a transfer request for the remaining" , "Generate a transfer request for the remaining message is displayed")
			fnReportStepALM "Transfer Messsage","Passed","Generate a transfer request for the remaining message","Generate a transfer request for the remaining message should be displayed","Generate a transfer request for the remaining message is displayed"
		Else
			rptWriteReport "Fail", "Checking for Generate a transfer request for the remaining" , "Generate a transfer request for the remaining message is not displayed"
			fnReportStepALM "Transfer Messsage","Failed","Generate a transfer request for the remaining message","Generate a transfer request for the remaining message should be displayed","Generate a transfer request for the remaining message is not displayed"
		End If
	'''''Y
	TeWindow("TeWindow").Activate
TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type "Y"
Wait(10)
End Function

Public Function fnValidateTransferDCfnl()
	Set objFSO = createobject("Scripting.filesystemobject")
	set objFile = objFSO.OpenTextFile (StrFrameWorkFolder&"\Resources\Log.txt")
	strData = objFile.ReadAll
		If Instr(strData, "Generate a transfer") > 0 then
			rptWriteReport "Pass", "Checking for Generate a transfer request for the remaining" , "Generate a transfer request for the remaining message is displayed"
			Call rptWriteReport("PASSWITHSCREENSHOT", "Checking for Generate a transfer request for the remaining" , "Generate a transfer request for the remaining message is displayed")
			fnReportStepALM "Transfer Messsage","Passed","Generate a transfer request for the remaining message","Generate a transfer request for the remaining message should be displayed","Generate a transfer request for the remaining message is displayed"
		Else
			rptWriteReport "Fail", "Checking for Generate a transfer request for the remaining" , "Generate a transfer request for the remaining message is not displayed"
			fnReportStepALM "Transfer Messsage","Failed","Generate a transfer request for the remaining message","Generate a transfer request for the remaining message should be displayed","Generate a transfer request for the remaining message is not displayed"
		End If
	'''''Y
	TeWindow("TeWindow").Activate
TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type "Y"
Wait(5)
End Function


'************************************************************************************************************************************************
'	Function Name	 	 :		fnValidateTransfers
'	Objective			 :		Used to submit the order in Putty
'	Input Parameters	 :		NIL
'	Output Parameters	 :		NIL
'	Date Created		 :		14/Feb/2017  
'	QTP Version			 :		11.0
'	QC Version			 :		QC 11.53
'	Pre-requisites		 :		NIL  
'	Created By			 :		Balaji Veeravalli						
'	Modification Date	 :		 
'************************************************************************************************************************************************
Public Function fnValidateTransfers()
	Set objFSO = createobject("Scripting.filesystemobject")
	set objFile = objFSO.OpenTextFile (StrFrameWorkFolder&"\Resources\Log.txt")
	strData = objFile.ReadAll
		If Instr(strData, "Generate a transfer") > 0 then
			rptWriteReport "Pass", "Checking for Generate a transfer request for the remaining" , "Generate a transfer request for the remaining message is displayed"
			fnReportStepALM "Transfer Messsage","Passed","Generate a transfer request for the remaining message","Generate a transfer request for the remaining message should be displayed","Generate a transfer request for the remaining message is displayed"
		Else
			rptWriteReport "Fail", "Checking for Generate a transfer request for the remaining" , "Generate a transfer request for the remaining message is not displayed"
			fnReportStepALM "Transfer Messsage","Failed","Generate a transfer request for the remaining message","Generate a transfer request for the remaining message should be displayed","Generate a transfer request for the remaining message is not displayed"
		End If
	TeWindow("TeWindow").Activate
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type "N"
	wait 1
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	wait(MID_WAIT)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type "Y"
	wait 1
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
End Function

'************************************************************************************************************************************************
'	Function Name	 	 :		fnOpenTelnetPutty
'	Objective			 :		Used to open Putty utility and set the configuration
'	Input Parameters	 :		NIL
'	Output Parameters	 :		NIL
'	Date Created		 :		4-Aug-2016
'	QTP Version			 :		11.0
'	QC Version			 :		QC 11.53
'	Pre-requisites		 :		NIL  
'	Created By			 :								
'	Modification Date	 :		   
'************************************************************************************************************************************************
Public Function fnOpenTelnetPutty()
	Systemutil.Run (StrFrameWorkFolder&"\Resources\putty.exe")
'	Invokeapplication (strProjectResultPath&"\Resources\putty.exe")
	Window("PuTTY Configuration").WinEdit("txt_HostName").Set "MSQA.test.icd"
	Window("PuTTY Configuration").WinRadioButton("rad_Telnet").Set
	Window("PuTTY Configuration").WinTreeView("tvw_Category:").Select 1
	Window("PuTTY Configuration").WinRadioButton("rad_AllSessionOutput").Set
	Set objFSO = createobject("Scripting.filesystemobject")
	objFSO.DeleteFile(StrFrameWorkFolder&"\Resources\Log.txt")
	Set oJk = objFSO.CreateTextFile(StrFrameWorkFolder&"\Resources\Log.txt")
	oJk.Close
'	set objFile = objFSO.OpenTextFile (StrFrameWorkFolder&"\Resources\Log.txt")	
	Window("PuTTY Configuration").WinEdit("txt_LogFileName:").Set StrFrameWorkFolder&"\Resources\Log.txt"
	Window("PuTTY Configuration").WinTreeView("tvw_Category:").Select 3
	Window("PuTTY Configuration").WinRadioButton("rad_VT100+").Set
	Window("PuTTY Configuration").WinButton("btn_Open").Click
	If Dialog("PuTTY Log to File").Exist Then
		Dialog("PuTTY Log to File").WinButton("btn_Yes").Click
	End If
		If TeWindow("TeWindow").Exist(2) Then
	'		rptWriteReport "Pass", "Checking for Putty window" , "Putty window is displayed"
			Call rptWriteReport("PASSWITHSCREENSHOT", "Checking for Putty window","Putty window is displayed")
			fnReportStepALM "Putty window","Passed","Putty window display","Putty window should be displayed","Putty window is displayed"
		Else
			rptWriteReport "Fail", "Checking for Putty window" , "Putty window is not displayed"
			fnReportStepALM "Putty window","Failed","Putty window display","Putty window should be displayed","Putty window is not displayed"			
		End If
End Function


'************************************************************************************************************************************************
'	Function Name	 	 :		fnTelnetLogin
'	Objective			 :		Used to log into Putty utility
'	Input Parameters	 :		NIL
'	Output Parameters	 :		NIL
'	Date Created		 :		4-Aug-2016
'	QTP Version			 :		11.0
'	QC Version			 :		QC 11.53
'	Pre-requisites		 :		NIL  
'	Created By			 :								
'	Modification Date	 :		   
'************************************************************************************************************************************************

Public Function fnTelnetLogin(sUserName, sPassword)
'	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	Wait 5
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type "3"	'Do not change this. If does not work comeup with your own function
'	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type "2"

	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	Wait 5
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type sUserName
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	Wait 5
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type sPassword
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	Wait 5
'	set objFile = objFSO.OpenTextFile (StrFrameWorkFolder&"\Resources\Log.txt")
'	strData = objFile.ReadAll
'	If Instr(strData, "INDUSTRIAL")  > 1 Then
'		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type "3"
'		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
'	End If
'	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type "N"
'	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
End Function

Public Function fnTelnetLoginlst(sUserName, sPassword)
'	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	Wait(MIN_WAIT)
'	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type "3"
	Wait 2
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type "2"
	
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	Wait 2
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type sUserName
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	Wait 2
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type sPassword
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	Wait 2
'	set objFile = objFSO.OpenTextFile (StrFrameWorkFolder&"\Resources\Log.txt")
'	strData = objFile.ReadAll
'	If Instr(strData, "INDUSTRIAL")  > 1 Then
'		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type "3"
'		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
'	End If
'	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type "N"
'	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
End Function

'************************************************************************************************************************************************
'	Function Name	 	 :		fnTelnetLoginForRMA
'	Objective			 :		Used to log into Putty utility
'	Input Parameters	 :		NIL
'	Output Parameters	 :		NIL
'	Date Created		 :		4-Aug-2016
'	QTP Version			 :		11.0
'	QC Version			 :		QC 11.53
'	Pre-requisites		 :		NIL  
'	Created By			 :								
'	Modification Date	 :		   
'************************************************************************************************************************************************

Public Function fnTelnetLoginForRMA(sUserName, sPassword)
	Wait(MIN_WAIT)
'	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type "3"
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type "2"	
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	Wait(MIN_WAIT)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type sUserName
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	Wait(MIN_WAIT)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type sPassword
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	Wait(MIN_WAIT)
End Function

'************************************************************************************************************************************************
'	Function Name	 	 :		fnNavigatePick
'	Objective			 :		Used to log into Putty utility
'	Input Parameters	 :		NIL
'	Output Parameters	 :		NIL
'	Date Created		 :		4-Aug-2016
'	QTP Version			 :		11.0
'	QC Version			 :		QC 11.53
'	Pre-requisites		 :		NIL  
'	Created By			 :								
'	Modification Date	 :		   
'************************************************************************************************************************************************

Public Function fnNavigatePick(strOrg)	
	Set objFSO = createobject("Scripting.filesystemobject")
'	set objFile = objFSO.OpenTextFile (StrFrameWorkFolder&"\Resources\Log.txt")
	set objFile = objFSO.OpenTextFile (StrFrameWorkFolder&"\Resources\Log.txt")
	strSession = objFile.ReadAll:wait 2	
		If Instr(strSession, "old session") > 0 Then
			TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type "N"
			TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
			rptWriteReport "Pass", "New Session" , "Navigated to new session"
			fnReportStepALM "Navigate Session","Passed","Session Navigate","Should navigate to new session","Navigated to new session"
			Wait(MID_WAIT)			
		End If	
	
	set objFile = objFSO.OpenTextFile (StrFrameWorkFolder&"\Resources\Log.txt")
	strChooseSession = objFile.ReadAll	
		If Instr(strChooseSession, "Choose") > 0 And Instr(strChooseSession, "Pick") = 0  Then
			TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type "1"
			rptWriteReport "Pass", "Pick select" , "selected Pick"
			fnReportStepALM "Pick","Passed","Select Pick","Should select Pick","Selected Pick"		
		End If
	Wait(MIN_WAIT)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type "4"
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn	
	Wait(MIN_WAIT)
	stringOrg = objFile.ReadAll	
		If Instr(stringOrg, "Org") = 0 Then
			TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type "3"
			TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn	
			Wait(MIN_WAIT)
			rptWriteReport "Pass", "Manual Pick select" , "selected Manual Pick"
			fnReportStepALM "Manual Pick","Passed","Select Manual Pick","Should select Manual Pick","Selected Manual Pick"	
		End If	
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type strOrg
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	Wait(MIN_WAIT)
	rptWriteReport "Pass", "Enter Organization" , "Entered organization "&strOrg
	fnReportStepALM "Enter Organization","Passed","Enter Organization","Should Enter Organization","Organization entered "&strOrg
	stringPick = objFile.ReadAll	
		If  Instr(stringPick, "Manual") = 0 And Instr(stringPick, "Equip") = 0 Then
			TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type "3"
			TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn	
			Wait(MIN_WAIT)
		End If
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	Wait(MIN_WAIT)
	stringMan = objFile.ReadAll
		If Instr(stringMan, "Manual") > 0 Then
			TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type "3"
			TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn	
			Wait(MIN_WAIT)
		End If
End Function

'************************************************************************************************************************************************
'	Function Name	 	 :		fnConfirmPick
'	Objective			 :		Used to confirm the pick, function will enter location, itemlog into Putty utility
'	Input Parameters	 :		NIL
'	Output Parameters	 :		NIL
'	Date Created		 :		4-Aug-2016
'	QTP Version			 :		11.0
'	QC Version			 :		QC 11.53
'	Pre-requisites		 :		NIL  
'	Created By			 :								
'	Modification Date	 :		   
'************************************************************************************************************************************************
Public Function fnConfirmPick(intTransaction)	
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type intTransaction
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	Wait(MAX_WAIT)
	rptWriteReport "Pass", "Enter Transaction Number" , "Entered Transaction Number "&intTransaction
	fnReportStepALM "Enter Transaction Number","Passed","Enter Transaction Number","Should Enter Transaction Number","Transaction Number entered "&intTransaction
	Set objFSO = createobject("Scripting.filesystemobject")
'	set objFile = objFSO.OpenTextFile (StrFrameWorkFolder&"\Resources\Log.txt")
	set objFile = objFSO.OpenTextFile (StrFrameWorkFolder&"\Resources\Log.txt")
	strData = objFile.ReadAll
	
	
'	intSub = Instr(strData, "Sub                 :")
'	intLoc = Instr(strData, "Loc                 :")
'	intItemDe = Instr(strData, "Item Desc           :")
'	intItem = Instr(strData, "Item                :")
'	intUOM = Instr(strData, "UOM                 >")
'	intReqQty = Instr(strData, "Req Qty             :")
'	intXferLP = Instr(strData , "Xfer LPN            :")
	
	intSub = Instr(strData, "Sub       :")
	intLoc = Instr(strData, "Loc       :")
	intItemDe = Instr(strData, "Item Desc :")
	intItem = Instr(strData, "Item      :")
	intUOM = Instr(strData, "UOM       >")
	intReqQty = Instr(strData, "Req Qty   :")
	intXferLP = Instr(strData , "Xfer LPN  :")
	
	strSubString = Mid(strData, intSub+21, Cint(intLoc)-Cint(intSub+21))
	strSub = Replace(strSubString, "Confirm             :[7m                                       [0m", "")
	strLocString = Mid(strData, intLoc+21, Cint(intItemDe)-Cint(intLoc+21))
	strLoc = Replace(strLocString, "Confirm             :[7m                                       [0m", "")	
	strItemString = Mid(strData, intItem+21, Cint(intUOM)-Cint(intItem+21))
	strItem = Replace(strItemString, "Confirm             :[7m                                       [0m", "")
	strReqQtyString = Mid(strData, intReqQty+21, Cint(intXferLP)-Cint(intReqQty+21))
	strReqQty = Replace(strReqQtyString, "Confirm             :[7m                                       [0m", "")
	
	
'''''	strSubString = Mid(strData, intSub+8, Cint(intLoc)-Cint(intSub+8))
'''''	strSub = Replace(strSubString, "Confirm:[7m              [0m", "")
'''''	strLocString = Mid(strData, intLoc+8, Cint(intItemDe)-Cint(intLoc+8))
'''''	strLoc = Replace(strLocString, "Confirm:[7m              [0m", "")	
'''''	strItemString = Mid(strData, intItem+8, Cint(intUOM)-Cint(intItem+8))
'''''	strItem = Replace(strItemString, "Confirm:[7m              [0m", "")
'''''	strReqQtyString = Mid(strData, intReqQty+8, Cint(intXferLP)-Cint(intReqQty+8))
'''''	strReqQty = Replace(strReqQtyString, "Confirm:[7m              [0m", "")	
	
	
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type strSub
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type strLoc
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type strItem
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type strReqQty
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micCtrlDwn + "G" + micCtrlUp
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micDwn
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	Wait(MAX_WAIT)
	rptWriteReport "Pass", "Enter Confirmation details" , "Entered Confirmation details "
	fnReportStepALM "Enter Confirmation details","Passed","Enter Confirmation details","Should Enter Confirmation details","Confirmation details entered"
End Function
'************************************************************************************************************************************************
'	Function Name	 	 :		fnConfirmDrop
'	Objective			 :		Used to confirm the pick, function will enter location, itemlog into Putty utility
'	Input Parameters	 :		NIL
'	Output Parameters	 :		NIL
'	Date Created		 :		4-Aug-2016
'	QTP Version			 :		11.0
'	QC Version			 :		QC 11.53
'	Pre-requisites		 :		NIL  
'	Created By			 :								
'	Modification Date	 :		   
'************************************************************************************************************************************************
Public Function fnConfirmDrop()
	Wait(MID_WAIT)
	Set objFSO = createobject("Scripting.filesystemobject")
	set objFile = objFSO.OpenTextFile (StrFrameWorkFolder&"\Resources\Log.txt")
	strData = objFile.ReadAll
	intSub = Instr(strData, "To Sub    :")
	intLoc = Instr(strData, "To Loc    :")
'	intDrop = Instr(strData, "Drop LPN  >")	
'	intDrop = Instr(strData, "<Done>")	
	intDrop = Instr(strData, "Confirm   ]")	
'	strSubString = Mid(strData, intSub+8, Cint(intLoc)-Cint(intSub+11))
	'strSub = Replace(strSubString, "Confirm>[7m              [0m", "")
	strSubString = Mid(strData, intSub+11, Cint(intLoc)-Cint(intSub+11))
	strSub = Replace(strSubString, "Confirm   >[7m                                                 [0m", "")
'	Msgbox strSub
'	strLocString = Mid(strData, intLoc+8, Cint(intDrop)-Cint(intLoc+11))
	strLocString = Mid(strData, intLoc+11, Cint(intDrop)-Cint(intLoc+11))
'	strLoc = Replace(strLocString, "Confirm][7m              [0m", "")	
	strLoc = Replace(strLocString, "Confirm   ][7m                                                 [0m", "")	
'	Msgbox strLoc
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type strSub
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type strLoc
'	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micCtrlDwn + "G" + micCtrlUp	
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	Wait(MID_WAIT)
	rptWriteReport "Pass", "Enter drop details" , "Entered details "
	fnReportStepALM "Enter drop details","Passed","Enter drop details","Should Enter drop details","drop details entered "
End Function

'************************************************************************************************************************************************
'	Function Name	 	 :		fnConfirmShip
'	Objective			 :		Used to confirm the ship
'	Input Parameters	 :		NIL
'	Output Parameters	 :		NIL
'	Date Created		 :		4-Aug-2016
'	QTP Version			 :		11.0
'	QC Version			 :		QC 11.53
'	Pre-requisites		 :		NIL  
'	Created By			 :								
'	Modification Date	 :		   
'************************************************************************************************************************************************
Public Function fnConfirmShip()
	Wait(MID_WAIT)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micF2 ':Wait 2
	Wait(MIN_WAIT)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type "Y"':Wait 2
	Wait(MIN_WAIT)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn':Wait 2
	Wait(MIN_WAIT)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micF2 ':Wait 2
	Wait(MIN_WAIT)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micAltDwn+micReturn+micAltUp
	Wait(MIN_WAIT)	
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micDwn
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type "2"
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn':Wait 1
	
'***********Below code is for shiping with Delivery number'******************************Do not delete**************	
	
'''	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
'''	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type strDeliveryNo
'''	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type strItemNo
'''	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micDwn
'''	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
'''	Wait(MIN_WAIT)
'''	Set objFSO = createobject("Scripting.filesystemobject")
'''	set objFile = objFSO.OpenTextFile (StrFrameWorkFolder&"\Resources\Log.txt")
'''	strData = objFile.ReadAll
'''	intItem = Instr(strData, "Item   :")
'''	intConfirm = Instr(strData, "Confirm>")
'''	strItem = Mid(strData, intItem+8, Cint(intConfirm)-Cint(intLane+8))
'''	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type strItem
'''	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
'''	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
'''	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
'''	Wait(MIN_WAIT)
'''	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
'''	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
'''	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	
	Wait(MIN_WAIT)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	Wait(MIN_WAIT)
	Set objFSO = createobject("Scripting.filesystemobject")
	set objFile = objFSO.OpenTextFile (StrFrameWorkFolder&"\Resources\Log.txt")
	strData = objFile.ReadAll
	intLane = Instr(strData, "Lane   :")
	intConfirm = Instr(strData, "Confirm:")
	strLane = Mid(strData, intLane+8, Cint(intConfirm)-Cint(intLane+8))
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type strLane
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	Wait(MIN_WAIT)
	
	Set objFSO = createobject("Scripting.filesystemobject")
	set objFile = objFSO.OpenTextFile (StrFrameWorkFolder&"\Resources\Log.txt")
	strData = objFile.ReadAll
	intItem = Instr(strData, "Item    :")
	intDesc = Instr(strData, "Desc    :")	
	intReqQty = Instr(strData, "Req Qty :")
	intPicked = Instr(strData, "Picked  :")
	
'''''	intItem = Instr(strData, "Item   :")
'''''	intDesc = Instr(strData, "Desc   :")	
'''''	intReqQty = Instr(strData, "Req Qty:")
'''''	intPicked = Instr(strData, "Picked :")
	
	strItemString = Mid(strData, intItem+9, Cint(intDesc)-Cint(intItem+9))
'	strItem = Replace(strItemString, "Confirm :[7m                                                   [0m", "")
	strItem = Replace(strItemString, "Confirm :[7m                                                   [0m", "")
'	strItem = Replace(strItemString, "Confirm :[7m           [0m", "")
	strQtyString = Mid(strData, intReqQty+9, Cint(intPicked)-Cint(intReqQty+9))
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type Trim(strItem)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn:Wait 1
'	wait(MIN_WAIT)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type Trim(strQtyString)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn:Wait 1
	
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	Wait(MIN_WAIT)
	strData = objFile.ReadAll
	If Instr(strData, "shipped succesfully") > 0 OR Instr(strData, "shipped suc"&VBNEWLINE&"cesfully")>0 Then''condition updated by Pradeep on 27th Apr
		Call rptWriteReport("PASSWITHSCREENSHOT", "Check shipment status","Shipment status is sucessful")
'		rptWriteReport "Pass", "Checking for delivery success message" , "Delivery shipped succesfully message is displayed"
		fnReportStepALM "Delivery success Messsage","Passed","Delivery shipped succesfully message","Delivery shipped succesfully message should be displayed","Delivery shipped succesfully message is displayed"
	Else
		rptWriteReport "Fail", "Checking for delivery success message" , "Delivery shipped succesfully message is not displayed"
		fnReportStepALM "Delivery success Messsage","Failed","Delivery shipped succesfully message","Delivery shipped succesfully message should be displayed","Delivery shipped succesfully message is not displayed"
	End If	
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
End Function



'************************************************************************************************************************************************
'	Function Name	 	 :		fnNavigateCreateOrder
'	Objective			 :		Used to log into Putty utility
'	Input Parameters	 :		NIL
'	Output Parameters	 :		NIL
'	Date Created		 :		17-Aug-2016
'	QTP Version			 :		11.0
'	QC Version			 :		QC 11.53
'	Pre-requisites		 :		NIL  
'	Created By			 :		Balaji Veeravalli						
'	Modification Date	 :		   
'************************************************************************************************************************************************
Public Function fnNavigateCreateOrder(strCName,intPNumber)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type "1"
	wait 2
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	wait 2	
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type "1"
	wait 2
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	wait 2
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type strCName
	wait 2
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	wait 2	
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type intPNumber
	wait 2
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	Wait(MIN_WAIT)	
End Function
'************************************************************************************************************************************************
'	Function Name	 	 :		fnTelnetLogin
'	Objective			 :		Used to log into TelnetLogin
'	Input Parameters	 :		NIL
'	Output Parameters	 :		NIL
'	Date Created		 :		23-Aug-2016
'	QTP Version			 :		12.53
'	QC Version			 :		QC 11.53
'	Pre-requisites		 :		NIL  
'	Created By			 :		Balaji Veeravalli						
'	Modification Date	 :		   
'************************************************************************************************************************************************

'Public Function fnTelnetLogin(sUserName, sPassword)
'
'	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
'	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type sUserName
'	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
'	Wait(MIN_WAIT)
'	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type sPassword
'	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
'	Wait(MIN_WAIT)
'End Function

'************************************************************************************************************************************************
'	Function Name	 	 :		fnReceiptReceive
'	Objective			 :		Used to ReceiptReceive
'	Input Parameters	 :		NIL
'	Output Parameters	 :		NIL
'	Date Created		 :		23-Aug-2016
'	QTP Version			 :		12.53
'	QC Version			 :		QC 11.53
'	Pre-requisites		 :		NIL  
'	Created By			 :		Rajasekhar
'	Modification Date	 :		   
'************************************************************************************************************************************************

Public Sub fnReceiptReceive(DictObj)
On error resume next
	Wait(MIN_WAIT)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn 
	Wait(MIN_WAIT)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn 
	Wait(MIN_WAIT)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn 
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type DictObj("OrganizationNumber"&rKey)
	Wait(MIN_WAIT)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	Wait(MIN_WAIT)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type DictObj("ASNnumber"&rKey) 
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	Wait(MIN_WAIT)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type DictObj("ASNitem"&rKey)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	Wait(MIN_WAIT)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	Wait(MIN_WAIT)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micCtrlDwn+ "G" + micCtrlUp
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	Wait(MIN_WAIT)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micCtrlDwn+ "L" + micCtrlUp
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	Wait(MIN_WAIT)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micCtrlDwn+ "L" + micCtrlUp
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	Wait(MIN_WAIT)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type DictObj("Quantity"&rKey)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	Wait(MIN_WAIT)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micDwn
	Wait(MIN_WAIT)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	Wait(6)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	Wait(MIN_WAIT)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	Wait(MIN_WAIT)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	Wait(MIN_WAIT)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	Wait(MIN_WAIT)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	Wait(MIN_WAIT)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	wait(8)
End Sub


'************************************************************************************************************************************************
'	Function Name	 	 :		fntoGetTelnetRcptNumber
'	Objective			 :		Used to get telenet Rcpt Number
'	Input Parameters	 :		NIL
'	Output Parameters	 :		NIL
'	Date Created		 :		23-Aug-2016
'	QTP Version			 :		12.53
'	QC Version			 :		QC 11.53
'	Pre-requisites		 :		NIL  
'	Created By			 :		Balaji Veeravalli						
'	Modification Date	 :		   
'************************************************************************************************************************************************
Public Function fntoGetTelnetRcptNumber()
	On error resume next
	Set objFSO = CreateObject("Scripting.FileSystemObject")
	Set objTextFile = objFSO.OpenTextFile(StrFrameWorkFolder&"\Resources\Log.txt",1)
	Set objTextFile1 = objFSO.OpenTextFile(StrFrameWorkFolder&"\Resources\Log.txt",1)
		strval="Rcpt Nu:"
		strFileText= objTextFile.ReadAll
			If Instr(1,strFileText,strval)>0 Then
				Do While objTextFile1.AtEndOfStream = False
					strNextLine = objTextFile1.Readline
						If Instr(1,strNextLine,strval)>0 Then
								arrServiceList = Split(strNextLine ,strval)
							sRcptNo=arrServiceList(1)
						Exit Do
					End If				
				Loop 
			Else
				print "Provided Input file doesnt available"
			End If
'fntoGetTelnetRcptNumber=sRcptNo
	If isnumeric(sRcptNo)=True and sRcptNo<>empty and sRcptNo<>"" Then
		rptWriteReport "Pass", "Receipt Number" , "Receipt Number is created sucessfully with number....'"&sRcptNo
		call fnReportStepALM("Receipt Number","Passed","Receipt Number creation verification","Receipt Number must be created","Receipt Number is created sucessfully with...."&sRcptNo)
	Else
		rptWriteReport "Fail", "Receipt Number#" , "Oracle Order number is created sucessfully"
		call fnReportStepALM("Receipt Number","Failed","Receipt Number creation verification","Receipt Number must be created","Receipt Number is not created sucessfully with...."&sRcptNo)
		fnUploadReport strProjectResultPath&"\"&Environment("FolderName"), strProjectResultPath&"\"&Environment("FolderName")
		ExitAction()
	End If	
set objFSO=nothing
set objTextFile=nothing
set objTextFile1=nothing
	
End Function
'************************************************************************************************************************************************
'	Function Name	 	 :		fnVerificationASNatTelnet
'	Objective			 :		Used to verifiy ASN creation
'	Input Parameters	 :		NIL
'	Output Parameters	 :		NIL
'	Date Created		 :		23-Aug-2016
'	QTP Version			 :		12.53
'	QC Version			 :		QC 11.53
'	Pre-requisites		 :		NIL  
'	Created By			 :		Balaji Veeravalli						
'	Modification Date	 :		   
'************************************************************************************************************************************************
Public Function fnVerificationASNatTelnet()
On error resume next
	Set objFSO = CreateObject("Scripting.FileSystemObject")
		Set objTextFile = objFSO.OpenTextFile(StrFrameWorkFolder&"\Resources\Log.txt",1)
		Set objTextFile1 = objFSO.OpenTextFile(StrFrameWorkFolder&"\Resources\Log.txt",1)
			strval=trim("Txn Success.")
			strFileText= objTextFile.ReadAll
				If Instr(1,strFileText,strval)>0 Then	
					rptWriteReport "Pass", "'ASN Creation'" , "ASN is created sucessfully with message of ......'" & strval
					Call fnUploadReportfnReportStepALM("'ASN Creation'","Passed","'ASN Creation' verification","'ASN Creation' must be created","'ASN Creation' is created sucessfully ..."&strval)
				Else
					rptWriteReport "Fail", "Receipt Number#" , "Oracle Order number is created sucessfully"
					Call fnReportStepALM("'ASN Creation'","Failed","'ASN Creation' verification","'ASN Creation' must be created","'ASN Creation' is not created sucessfully ..."&strval)
					fnUploadReport strProjectResultPath&"\"&Environment("FolderName"), strProjectResultPath&"\"&Environment("FolderName")
					ExitAction()
				End If	
set objFSO=nothing
set objTextFile=nothing
set objTextFile1=nothing
End Function

'************************************************************************************************************************************************
'	Function Name	 	 :		fnNavigateCreateOrderISO
'	Objective			 :		Used to log into Putty utility
'	Input Parameters	 :		NIL
'	Output Parameters	 :		NIL
'	Date Created		 :		24-Aug-2016
'	QTP Version			 :		12.53
'	QC Version			 :		ALM 11.53
'	Pre-requisites		 :		NIL  
'	Created By			 :		Balaji Veeravalli						
'	Modification Date	 :		     
'************************************************************************************************************************************************
Public Function fnNavigateCreateOrderISO(iOrganization)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type "chgsyn"
	wait 1
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	wait 1
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type iOrganization
	wait 1
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	wait 1
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	wait 1
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type "1"		
	wait 1
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	wait 1
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type "1"
	wait 1
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	Wait(MIN_WAIT)
End Function
'************************************************************************************************************************************************
'	Function Name	 	 :		fnCreateOrderVDS
'	Objective			 :		Used to log into Putty utility
'	Input Parameters	 :		NIL
'	Output Parameters	 :		NIL
'	Date Created		 :		18-Aug-2016
'	QTP Version			 :		12.53
'	QC Version			 :		ALM 11.53
'	Pre-requisites		 :		NIL  
'	Created By			 :		Balaji Veeravalli						
'	Modification Date	 :		   
'************************************************************************************************************************************************
Public Function fnCreateOrderVDS(strCustomerName,intPurchaseNumber)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type strCustomerName	
	wait 1
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	wait 1
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	wait 1
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type intPurchaseNumber
	Wait(MID_WAIT)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	Wait(MIN_WAIT)
'	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
End Function

'************************************************************************************************************************************************
'	Function Name	 	 :		fnProductQty
'	Objective			 :		Used to log into Putty utility
'	Input Parameters	 :		NIL
'	Output Parameters	 :		NIL
'	Date Created		 :		18-Aug-2016
'	QTP Version			 :		12.53
'	QC Version			 :		ALM 11.53
'	Pre-requisites		 :		NIL  
'	Created By			 :		Balaji Veeravalli						
'	Modification Date	 :		   
'************************************************************************************************************************************************
Public Function fnProductQty(intQTY)
'	wait(MID_WAIT)
'	intOutProductQty=fnProductValuefromPutty()
'	If cint(intQTY)<cint(intOutProductQty) Then
'			intOutProductQty=intOutProductQty+1
'		Else
'			intOutProductQty=intQTY
'	End If

'	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type intOutProductQty
	Wait(MIN_WAIT)
'	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn	
	'''''''''''''
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type "N"
	wait 1
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type "Y"
	wait 1
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type "R"
	wait 1
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	wait 1
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micF1
wait 1	
TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
wait 1
TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
wait 1
TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
wait 1
TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
wait 1
TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
wait 1
End Function

'************************************************************************************************************************************************
'	Function Name	 	 :		fnRMAType
'	Objective			 :		Used to create RMA 
'	Input Parameters	 :		NIL
'	Output Parameters	 :		NIL
'	Date Created		 :		10-Mar-2017
'	QTP Version			 :		12.53
'	QC Version			 :		ALM 11.53
'	Pre-requisites		 :		NIL  
'	Created By			 :		Rajasekhar					
'	Modification Date	 :		   
'************************************************************************************************************************************************
Public Function fnRMAType()
	Wait(MIN_WAIT)
	'''''''''''''
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type "R"
	Wait(MIN_WAIT)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	Wait(MIN_WAIT)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	Wait(MIN_WAIT)
	
	''''Invoice & PO
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	Wait(MIN_WAIT)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	Wait(MIN_WAIT)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type "N"
	Wait(MIN_WAIT)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type "Y"
	Wait(MIN_WAIT)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	Wait(MIN_WAIT)	
TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micF1
Wait(MIN_WAIT)
TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
Wait(MIN_WAIT)
TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
Wait(MIN_WAIT)
TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
Wait(MIN_WAIT)
TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
Wait(MIN_WAIT)
TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
Wait(MIN_WAIT)
End Function



'   ******************************************************************************************************************************************************************************************************************************************
'	Sub Name		 					:					fnProductValuefromPutty
'	Objective							:					Used to search Product value from putty Log
'	Input Parameters					:					Nil
'	Output Parameters					:					NIL
'	Date Created						:					23/Aug/2016
'	QTP Version							:					UFT 12.53
'	Module Name							:					E2E
'	Pre-requisites						:					NILL    
'	Created By							:					Balaji Veeravalli
'	Modification Date					:		   
'******************************************************************************************************************************************************************************************************************************************		
Public Function fnProductValuefromPutty()
On error resume next
Set objFSO = CreateObject("Scripting.FileSystemObject")
Set objTextFile = objFSO.OpenTextFile(StrFrameWorkFolder&"\Resources\Log.txt",1)
Set objTextFile1 = objFSO.OpenTextFile(StrFrameWorkFolder&"\Resources\Log.txt",1)
strval="Local Plus"
strFileText= objTextFile.ReadAll
'print strFileText
If Instr(1,strFileText,strval)>0 Then
	Do While objTextFile1.AtEndOfStream = False
		strNextLine = objTextFile1.Readline
		If Instr(1,strNextLine,strval)>0 Then
			arrServiceList = Split(strNextLine ,strval)
			If Ubound(arrServiceList)>0 Then
				arrPOs=Split(arrServiceList(0) ," ")
				If Ubound(arrPOs)>0 Then
					arrPONumber=Split(arrPOs(ubound(arrPOs)),"[")
					If Ubound(arrPONumber)>0 Then
'						print arrPONumber(0)
'						msgbox Left(arrPONumber(0),len(arrPONumber(0))-1)
					intProductNo=Left(arrPONumber(0),len(arrPONumber(0))-1)
					End If
				End If				
				Exit Do
			End If			
		End If		
	Loop 
Else
	print "Provided Input file doesnt contain Local Plus"
End If
set objFSO=nothing
set objTextFile=nothing
set objTextFile1=nothing
fnProductValuefromPutty=intProductNo
If isnumeric(intProductNo)=True and intProductNo<>empty and intProductNo<>"" Then
		rptWriteReport "Pass", "Oracle Order#" , "Oracle Order number is created sucessfully..."& intProductNo
		call fnReportStepALM("Oracle Order#","Passed","Oracle Order# creation verification","Oracle Order# must be created","Oracle Order# is created sucessfully with...."&intProductNo)
	Else
		rptWriteReport "Fail", "Oracle Order#" , "Oracle Order number is not created sucessfully..."& intProductNo
		call fnReportStepALM("Oracle Order#","Passed","Oracle Order# creation verification","Oracle Order# must be created","Oracle Order# is not created sucessfully with....")
		fnUploadReport strProjectResultPath&"\"&Environment("FolderName"), strProjectResultPath&"\"&Environment("FolderName")
		ExitAction()
	End If	
End Function

'************************************************************************************************************************************************
'	Function Name	 	 :		fnProductQtyDC
'	Objective			 :		Used to log into Putty utility
'	Input Parameters	 :		NIL
'	Output Parameters	 :		NIL
'	Date Created		 :		18-Aug-2016
'	QTP Version			 :		12.53
'	QC Version			 :		ALM 11.53
'	Pre-requisites		 :		NIL  
'	Created By			 :		Balaji Veeravalli						
'	Modification Date	 :		   
'************************************************************************************************************************************************
Public Function fnProductQtyDC(intQTY)
On error resume next
'	wait(MID_WAIT)
'	intOutProductQty=fnProductValuefromPutty()
'	If cint(intQTY)<=cint(intOutProductQty) Then
'			intOutProductQty=intOutProductQty+1
'		Else
'			intOutProductQty=intQTY
'	End If
	Wait(MIN_WAIT)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type intOutProductQty
	Wait(MIN_WAIT)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn	
	'''''''''''''
	Wait(MID_WAIT)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type "Y"
	Wait(MID_WAIT)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn	
	Wait(MID_WAIT)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn	
	Wait(MID_WAIT)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micF1
	Wait(MID_WAIT)	
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	wait 1
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	wait 1
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	wait 1
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	wait 1
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
WAIT(8)
End Function
'   ******************************************************************************************************************************************************************************************************************************************
'	Sub Name		 					:					fnProductNumberSearchfromPutty
'	Objective							:					Used to search Product number from putty Log
'	Input Parameters					:					Nil
'	Output Parameters					:					NIL
'	Date Created						:					23/Aug/2016
'	QTP Version							:					UFT 12.53
'	Module Name							:					E2E
'	Pre-requisites						:					NILL    
'	Created By							:					Balaji Veeravalli
'	Modification Date					:		   
'******************************************************************************************************************************************************************************************************************************************		
Public Function fnProductNumberSearchfromPutty()
	On error resume next
	Set objFSO = CreateObject("Scripting.FileSystemObject")
Set objTextFile = objFSO.OpenTextFile(StrFrameWorkFolder&"\Resources\Log.txt",1)
Set objTextFile1 = objFSO.OpenTextFile(StrFrameWorkFolder&"\Resources\Log.txt",1)
	strval="TOGGLE ORDER/"
	strFileText= objTextFile.ReadAll
If Instr(1,strFileText,strval)>0 Then
	Do While objTextFile1.AtEndOfStream = False
		strNextLine = objTextFile1.Readline
		If Instr(1,strNextLine,strval)>0 Then
			arrServiceList = Split(strNextLine ,strval)
			If Ubound(arrServiceList)>0 Then
				arrPOs=Split(arrServiceList(1) ,";")
				If Ubound(arrPOs)>0 Then
					arrPONumber=Split(arrPOs(1)," ")
					If Ubound(arrPONumber)>0 Then
				intProductNo=Right(arrPONumber(0),len(arrPONumber(0))-2)
					End If
				End If				
				Exit Do
			End If			
		End If		
	Loop 
Else
	print "Provided Input file doesnt contain Local Plus"
End If
set objFSO=nothing
set objTextFile=nothing
set objTextFile1=nothing
'fnProductNumberSearchfromPutty=intProductNo
	If isnumeric(intProductNo)=True and intProductNo<>empty and intProductNo<>"" Then
		rptWriteReport "Pass", "Oracle Order#" , "Oracle Order number is created sucessfully..."& intProductNo
		call fnReportStepALM("Oracle Order#","Passed","Oracle Order# creation verification","Oracle Order# must be created","Oracle Order# is created sucessfully with...."&intProductNo)
	Else
		rptWriteReport "Fail", "Oracle Order#" , "Oracle Order number is not created sucessfully..."& intProductNo
		call fnReportStepALM("Oracle Order#","Passed","Oracle Order# creation verification","Oracle Order# must be created","Oracle Order# is not created sucessfully with....")
		fnUploadReport strProjectResultPath&"\"&Environment("FolderName"), strProjectResultPath&"\"&Environment("FolderName")
		ExitAction()
	End If	
End Function
'   ******************************************************************************************************************************************************************************************************************************************
'	Sub Name		 					:					fnGetOrderNumberDCDirect
'	Objective							:					Used to get SystemZ DC direct order number
'	Input Parameters					:					Nil
'	Output Parameters					:					NIL
'	Date Created						:					01/Mar/2017
'	QTP Version							:					UFT 12.53
'	Module Name							:					E2E
'	Pre-requisites						:					NILL    
'	Created By							:					Balaji Veeravalli
'	Modification Date					:		   
'******************************************************************************************************************************************************************************************************************************************		

Public Function fnGetOrderNumberDCDirect(DictObj)
	TeWindow("TeWindow").Activate
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micEsc
	Wait(MIN_WAIT)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micAltDwn + micF4 + micAltUp
		If Dialog("PuTTY Exit Confirmation").Exist(2) Then
			Dialog("PuTTY Exit Confirmation").WinButton("OK").Click
		End If
			Set objFSO = createobject("Scripting.filesystemobject")
			set objFile = objFSO.OpenTextFile (StrFrameWorkFolder&"\Resources\Log.txt")
			strData = objFile.ReadAll
	Wait(MIN_WAIT)
	strOrderString = Split(strData, "DC DIRECT")
	Wait(MIN_WAIT)
	strOrderNumString = Split(strOrderString(2), "BOOKED")
	strOrderNo = Mid(Trim(strOrderNumString(1)), 23, 9)
	Wait(MIN_WAIT)
	fnGetOrderNumberDCDirect = strOrderNo
		If strOrderNo <> "" Then
	'		rptWriteReport "Pass", "Checking for order number creation" , "Order number "&strOrderNo&" created"
			Call rptWriteReport("PASSWITHSCREENSHOT", "Checking for order number creation" , "Order number "&strOrderNo&" created")
			fnReportStepALM "Order Creation","Passed","Order number creation from SystemZ","Order Number should be created","Order Number "&strOrderNo&" is created"
		Else
			rptWriteReport "Fail", "Checking for order number creation" , "Order number "&strOrderNo&" created"
			fnReportStepALM "Order Creation","Failed","Order number creation from SystemZ","Order Number should be created","Order Number is not created"
		End If
	Wait(MIN_WAIT)
	Call fnWriteSaleOrderNumber("DC Direct",strOrderNo)
	Wait(MIN_WAIT)
End Function


Public Function fnGetOrderNumberDCDirectfnl(DictObj)
	TeWindow("TeWindow").Activate
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micEsc
	Wait(MIN_WAIT)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micAltDwn + micF4 + micAltUp
	If Dialog("PuTTY Exit Confirmation").Exist(2) Then
		Dialog("PuTTY Exit Confirmation").WinButton("OK").Click
	End If
	Set objFSO = createobject("Scripting.filesystemobject")
	set objFile = objFSO.OpenTextFile (StrFrameWorkFolder&"\Resources\Log.txt")
	strData = objFile.ReadAll
	wait 2
	strOrderString = Split(strData, "DC DIRECT")
	strOrderNumString = Split(strOrderString(2), "BOOKED")
	strOrderNo = Mid(Trim(strOrderNumString(1)), 23, 9)
	fnGetOrderNumberDCDirectfnl = strOrderNo
		If strOrderNo <> "" Then
	'		rptWriteReport "Pass", "Checking for order number creation" , "Order number "&strOrderNo&" created"
			Call rptWriteReport("PASSWITHSCREENSHOT", "Checking for order number creation" , "Order number "&strOrderNo&" created")
			fnReportStepALM "Order Creation","Passed","Order number creation from SystemZ","Order Number should be created","Order Number "&strOrderNo&" is created"
		Else
			rptWriteReport "Fail", "Checking for order number creation" , "Order number "&strOrderNo&" created"
			fnReportStepALM "Order Creation","Failed","Order number creation from SystemZ","Order Number should be created","Order Number is not created"
		End If
	Call fnWriteSaleOrderNumber("DC Direct",strOrderNo)
	wait 2
End Function
'************************************************************************************************************************************************
'	Function Name	 	 :		fnCreateOrder
'	Objective			 :		Used to log into Putty utility
'	Input Parameters	 :		NIL
'	Output Parameters	 :		NIL
'	Date Created		 :		5-Aug-2016
'	QTP Version			 :		11.0
'	QC Version			 :		QC 11.53
'	Pre-requisites		 :		NIL  
'	Created By			 :		Balaji						
'	Modification Date	 :		   
'************************************************************************************************************************************************
Public Function fnCreateOrderDCDirect(iCustomerNo, iProductNo, iQuantity)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type iCustomerNo	
	wait 2
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	Wait(MIN_WAIT)
	
	Set objFSO = createobject("Scripting.filesystemobject")
	set objFile = objFSO.OpenTextFile (StrFrameWorkFolder&"\Resources\Log.txt")
	strData = objFile.ReadAll
	If Instr(strData, "ELIGIBLE FOR HOT SHOTS UPON REQUEST") = 0 then
'		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn		
	End If
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn   '''' Remove after re-add
	Set objFSO =Nothing
	Wait(MIN_WAIT)
	If TeWindow("TeWindow").Exist(2) Then
		rptWriteReport "Pass", "Customer Number" , "Customer number is entered "&iCustomerNo
		Call rptWriteReport("PASSWITHSCREENSHOT", "Customer Number" , "Customer number is entered "&iCustomerNo)
		fnReportStepALM "Customer number ","Passed","Enter Customer Number","Customer Number should be entered","Customer Number is entered "&iCustomerNo
	End If
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type iProductNo
'	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn	
	wait 2
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	Wait(MID_WAIT)	
		Set objFSO = createobject("Scripting.filesystemobject")
		set objFile = objFSO.OpenTextFile (StrFrameWorkFolder&"\Resources\Log.txt")
		strData = objFile.ReadAll
			If Instr(strData,"All D and R product SALES ARE FINAL")>0  Then
				TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn 
			End If
	If TeWindow("TeWindow").Exist(2) Then
		rptWriteReport "Pass", "Product Number" , "Product number is entered "&iProductNo
		Call rptWriteReport("PASSWITHSCREENSHOT", "Product number" , "Product number is entered "&iProductNo)
		fnReportStepALM "Product number ","Passed","Enter Product Number","Product Number should be entered","Product Number is entered "&iProductNo
	End If
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type iQuantity
	Wait 3
	If TeWindow("TeWindow").Exist(2) Then
		rptWriteReport "Pass", "Quantity Number" , "Quantity is entered "&iQuantity
		fnReportStepALM "Quantity ","Passed","Enter Quantity "," Quantity should be entered"," Quantity is entered "&iQuantity
		Call rptWriteReport("PASSWITHSCREENSHOT", "Enter Quantity" , " Quantity is entered "&iQuantity)
	End If
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn	
	Wait(MIN_WAIT)
	Set objFSO = createobject("Scripting.filesystemobject")
	set objFile = objFSO.OpenTextFile (StrFrameWorkFolder&"\Resources\Log.txt")
	strData = objFile.ReadAll
'	If Instr(strData, "Generate a transfer") = 0 then
	If Instr(strData, "Generate") = 0 then
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	End If
	Set objFSO =Nothing
	Wait(MID_WAIT)
End Function


Public Function fnCreateOrderDCDirect1(iCustomerNo, iProductNo, iQuantity)
wait(MID_WAIT)
TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type iCustomerNo
TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn 
TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync
TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn 
TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync
	
	Set objFSO = createobject("Scripting.filesystemobject")
	set objFile = objFSO.OpenTextFile (StrFrameWorkFolder&"\Resources\Log.txt")
	strData = objFile.ReadAll
'	If Instr(strData, "ELIGIBLE FOR HOT SHOTS UPON REQUEST") = 0 then
''		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn		
'	End If
'	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn   '''' Remove after re-add
'	Set objFSO =Nothing
'	Wait(MIN_WAIT)

	If TeWindow("TeWindow").Exist(2) Then
		rptWriteReport "Pass", "Customer Number" , "Customer number is entered "&iCustomerNo
		Call rptWriteReport("PASSWITHSCREENSHOT", "Customer Number" , "Customer number is entered "&iCustomerNo)
		fnReportStepALM "Customer number ","Passed","Enter Customer Number","Customer Number should be entered","Customer Number is entered "&iCustomerNo
	End If	
''''Product Number
TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type iProductNo
TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn 
TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync
TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn 
TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync
 	If TeWindow("TeWindow").Exist(2) Then
		rptWriteReport "Pass", "Product Number" , "Product number is entered "&iProductNo
		Call rptWriteReport("PASSWITHSCREENSHOT", "Product number" , "Product number is entered "&iProductNo)
		fnReportStepALM "Product number ","Passed","Enter Product Number","Product Number should be entered","Product Number is entered "&iProductNo
	End If
 '''''Quantity
TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type iQuantity
TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn 
TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync
	If TeWindow("TeWindow").Exist(2) Then
		rptWriteReport "Pass", "Quantity Number" , "Quantity is entered "&iQuantity
		fnReportStepALM "Quantity ","Passed","Enter Quantity "," Quantity should be entered"," Quantity is entered "&iQuantity
		Call rptWriteReport("PASSWITHSCREENSHOT", "Enter Quantity" , " Quantity is entered "&iQuantity)
	End If
End Function

Public Function fnCreateOrderDCDirectfnl(iCustomerNo, iProductNo, iQuantity)
wait 2
TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type iCustomerNo
wait 2
TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn 
wait 2
	Set objFSO = createobject("Scripting.filesystemobject")
	set objFile = objFSO.OpenTextFile (StrFrameWorkFolder&"\Resources\Log.txt")
	strData = objFile.ReadAll
	If Instr(strData, "ELIGIBLE FOR HOT SHOTS UPON REQUEST")>0 then
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn		
	End If
	Set objFSO =Nothing
'	Wait(MIN_WAIT)
	If TeWindow("TeWindow").Exist(2) Then
		rptWriteReport "Pass", "Customer Number" , "Customer number is entered "&iCustomerNo
		Call rptWriteReport("PASSWITHSCREENSHOT", "Customer Number" , "Customer number is entered "&iCustomerNo)
		fnReportStepALM "Customer number ","Passed","Enter Customer Number","Customer Number should be entered","Customer Number is entered "&iCustomerNo
	End If	
	Wait 2
''''Product Number
TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type iProductNo
wait 1
TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn 
wait 2
	Set objFSO = createobject("Scripting.filesystemobject")
	set objFile = objFSO.OpenTextFile (StrFrameWorkFolder&"\Resources\Log.txt")
	strData = objFile.ReadAll
		If Instr(strData,"All D and R product SALES ARE FINAL")>0  Then
			TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn 
		End If
	wait 2
 	If TeWindow("TeWindow").Exist(2) Then
		rptWriteReport "Pass", "Product Number" , "Product number is entered "&iProductNo
		Call rptWriteReport("PASSWITHSCREENSHOT", "Product number" , "Product number is entered "&iProductNo)
		fnReportStepALM "Product number ","Passed","Enter Product Number","Product Number should be entered","Product Number is entered "&iProductNo
	End If
 '''''Quantity
TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type iQuantity
wait 1
TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn 
wait 2
	Set objFSO = createobject("Scripting.filesystemobject")
	set objFile = objFSO.OpenTextFile (StrFrameWorkFolder&"\Resources\Log.txt")
	strData = objFile.ReadAll
		If Instr(strData, "Generate a transfer") > 0 then
			TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type "Y"
		ElseIf Instr(strData,"Will this be a booking order") >0 Then
			TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type "N"
			wait 1
		Else
			TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
		End If	
	If TeWindow("TeWindow").Exist(2) Then
		rptWriteReport "Pass", "Quantity Number" , "Quantity is entered "&iQuantity
		fnReportStepALM "Quantity ","Passed","Enter Quantity "," Quantity should be entered"," Quantity is entered "&iQuantity
		Call rptWriteReport("PASSWITHSCREENSHOT", "Enter Quantity" , " Quantity is entered "&iQuantity)
	End If
End Function
'************************************************************************************************************************************************
'	Function Name	 	 :		fnNavigatePickDCDirect
'	Objective			 :		Used to log into Telnet utility
'	Input Parameters	 :		NIL
'	Output Parameters	 :		NIL
'	Date Created		 :		5-Aug-2016
'	QTP Version			 :		11.0
'	QC Version			 :		QC 11.53
'	Pre-requisites		 :		NIL  
'	Created By			 :		Balaji						
'	Modification Date	 :		   
'************************************************************************************************************************************************
Public Function fnNavigatePickDCDirect(DictObj)	
	Set objFSO = createobject("Scripting.filesystemobject")
	set objFile = objFSO.OpenTextFile (StrFrameWorkFolder&"\Resources\Log.txt")
	strSession = objFile.ReadAll	
	Wait(MIN_WAIT)
			If Instr(strSession, "old session") > 0 Then
				TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type "N"
				wait 1
				TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
				rptWriteReport "Pass", "New Session" , "Navigated to new session"
				fnReportStepALM "Navigate Session","Passed","Session Navigate","Should navigate to new session","Navigated to new session"		
			Else
				TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn		
			End If	
	Wait(MID_WAIT)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type "4"
	wait 1
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn	
	Wait(MIN_WAIT)
		Set objFSO = createobject("Scripting.filesystemobject")
		set objFile = objFSO.OpenTextFile (StrFrameWorkFolder&"\Resources\Log.txt")
		stringOrg = objFile.ReadAll	
		If Instr(stringOrg, "Org") = 0 Then
			TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type "3"
			wait 1
			TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn	
			Wait(MIN_WAIT)
			rptWriteReport "Pass", "Manual Pick select" , "selected Manual Pick"
			fnReportStepALM "Manual Pick","Passed","Select Manual Pick","Should select Manual Pick","Selected Manual Pick"	
		End If		
	intWarehouseNu=fnReadWarehouseNumber("DC Direct")
	Wait(MIN_WAIT)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type trim(intWarehouseNu)
	Wait(MIN_WAIT)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	Wait(MIN_WAIT)
	rptWriteReport "Pass", "Enter Organization" , "Entered organization "&trim(intWarehouseNu)
	fnReportStepALM "Enter Organization","Passed","Enter Organization","Should Enter Organization","Organization entered "&strOrg
		Set objFSO = createobject("Scripting.filesystemobject")
		set objFile = objFSO.OpenTextFile (StrFrameWorkFolder&"\Resources\Log.txt")
		stringPick = objFile.ReadAll	
		If  Instr(stringPick, "Manual") = 0 And Instr(stringPick, "Equip") = 0 Then
			TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type "3"
			wait 2
			TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn	
			Wait(MIN_WAIT)
		End If
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	wait 1
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	wait 1
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	wait 1
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	Wait(MIN_WAIT)
		Set objFSO = createobject("Scripting.filesystemobject")
		set objFile = objFSO.OpenTextFile (StrFrameWorkFolder&"\Resources\Log.txt")
		stringMan = objFile.ReadAll
		If Instr(stringMan, "Manual") > 0 Then
			TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type "3"
			wait 1
			TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn	
			Wait(MIN_WAIT)
		End If
End Function
'************************************************************************************************************************************************
'	Function Name	 	 :		fnNavigatePickFedex
'	Objective			 :		Used to log into Telnet utility
'	Input Parameters	 :		NIL
'	Output Parameters	 :		NIL
'	Date Created		 :		24-Mar-2017
'	QTP Version			 :		11.0
'	QC Version			 :		QC 11.53
'	Pre-requisites		 :		NIL  
'	Created By			 :		Balaji						
'	Modification Date	 :		   
'************************************************************************************************************************************************
Public Function fnNavigatePickFedex(DictObj)
	Set objFSO = createobject("Scripting.filesystemobject")
	Set objFile = objFSO.OpenTextFile (StrFrameWorkFolder&"\Resources\Log.txt")
	strSession = objFile.ReadAll	
	Wait(MIN_WAIT)
			If Instr(strSession, "old session") > 0 Then
				TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type "N"
				wait 1
				TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
				rptWriteReport "Pass", "New Session" , "Navigated to new session"
				fnReportStepALM "Navigate Session","Passed","Session Navigate","Should navigate to new session","Navigated to new session"		
			Else
				TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn		
			End If	
	Wait(MID_WAIT)
	Wait(MIN_WAIT)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type "4"
	wait 1
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn	
	Wait(MIN_WAIT)
	stringOrg = objFile.ReadAll	
	If Instr(stringOrg, "Org") = 0 Then
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type "3"
		wait 1
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn	
		Wait(MIN_WAIT)
		rptWriteReport "Pass", "Manual Pick select" , "selected Manual Pick"
		fnReportStepALM "Manual Pick","Passed","Select Manual Pick","Should select Manual Pick","Selected Manual Pick"	
	End If		
	intWarehouseNu=fnReadWarehouseNumber("GSOFedexShippingMethod")
	wait 2
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type DictObj("Organization_Number"&rKey)
	wait 2
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	wait 2
	rptWriteReport "Pass", "Enter Organization" , "Entered organization "&DictObj("Organization_Number"&rKey)
	fnReportStepALM "Enter Organization","Passed","Enter Organization","Should Enter Organization","Organization entered "&strOrg
	stringPick = objFile.ReadAll	
	If  Instr(stringPick, "Manual") = 0 And Instr(stringPick, "Equip") = 0 Then
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type "3"
		wait 2
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn	
		wait 2
	End If
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	wait 1
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	wait 1
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	wait 1
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	Wait(MIN_WAIT)
		Set objFSO = createobject("Scripting.filesystemobject")
		Set objFile = objFSO.OpenTextFile (StrFrameWorkFolder&"\Resources\Log.txt")
		stringMan = objFile.ReadAll
		If Instr(stringMan, "Manual") > 0 Then
			TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type "3"
			TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn	
			Wait(MIN_WAIT)
		End If
End Function
'************************************************************************************************************************************************
'	Function Name	 	 :		fnNavigatePickGenericSaleOrder
'	Objective			 :		Used to log into Telnet utility
'	Input Parameters	 :		NIL
'	Output Parameters	 :		NIL
'	Date Created		 :		5-Aug-2016
'	QTP Version			 :		11.0
'	QC Version			 :		QC 11.53
'	Pre-requisites		 :		NIL  
'	Created By			 :		Balaji						
'	Modification Date	 :		   
'************************************************************************************************************************************************
Public Function fnNavigatePickGenericSaleOrder(DictObj)
	Set objFSO = createobject("Scripting.filesystemobject")
	Set objFile = objFSO.OpenTextFile (StrFrameWorkFolder&"\Resources\Log.txt")
	strSession = objFile.ReadAll	
	Wait(MIN_WAIT)
			If Instr(strSession, "old session") > 0 Then
				TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type "N"
				TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
				rptWriteReport "Pass", "New Session" , "Navigated to new session"
				fnReportStepALM "Navigate Session","Passed","Session Navigate","Should navigate to new session","Navigated to new session"		
			Else
				TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn		
			End If	
	Wait(MID_WAIT)	
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type "4"
	wait 1
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn	
	Wait(MIN_WAIT)
	Set objFSO = createobject("Scripting.filesystemobject")
	Set objFile = objFSO.OpenTextFile (StrFrameWorkFolder&"\Resources\Log.txt")
	stringOrg = objFile.ReadAll	
		If Instr(stringOrg, "Org") = 0 Then
			TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type "3"
			wait 1
			TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn	
			Wait(MIN_WAIT)
			rptWriteReport "Pass", "Manual Pick select" , "selected Manual Pick"
			fnReportStepALM "Manual Pick","Passed","Select Manual Pick","Should select Manual Pick","Selected Manual Pick"	
		End If		
	intWarehouseNu=fnReadWarehouseNumber("Generic Sales Order")
	Wait(MIN_WAIT)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type trim(intWarehouseNu)
	wait 2
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	wait 2
	rptWriteReport "Pass", "Enter Organization" , "Entered organization "&trim(intWarehouseNu)
	fnReportStepALM "Enter Organization","Passed","Enter Organization","Should Enter Organization","Organization entered "&strOrg
		Set objFSO = createobject("Scripting.filesystemobject")
		Set objFile = objFSO.OpenTextFile (StrFrameWorkFolder&"\Resources\Log.txt")
		stringPick = objFile.ReadAll	
			If  Instr(stringPick, "Manual") = 0 And Instr(stringPick, "Equip") = 0 Then
				TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type "3"
				TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn	
				Wait(MIN_WAIT)
			End If
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	wait 1
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	wait 1
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	wait 1
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	Wait(MIN_WAIT)
		Set objFSO = createobject("Scripting.filesystemobject")
		Set objFile = objFSO.OpenTextFile (StrFrameWorkFolder&"\Resources\Log.txt")
		stringMan = objFile.ReadAll
			If Instr(stringMan, "Manual") > 0 Then
				TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type "3"
				wait 1
				TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn	
				Wait(MIN_WAIT)
			End If
End Function

'************************************************************************************************************************************************
'	Function Name	 	 :		fnNavigateDropDCDirect
'	Objective			 :		Used to log into Telnet utility
'	Input Parameters	 :		NIL
'	Output Parameters	 :		NIL
'	Date Created		 :		5-Aug-2016
'	QTP Version			 :		11.0
'	QC Version			 :		QC 11.53
'	Pre-requisites		 :		NIL  
'	Created By			 :		Balaji						
'	Modification Date	 :		   
'************************************************************************************************************************************************
Public Function fnNavigateDropDCDirect(DictObj)
	Set objFSO = createobject("Scripting.filesystemobject")
	Set objFile = objFSO.OpenTextFile (StrFrameWorkFolder&"\Resources\Log.txt")
	strSession = objFile.ReadAll	
	Wait(MIN_WAIT)
			If Instr(strSession, "old session") > 0 Then
				TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type "N"
				wait 1
				TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
				wait 1
				rptWriteReport "Pass", "New Session" , "Navigated to new session"
				fnReportStepALM "Navigate Session","Passed","Session Navigate","Should navigate to new session","Navigated to new session"		
			Else
				TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn		
			End If	
	Wait(MID_WAIT)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type "5"
	wait 1
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn	
	Wait(MIN_WAIT)
		Set objFSO = createobject("Scripting.filesystemobject")
		Set objFile = objFSO.OpenTextFile (StrFrameWorkFolder&"\Resources\Log.txt")
		stringOrg = objFile.ReadAll	
		If Instr(stringOrg, "Org") = 0 Then
			TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type "3"
			TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn	
			Wait(MIN_WAIT)
			rptWriteReport "Pass", "Manual Pick select" , "selected Manual Pick"
			fnReportStepALM "Manual Pick","Passed","Select Manual Pick","Should select Manual Pick","Selected Manual Pick"	
		End If
	intWarehouseNu=fnReadWarehouseNumber("DC Direct")	
	Wait(MIN_WAIT)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type trim(intWarehouseNu)
	wait 2
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	Wait(MIN_WAIT)
	rptWriteReport "Pass", "Enter Organization" , "Entered organization "&trim(intWarehouseNu)
	fnReportStepALM "Enter Organization","Passed","Enter Organization","Should Enter Organization","Organization entered "&intWarehouseNu	
End Function
'************************************************************************************************************************************************
'	Function Name	 	 :		fnNavigateDropFedex
'	Objective			 :		Used to log into Telnet utility
'	Input Parameters	 :		NIL
'	Output Parameters	 :		NIL
'	Date Created		 :		5-Aug-2016
'	QTP Version			 :		11.0
'	QC Version			 :		QC 11.53
'	Pre-requisites		 :		NIL  
'	Created By			 :		Balaji						
'	Modification Date	 :		   
'************************************************************************************************************************************************
Public Function fnNavigateDropFedex(DictObj)
	Set objFSO = createobject("Scripting.filesystemobject")
	set objFile = objFSO.OpenTextFile (StrFrameWorkFolder&"\Resources\Log.txt")
	strSession = objFile.ReadAll	
	Wait(MIN_WAIT)
			If Instr(strSession, "old session") > 0 Then
				TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type "N"
				wait 2
				TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
				rptWriteReport "Pass", "New Session" , "Navigated to new session"
				fnReportStepALM "Navigate Session","Passed","Session Navigate","Should navigate to new session","Navigated to new session"		
			Else
				TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn		
			End If	
	Wait(MID_WAIT)	
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type "5"
	wait 1
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn	
	wait 1
	Set objFSO = createobject("Scripting.filesystemobject")
	set objFile = objFSO.OpenTextFile (StrFrameWorkFolder&"\Resources\Log.txt")
	stringOrg = objFile.ReadAll	
		If Instr(stringOrg, "Org") = 0 Then
			TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type "3"
			wait 1
			TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn	
			wait 2
			rptWriteReport "Pass", "Manual Pick select" , "selected Manual Pick"
			fnReportStepALM "Manual Pick","Passed","Select Manual Pick","Should select Manual Pick","Selected Manual Pick"	
		End If
	intWarehouseNu=fnReadWarehouseNumber("GSOFedexShippingMethod")	
	wait 2
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type DictObj("Organization_Number"&rKey)
	wait 2
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	wait 2
	rptWriteReport "Pass", "Enter Organization" , "Entered organization "&DictObj("Organization_Number"&rKey)
	fnReportStepALM "Enter Organization","Passed","Enter Organization","Should Enter Organization","Organization entered "&intWarehouseNu
	Wait(MIN_WAIT)	
End Function
'************************************************************************************************************************************************
'	Function Name	 	 :		fnNavigateDropGenericSales
'	Objective			 :		Used to log into Telnet utility
'	Input Parameters	 :		NIL
'	Output Parameters	 :		NIL
'	Date Created		 :		13-Mar-2017
'	QTP Version			 :		11.0
'	QC Version			 :		QC 11.53
'	Pre-requisites		 :		NIL  
'	Created By			 :		Balaji						
'	Modification Date	 :		   
'************************************************************************************************************************************************
Public Function fnNavigateDropGenericSales(DictObj)
	Set objFSO = createobject("Scripting.filesystemobject")
	Set objFile = objFSO.OpenTextFile (StrFrameWorkFolder&"\Resources\Log.txt")
	strSession = objFile.ReadAll	
	Wait(MIN_WAIT)
			If Instr(strSession, "old session") > 0 Then
				TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type "N"
				wait 1
				TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
				rptWriteReport "Pass", "New Session" , "Navigated to new session"
				fnReportStepALM "Navigate Session","Passed","Session Navigate","Should navigate to new session","Navigated to new session"		
			Else
				TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn		
			End If	
	Wait(MID_WAIT)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type "5"
	wait 1
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn	
	Wait(MIN_WAIT)
		Set objFSO = createobject("Scripting.filesystemobject")
		Set objFile = objFSO.OpenTextFile (StrFrameWorkFolder&"\Resources\Log.txt")
		stringOrg = objFile.ReadAll	
		If Instr(stringOrg, "Org") = 0 Then
			TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type "3"
			wait 1
			TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn	
			wait 2
			rptWriteReport "Pass", "Manual Pick select" , "selected Manual Pick"
			fnReportStepALM "Manual Pick","Passed","Select Manual Pick","Should select Manual Pick","Selected Manual Pick"	
		End If
	intWarehouseNu=fnReadWarehouseNumber("Generic Sales Order")	
	Wait(MIN_WAIT)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type trim(intWarehouseNu)
	wait 2
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	wait 1
	rptWriteReport "Pass", "Enter Organization" , "Entered organization "&trim(intWarehouseNu)
	fnReportStepALM "Enter Organization","Passed","Enter Organization","Should Enter Organization","Organization entered "&intWarehouseNu
End Function
'************************************************************************************************************************************************
'	Function Name	 	 :		fnConfirmPickDCDirect
'	Objective			 :		Used to log into Telnet utility
'	Input Parameters	 :		NIL
'	Output Parameters	 :		NIL
'	Date Created		 :		5-Aug-2016
'	QTP Version			 :		11.0
'	QC Version			 :		QC 11.53
'	Pre-requisites		 :		NIL  
'	Created By			 :		Balaji						
'	Modification Date	 :		   
'************************************************************************************************************************************************
Public Function fnConfirmPickDCDirect(DictObj)	
wait(MID_WAIT)
	intTransactionNu=fnReadTransactionNumber("DC Direct")
	wait(MID_WAIT)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type trim(intTransactionNu)
	wait 2
	eWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	Wait(MAX_WAIT)
	rptWriteReport "Pass", "Enter Transaction Number" , "Entered Transaction Number "&trim(intTransactionNu)
	fnReportStepALM "Enter Transaction Number","Passed","Enter Transaction Number","Should Enter Transaction Number","Transaction Number entered "&intTransaction
	Set objFSO = createobject("Scripting.filesystemobject")
	Set objFile = objFSO.OpenTextFile (StrFrameWorkFolder&"\Resources\Log.txt")
'	strData = objFile.ReadAll
'	intSub = Instr(strData, "Sub                 :")
'	intLoc = Instr(strData, "Loc                 :")
'	intItemDe = Instr(strData, "Item Desc           :")
'	intItem = Instr(strData, "Item                :")
'	intUOM = Instr(strData, "UOM                 >")
'	intReqQty = Instr(strData, "Req Qty             :")
'	intXferLP = Instr(strData , "Xfer LPN            :")
	
'	intSub = Instr(strData, "Sub    :")
'	intLoc = Instr(strData, "Loc    :")
'	intItemDe = Instr(strData, "Item De:")
'	intItem = Instr(strData, "Item   :")
'	intUOM = Instr(strData, "UOM    >")
'	intReqQty = Instr(strData, "Req Qty:")
'	intXferLP = Instr(strData , "Xfer LP:")
		
	intSub = Instr(strData, "Sub            :")
	intLoc = Instr(strData, "Loc            :")
	intItemDe = Instr(strData, "Item Desc      :")
	intItem = Instr(strData, "Item           :")
	intUOM = Instr(strData, "UOM            >")
	intReqQty = Instr(strData, "Req Qty        :")
	intXferLP = Instr(strData , "Xfer LP        :")
	
'''''	strSubString = Mid(strData, intSub+21, Cint(intLoc)-Cint(intSub+21))
'''''	strSub = Replace(strSubString, "Confirm             :[7m                                       [0m", "")
'''''	strLocString = Mid(strData, intLoc+21, Cint(intItemDe)-Cint(intLoc+21))
'''''	strLoc = Replace(strLocString, "Confirm             :[7m                                       [0m", "")	
'''''	strItemString = Mid(strData, intItem+21, Cint(intUOM)-Cint(intItem+21))
'''''	strItem = Replace(strItemString, "Confirm             :[7m                                       [0m", "")
'''''	strReqQtyString = Mid(strData, intReqQty+21, Cint(intXferLP)-Cint(intReqQty+21))
'''''	strReqQty = Replace(strReqQtyString, "Confirm             :[7m                                       [0m", "")
	
	wait(MIN_WAIT)
	strSubString = Mid(strData, intSub+8, Cint(intLoc)-Cint(intSub+8))
	strSub = Replace(strSubString, "Confirm:[7m              [0m", "")
	strLocString = Mid(strData, intLoc+8, Cint(intItemDe)-Cint(intLoc+8))
	strLoc = Replace(strLocString, "Confirm:[7m              [0m", "")	
	strItemString = Mid(strData, intItem+8, Cint(intUOM)-Cint(intItem+8))
	strItem = Replace(strItemString, "Confirm:[7m              [0m", "")
	strReqQtyString = Mid(strData, intReqQty+8, Cint(intXferLP)-Cint(intReqQty+8))
	strReqQty = Replace(strReqQtyString, "Confirm:[7m              [0m", "")	
	
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type strSub
	wait 2
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type strLoc
	wait 2
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type strItem
	wait 2
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type strReqQty
	wait 2
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micCtrlDwn + "G" + micCtrlUp
	wait 2
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	wait 2
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micDwn
	wait 2
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	Wait(MAX_WAIT)
	rptWriteReport "Pass", "Enter Confirmation details" , "Entered Confirmation details "
	fnReportStepALM "Enter Confirmation details","Passed","Enter Confirmation details","Should Enter Confirmation details","Confirmation details entered"
End Function
'************************************************************************************************************************************************
'	Function Name	 	 :		fnConfirmShipDCDirect
'	Objective			 :		Used to confirm the ship
'	Input Parameters	 :		NIL
'	Output Parameters	 :		NIL
'	Date Created		 :		4-Aug-2016
'	QTP Version			 :		11.0
'	QC Version			 :		QC 11.53
'	Pre-requisites		 :		NIL  
'	Created By			 :		Balaji						
'	Modification Date	 :		   
'************************************************************************************************************************************************
Public Function fnConfirmShipDCDirect()
''	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micF2 
'	Wait(MIN_WAIT)
'	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type "Y"
'	Wait(MIN_WAIT)
'	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
'	Wait(MIN_WAIT)
'	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micF2 
'	Wait(MIN_WAIT)
'	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micAltDwn+micReturn+micAltUp
'	Wait(MIN_WAIT)	
'	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micDwn
'	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
'	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type "2"
'	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
'	
'***********Below code is for shiping with Delivery number'******************************Do not delete**************	
	
'	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn

	strDeliveryNo=fnReadDeliveryNumber("DC Direct")
	Wait(MIN_WAIT)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type strDeliveryNo
	Wait(MIN_WAIT)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	strItemNo=fnReadItemNumber("DC Direct")
	''''Order Implement take data from FSO
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type strItemNo
	wait 2
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micDwn
	wait 2
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	wait 2
		Set objFSO = createobject("Scripting.filesystemobject")
		Set objFile = objFSO.OpenTextFile (StrFrameWorkFolder&"\Resources\Log.txt")
		strData = objFile.ReadAll
		intItem = Instr(strData, "Item   :")
		intConfirm = Instr(strData, "Confirm>")
		strItem = Mid(strData, intItem+8, Cint(intConfirm)-Cint(intLane+8))
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type strItem
		wait 1
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
		wait 1
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
		wait 1
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
		wait 1
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
		wait 1
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
		wait 2
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
		Wait(MAX_WAIT)
			Set objFSO = createobject("Scripting.filesystemobject")
			Set objFile = objFSO.OpenTextFile (StrFrameWorkFolder&"\Resources\Log.txt")
			strData = objFile.ReadAll
				If Instr(strData, "Delivery"&strDeliveryNo) > 0 Then
			   		 Call rptWriteReport("PASSWITHSCREENSHOT", "Check shipment status","Shipment status is sucessful")
					 fnReportStepALM "Delivery success Messsage","Passed","Delivery shipped succesfully message","Delivery shipped succesfully message should be displayed","Delivery shipped succesfully message is displayed"
				Else
					rptWriteReport "Fail", "Checking for delivery success message" , "Delivery shipped succesfully message is not displayed"
					fnReportStepALM "Delivery success Messsage","Failed","Delivery shipped succesfully message","Delivery shipped succesfully message should be displayed","Delivery shipped succesfully message is not displayed"
				End If	
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
End Function

Public Function fnConfirmDropDCDirect()
	Wait(MID_WAIT)
	Set objFSO = createobject("Scripting.filesystemobject")
	set objFile = objFSO.OpenTextFile (StrFrameWorkFolder&"\Resources\Log.txt")
	strData = objFile.ReadAll
	intSub = Instr(strData, "To Sub :")
	intLoc = Instr(strData, "To Loc :")
	intDrop = Instr(strData, "Drop LP>")	
'	intDrop = Instr(strData, "<Done>")	
	strSubString = Mid(strData, intSub+8, Cint(intLoc)-Cint(intSub+11))
	strSub = Replace(strSubString, "Confirm>[7m              [0m", "")

'	strLocString = Mid(strData, intLoc+8, Cint(intDrop)-Cint(intLoc+11))
'	strLoc = Replace(strLocString, "Drop LP>[7m              [0m", "")
'	strLocs=split(strLoc,"Confirm]")	
	
	strLocString = Mid(strData, intLoc+8, Cint(intDrop)-Cint(intLoc+11))
	strLoc = Replace(strLocString, "Confirm][7m              [0m", "")	
'	strLoc = Replace(strLocString, "Drop LP>[7m              [0m", "")	
	
	
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type strSub
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type strLoc
	Wait(MIN_WAIT)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micCtrlDwn + "G" + micCtrlUp	
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	Wait(MAX_WAIT)
	rptWriteReport "Pass", "Enter drop details" , "Entered details "
	fnReportStepALM "Enter drop details","Passed","Enter drop details","Should Enter drop details","drop details entered "
	
End Function


Public Function fnCreateVDSOrder(iCustomerNo, iProductNo, iQuantity)
	'Enter Customer Number 
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type iCustomerNo	
	Wait(2)
	If Ucase(Environment("CountryUS")) = "YES" and  Ucase(Environment("CountryCA")) = "NO" Then
       TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
		Wait(4)
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
    ElseIf Ucase(Environment("CountryUS")) = "NO" and  Ucase(Environment("CountryCA")) = "YES" Then
           TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
           Wait(2)
    End If
	If TeWindow("TeWindow").Exist(2) Then
		rptWriteReport "Pass", "Customer Number" , "Customer number is entered "&iCustomerNo
		fnReportStepALM "Customer number ","Passed","Enter Customer Number","Customer Number should be entered","Customer Number is entered "&iCustomerNo
	End If
	'Enter Product#
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type iProductNo	
	Wait(05)
	If TeWindow("TeWindow").Exist(2) Then
		rptWriteReport "Pass", "Product Number" , "Product number is entered "&iProductNo
		fnReportStepALM "Product number ","Passed","Enter Product Number","Product Number should be entered","Product Number is entered "&iProductNo
	End If
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	wait (3)
	'Enter Quantity 
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type iQuantity
	Wait(05)
	If TeWindow("TeWindow").Exist(2) Then
		rptWriteReport "Pass", "Quantity Number" , "Quantity is entered "&iQuantity
		fnReportStepALM "Quantity ","Passed","Enter Quantity "," Quantity should be entered"," Quantity is entered "&iQuantity
	End If
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	'Press N for not to Generate a Back Order against your assigned DC 	
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type "Y"
	wait (3)
	If TeWindow("TeWindow").Exist(2) Then
		rptWriteReport "Pass", "Generate Back Order Y/N" , "N is entered"
		fnReportStepALM "Generate Back Order Y/N ", "Passed", "Generate Back Order Y/N verification "," Y/N should be entered"," N is entered "
	End If
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type "N"
	Wait(05)
	'Order from Vendor remaining units Y/N 
	If TeWindow("TeWindow").Exist(2) Then
		rptWriteReport "Pass", "Order from Vendor remaining "&iQuantiy&" Y/N" , "Y is entered "
		fnReportStepALM "Order from Vendor Y/N ", "Passed", "Order from Vendor fro remaining "&iQuantiy&"Y/N verification"," Y/N should be entered"," Y is entered "
	End If
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type "Y"
	Wait(05)
	'Select [D] Create Drop Ship
	If TeWindow("TeWindow").Exist(2) Then
		rptWriteReport "Pass", "Select [D] Create Drop Ship" , "D is entered "
		fnReportStepALM "Select [D] Create Drop Ship","Passed", "Select [D] Create Drop Ship verification"," D should be entered","D is entered "
	End If
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type "D"
	Wait(07)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micDwn
	'Enter Freight Charges 
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type "15.00"
	If TeWindow("TeWindow").Exist(2) Then
		rptWriteReport "Pass", "Freight Charges" , "Freight Charges entered"
		fnReportStepALM "Freight Charges","Passed", "Freight Charges verification", "Freight Charges should be entered","Freight Charges entered"
	End If
	
	If Ucase(Environment("CountryUS")) = "YES" and  Ucase(Environment("CountryCA")) = "NO" Then
       	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micDwn
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micDwn
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micUp
    ElseIf Ucase(Environment("CountryUS")) = "NO" and  Ucase(Environment("CountryCA")) = "YES" Then
        TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micDwn
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micDwn
		wait(2)
'		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
    End If
	Wait(05)	
End Function
'************************************************************************************************************************************************
'	Function Name	 	 :		fnGetVDSOrderNumber
'	Objective			 :		Used to get VDS Order Number
'	Input Parameters	 :		NIL
'	Output Parameters	 :		NIL
'	Date Created		 :		03-March-2017
'	QTP Version			 :		11.0
'	QC Version			 :		QC 11.53
'	Pre-requisites		 :		NIL  
'	Created By			 :		Gallop						
'	Modification Date	 :		   
'************************************************************************************************************************************************
Public Function fnGetVDSOrderNumber()	
	TeWindow("TeWindow").Activate
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micEsc
	Wait(MIN_WAIT)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micAltDwn + micF4 + micAltUp
		If Dialog("PuTTY Exit Confirmation").Exist(2) Then
			Dialog("PuTTY Exit Confirmation").WinButton("OK").Click
		End If
	Set objFSO = createobject("Scripting.filesystemobject")
	set objFile = objFSO.OpenTextFile (StrFrameWorkFolder&"\Resources\Log.txt")
	strData = objFile.ReadAll
	Wait(MIN_WAIT)
'			strOrderString = Split(strData, "VENDOR TO CUST")
'			Wait(MIN_WAIT)
'			strOrderNumString = Split(strOrderString(2), "BOOKED")
'			strOrderNo = Mid(Trim(strOrderNumString(1)), 23, 9)
		strOrderString = Split(strData, "ORDER/RSVD")		''-------- Added by Balaji Veeravalli
		strOrderStrings=Split(strOrderString(1), "H")
		strOrderNo = Mid(Trim(strOrderStrings(1)),1, 9)
	Wait(MIN_WAIT)
	fnGetVDSOrderNumber = strOrderNo
			If strOrderNo <> "" Then
		'		rptWriteReport "Pass", "Checking for order number creation" , "Order number "&strOrderNo&" created"
				Call rptWriteReport("PASSWITHSCREENSHOT", "Checking for order number creation" , "Order number "&strOrderNo&" created")
				fnReportStepALM "Order Creation","Passed","Order number creation from SystemZ","Order Number should be created","Order Number "&strOrderNo&" is created"
			Else
				rptWriteReport "Fail", "Checking for order number creation" , "Order number "&strOrderNo&" created"		
				fnReportStepALM "Order Creation","Failed","Order number creation from SystemZ","Order Number should be created","Order Number is not created"			
			End If
End Function 	
	
'******************************************************************************************************************************************************************************************************************************************
'	Sub Name		 					:					fnWriteSaleOrderNumber
'	Objective							:					To write sale order number into local test file
'	Input Parameters					:					textFile name
'	Output Parameters					:					NIL
'	Date Created						:					05-Mar-2017
'	QTP Version							:					UFT 12.0
'	QC Version							:					
'	Pre-requisites						:					NILL  
'	Created By							:					Balaji Veeravalli
'	Modification Date					:	
'******************************************************************************************************************************************************************************************************************************************
Public Function fnWriteSaleOrderNumber(sFileName,inpOrderNumber)
		Set obj = CreateObject("Scripting.FileSystemObject")			
			sFile=trim(sFileName)
'			iOrder=inpOrderNumber
				If  obj.FileExists(sResourcesPathForData& "\"&sFile&".txt") Then
				    obj.DeleteFile(sResourcesPathForData& "\"&sFile&".txt")	
			   		Set oFile=obj.CreateTextFile(sResourcesPathForData& "\"&sFile&".txt",true)
					oFile.Write "Order Number:"& inpOrderNumber &VBNEWLine				
				Else		    
					Set oFile=obj.CreateTextFile(sResourcesPathForData& "\"&sFile&".txt",true)
					oFile.Write "Order Number:"& inpOrderNumber &VBNEWLine					
				End If
				wait 2
			oFile.Close			
			Set oFile= Nothing
			Set obj=Nothing	 
End Function

'******************************************************************************************************************************************************************************************************************************************
'	Sub Name		 					:					fnReadSaleOrderNumber
'	Objective							:					To get sales order number from text file
'	Input Parameters					:					textFile name
'	Output Parameters					:					NIL
'	Date Created						:					05-Mar-2017
'	QTP Version							:					UFT 12.0
'	QC Version							:					
'	Pre-requisites						:					NILL  
'	Created By							:					Balaji Veeravalli
'	Modification Date					:	
'******************************************************************************************************************************************************************************************************************************************
Public Function fnReadSaleOrderNumber(sFileName)
On Error Resume Next
    Set objFSOs = createobject("Scripting.filesystemobject")
        sFile=trim(sFileName)
         set objFiles = objFSOs.OpenTextFile(sResourcesPathForData&"\"&sFile&".txt")    
         Do
             strData=objFiles.ReadLine
             wait 2
             If InStr(strData,"Order Number")>0 Then
                  arrItem=Split(strData,":")
                      If IsNumeric(arrItem(1)) Then
                         fnReadSaleOrderNumber=trim(arrItem(1))
'                        fnReadSaleOrderNumber=trim(iItemNumber)
                      End If
             End If
         Loop Until objFiles.AtEndOfLine
        objFiles.Close
        set objFiles= Nothing
        Set objFSOs= Nothing
End Function

'******************************************************************************************************************************************************************************************************************************************
'	Sub Name		 					:					fnWriteWarehouseNumber
'	Objective							:					To write sale order number into local test file
'	Input Parameters					:					textFile name
'	Output Parameters					:					NIL
'	Date Created						:					05-Mar-2017
'	QTP Version							:					UFT 12.0
'	QC Version							:					
'	Pre-requisites						:					NILL  
'	Created By							:					Balaji Veeravalli
'	Modification Date					:	
'******************************************************************************************************************************************************************************************************************************************
Public Function fnWriteWarehouseNumber(sFileName,inpOrg)
		Set obj = CreateObject("Scripting.FileSystemObject")
			sFile=trim(sFileName)
'			iWarehouseNo=inpOrg
		If  obj.FileExists(sResourcesPathForData& "\"&sFile&".txt") Then
		  	Set oFile=obj.OpenTextFile(sResourcesPathForData& "\"&sFile&".txt", 8,TRUE)  
			oFile.Write "Warehouse Number:"& inpOrg &VBNEWLine	
			wait 2			
			oFile.Close
			Set oFile= Nothing
			Set obj=Nothing	 
		End If
End Function

'******************************************************************************************************************************************************************************************************************************************
'	Sub Name		 					:					fnReadWarehouseNumber
'	Objective							:					To get Warehouse Number from text file
'	Input Parameters					:					textFile name
'	Output Parameters					:					NIL
'	Date Created						:					05-Mar-2017
'	QTP Version							:					UFT 12.0
'	QC Version							:					
'	Pre-requisites						:					NILL  
'	Created By							:					Balaji Veeravalli
'	Modification Date					:	
'******************************************************************************************************************************************************************************************************************************************
Public Function fnReadWarehouseNumber(sFileName)
On Error Resume Next
    Set objFSOs = createobject("Scripting.filesystemobject")
        sFile=trim(sFileName)
         set objFiles = objFSOs.OpenTextFile(sResourcesPathForData&"\"&sFile&".txt")    
         Do
             strData=objFiles.ReadLine
             wait 2
             If InStr(strData,"Warehouse Number")>0 Then
                  arrItem=Split(strData,":")
                      If IsNumeric(arrItem(1)) Then
                         fnReadWarehouseNumber=Trim(arrItem(1))
'                        fnReadWarehouseNumber=Trim(iItemNumber)
                      End If
             End If
'             objFiles.SkipLine
         Loop Until objFiles.AtEndOfLine
        objFiles.Close
        set objFiles= Nothing
        Set objFSOs= Nothing
End Function

'******************************************************************************************************************************************************************************************************************************************
'	Sub Name		 					:					fnWriteDeliveryNumber
'	Objective							:					To write Delivery number into local test file
'	Input Parameters					:					textFile name
'	Output Parameters					:					NIL
'	Date Created						:					05-Mar-2017
'	QTP Version							:					UFT 12.0
'	QC Version							:					
'	Pre-requisites						:					NILL  
'	Created By							:					Balaji Veeravalli
'	Modification Date					:	
'******************************************************************************************************************************************************************************************************************************************
Public Function fnWriteDeliveryNumber(sFileName,inpDeliveryNo)
		Set obj = CreateObject("Scripting.FileSystemObject")
			sFile=trim(sFileName)
'			iDeliveryNum=inpDeliveryNo
		If  obj.FileExists(sResourcesPathForData& "\"&sFile&".txt") Then
		  	Set oFile=obj.OpenTextFile(sResourcesPathForData& "\"&sFile&".txt", 8,TRUE)  
			oFile.Write "Delivery Number:"& inpDeliveryNo &VBNEWLine
			wait 2
		oFile.Close
		Set oFile= Nothing
		Set obj=Nothing	 
		End If
End Function

'******************************************************************************************************************************************************************************************************************************************
'	Sub Name		 					:					fnReadDeliveryNumber
'	Objective							:					To get Delivery Number from text file
'	Input Parameters					:					textFile name
'	Output Parameters					:					NIL
'	Date Created						:					05-Mar-2017
'	QTP Version							:					UFT 12.0
'	QC Version							:					
'	Pre-requisites						:					NILL  
'	Created By							:					Balaji Veeravalli
'	Modification Date					:	
'******************************************************************************************************************************************************************************************************************************************
Public Function fnReadDeliveryNumber(sFileName)
On Error Resume Next
    Set objFSOs = createobject("Scripting.filesystemobject")
        sFile=trim(sFileName)
         set objFiles = objFSOs.OpenTextFile(sResourcesPathForData&"\"&sFile&".txt")    
         Do
             strData=objFiles.ReadLine
             wait 2
             If InStr(strData,"Delivery Number")>0 Then
                  arrItem=Split(strData,":")
                      If IsNumeric(arrItem(1)) Then
                         fnReadDeliveryNumber=Trim(arrItem(1))
'                        fnReadDeliveryNumber=Trim(iItemNumber)
                      End If
             End If
'             objFiles.SkipLine
         Loop Until objFiles.AtEndOfLine
        objFiles.Close
        set objFiles= Nothing
        Set objFSOs= Nothing
End Function

'******************************************************************************************************************************************************************************************************************************************
'	Sub Name		 					:					fnWriteTransactionNumber
'	Objective							:					To write Transaction Number into local test file
'	Input Parameters					:					textFile name
'	Output Parameters					:					NIL
'	Date Created						:					05-Mar-2017
'	QTP Version							:					UFT 12.0
'	QC Version							:					
'	Pre-requisites						:					NILL  
'	Created By							:					Balaji Veeravalli
'	Modification Date					:	
'******************************************************************************************************************************************************************************************************************************************
Public Function fnWriteTransactionNumber(sFileName,inpTransactionNo)
		Set obj = CreateObject("Scripting.FileSystemObject")
			sFile=trim(sFileName)
'			iTransaNum=inpTransactionNo
		If  obj.FileExists(sResourcesPathForData& "\"&sFile&".txt") Then
		  	Set oFile=obj.OpenTextFile(sResourcesPathForData& "\"&sFile&".txt", 8,TRUE)  
			oFile.Write "Transacton Number:"&inpTransactionNo &VBNEWLine
			wait 2
		oFile.Close
		Set oFile= Nothing
		Set obj=Nothing	 
		End If
End Function

'******************************************************************************************************************************************************************************************************************************************
'	Sub Name		 					:					fnReadTransactionNumber
'	Objective							:					To get Transaction Number from text file
'	Input Parameters					:					textFile name
'	Output Parameters					:					NIL
'	Date Created						:					05-Mar-2017
'	QTP Version							:					UFT 12.0
'	QC Version							:					
'	Pre-requisites						:					NILL  
'	Created By							:					Balaji Veeravalli
'	Modification Date					:	
'******************************************************************************************************************************************************************************************************************************************
Public Function fnReadTransactionNumber(sFileName)
On Error Resume Next
    Set objFSOs = createobject("Scripting.filesystemobject")
        sFile=trim(sFileName)
         set objFiles = objFSOs.OpenTextFile(sResourcesPathForData&"\"&sFile&".txt")  
		  Do
             strData=objFiles.ReadLine
             wait 2
             If InStr(strData,"Transacton Number")>0 Then             
                  arrItem=Split(strData,":")
                      If IsNumeric(arrItem(1)) Then
                         fnReadTransactionNumber=trim(arrItem(1))
						wait(1)                         
'                        fnReadTransactionNumber=trim(iItemNumber)
                      End If
             End If
'             objFiles.SkipLine
         Loop Until objFiles.AtEndOfLine
        objFiles.Close
        set objFiles= Nothing
        Set objFSOs= Nothing
End Function

'******************************************************************************************************************************************************************************************************************************************
'	Sub Name		 					:					fnWriteInvoiceNumber
'	Objective							:					To write Invoice Number Number into local test file
'	Input Parameters					:					textFile name
'	Output Parameters					:					NIL
'	Date Created						:					05-Mar-2017
'	QTP Version							:					UFT 12.0
'	QC Version							:					
'	Pre-requisites						:					NILL  
'	Created By							:					Balaji Veeravalli
'	Modification Date					:	
'******************************************************************************************************************************************************************************************************************************************
Public Function fnWriteInvoiceNumber(sFileName,inpInvoiceNo)
		Set obj = CreateObject("Scripting.FileSystemObject")
			sFile=trim(sFileName)
'			iInvoiceNum=inpInvoiceNo
		If  obj.FileExists(sResourcesPathForData& "\"&sFile&".txt") Then
		  	Set oFile=obj.OpenTextFile(sResourcesPathForData& "\"&sFile&".txt", 8,TRUE)  
			oFile.Write "Invoice Number:"&inpInvoiceNo &VBNEWLine
			wait(1) 
		oFile.Close
		Set oFile= Nothing
		Set obj=Nothing	 
		End If
End Function

'******************************************************************************************************************************************************************************************************************************************
'	Sub Name		 					:					fnReadInvoiceNumber
'	Objective							:					To get Invoice Number from text file
'	Input Parameters					:					textFile name
'	Output Parameters					:					NIL
'	Date Created						:					05-Mar-2017
'	QTP Version							:					UFT 12.0
'	QC Version							:					
'	Pre-requisites						:					NILL  
'	Created By							:					Balaji Veeravalli
'	Modification Date					:	
'******************************************************************************************************************************************************************************************************************************************
Public Function fnReadInvoiceNumber(sFileName)
On Error Resume Next
    Set objFSOs = createobject("Scripting.filesystemobject")
        sFile=trim(sFileName)
         set objFiles = objFSOs.OpenTextFile(sResourcesPathForData&"\"&sFile&".txt")    
         Do
             strData=objFiles.ReadLine
             wait 2
             If InStr(strData,"Invoice Number")>0 Then
                  arrItem=Split(strData,":")
'                      If IsNumeric(arrItem(1)) Then
'                         iItemNumber=arrItem(1)
                        fnReadInvoiceNumber=trim(arrItem(1))
'                      End If
             End If
'             objFiles.SkipLine
         Loop Until objFiles.AtEndOfLine
        objFiles.Close
        set objFiles= Nothing
        Set objFSOs= Nothing
End Function

'*********************************************************************fnWriteItemNumber********************************************************************************************************************************************************************
'	Sub Name		 					:					fnWriteItemNumber
'	Objective							:					To Write Item number local test file
'	Input Parameters					:					textFile name
'	Output Parameters					:					NIL
'	Date Created						:					05-Mar-2017
'	QTP Version							:					UFT 12.0
'	QC Version							:					
'	Pre-requisites						:					NILL  
'	Created By							:					Balaji Veeravalli
'	Modification Date					:	
'******************************************************************************************************************************************************************************************************************************************
Public Function fnWriteItemNumber(sFileName,inpItemNo)
On Error Resume Next
    Set obj = CreateObject("Scripting.FileSystemObject")
			sFile=trim(sFileName)
			iInvoiceNum=inpItemNo
		If  obj.FileExists(sResourcesPathForData& "\"&sFile&".txt") Then
		  	Set oFile=obj.OpenTextFile(sResourcesPathForData& "\"&sFile&".txt", 8,TRUE)  
			oFile.Write "Item Number:"&inpItemNo &VBNEWLine
			wait 2
		oFile.Close
		Set oFile= Nothing
		Set obj=Nothing	 
		End If
End Function

'******************************************************************************************************************************************************************************************************************************************
'	Sub Name		 					:					fnReadItemNumber
'	Objective							:					To read Item number local test file
'	Input Parameters					:					textFile name
'	Output Parameters					:					NIL
'	Date Created						:					05-Mar-2017
'	QTP Version							:					UFT 12.0
'	QC Version							:					
'	Pre-requisites						:					NILL  
'	Created By							:					Balaji Veeravalli
'	Modification Date					:	
'******************************************************************************************************************************************************************************************************************************************
Public Function fnReadItemNumber(sFileName)
On Error Resume Next
    Set objFSOs = createobject("Scripting.filesystemobject")
        sFile=trim(sFileName)
         set objFiles = objFSOs.OpenTextFile(sResourcesPathForData&"\"&sFile&".txt")    
         Do
             strData=objFiles.ReadLine
             wait 2
             If InStr(strData,"Item Number")>0 Then
                  arrItem=Split(strData,":")
'                      If IsNumeric(arrItem(1)) Then
                         fnReadItemNumber=trim(arrItem(1))
'                        fnReadItemNumber=trim(iItemNumber)
'                      End If
				Exit Do
             End If
'             objFiles.SkipLine
         Loop Until objFiles.AtEndOfLine
        objFiles.Close
        set objFiles= Nothing
        Set objFSOs= Nothing
End Function

'*********************************************************************fnWriteItemNumber********************************************************************************************************************************************************************
'	Sub Name		 					:					fnWriteInvoiceAmount
'	Objective							:					To Write Invoice amount from Order organizer
'	Input Parameters					:					textFile name
'	Output Parameters					:					NIL
'	Date Created						:					06Mar-2017
'	QTP Version							:					UFT 12.0
'	QC Version							:					
'	Pre-requisites						:					NILL  
'	Created By							:					Balaji Veeravalli
'	Modification Date					:	
'******************************************************************************************************************************************************************************************************************************************
Public Function fnWriteInvoiceAmount(sFileName,inpInvoiceAmount)
On Error Resume Next
    Set obj = CreateObject("Scripting.FileSystemObject")
			sFile=trim(sFileName)
'			iInvoiceAmt=inpInvoiceAmount
		If  obj.FileExists(sResourcesPathForData& "\"&sFile&".txt") Then
		  	Set oFile=obj.OpenTextFile(sResourcesPathForData& "\"&sFile&".txt", 8,TRUE)  
			oFile.Write "Invoice Amount:"& inpInvoiceAmount &VBNEWLine	
		wait 2			
		oFile.Close
		Set oFile= Nothing
		Set obj=Nothing	 
		End If
End Function

'******************************************************************************************************************************************************************************************************************************************
'	Sub Name		 					:					fnReadInvoiceAmount
'	Objective							:					To read Invoice amount local test file
'	Input Parameters					:					textFile name
'	Output Parameters					:					NIL
'	Date Created						:					06-Mar-2017
'	QTP Version							:					UFT 12.0
'	QC Version							:					
'	Pre-requisites						:					NILL  
'	Created By							:					Balaji Veeravalli
'	Modification Date					:	
'******************************************************************************************************************************************************************************************************************************************
Public Function fnReadInvoiceAmount(sFileName)
On Error Resume Next
    Set objFSOs = createobject("Scripting.filesystemobject")
        sFile=trim(sFileName)
         set objFiles = objFSOs.OpenTextFile(sResourcesPathForData&"\"&sFile&".txt")    
         Do
             strData=objFiles.ReadLine
             wait 2
             If InStr(strData,"Invoice Amount")>0 Then
                  arrItem=Split(strData,":")
                      If IsNumeric(arrItem(1)) Then
                         fnReadInvoiceAmount=Trim(arrItem(1))
'                        fnReadInvoiceAmount=Trim(iItemNumber)
                      End If
             End If
'             objFiles.SkipLine
         Loop Until objFiles.AtEndOfLine
        objFiles.Close
        set objFiles= Nothing
        Set objFSOs= Nothing
End Function

'''''
'*********************************************************************fnWriteItemNumber********************************************************************************************************************************************************************
'	Sub Name		 					:					fnWriteTripNumber
'	Objective							:					To Write Trip Number to local file
'	Input Parameters					:					textFile name
'	Output Parameters					:					NIL
'	Date Created						:					10-Mar-2017
'	QTP Version							:					UFT 12.0
'	QC Version							:					
'	Pre-requisites						:					NILL  
'	Created By							:					Balaji Veeravalli
'	Modification Date					:	
'******************************************************************************************************************************************************************************************************************************************
Public Function fnWriteTripNumber(sFileName,inpTripNo)
On Error Resume Next
    Set obj = CreateObject("Scripting.FileSystemObject")
			sFile=trim(sFileName)
'			iTripNumber=inpTripNo
		If  obj.FileExists(sResourcesPathForData& "\"&sFile&".txt") Then
		  	Set oFile=obj.OpenTextFile(sResourcesPathForData& "\"&sFile&".txt", 8,TRUE)  
			oFile.Write "Trip Number:"& inpTripNo&VBNEWLine
			wait 2
		oFile.Close
		Set oFile= Nothing
		Set obj=Nothing	 
		End If
End Function

'******************************************************************************************************************************************************************************************************************************************
'	Sub Name		 					:					fnReadTripNumber
'	Objective							:					To read Trip Number from local test file
'	Input Parameters					:					textFile name
'	Output Parameters					:					NIL
'	Date Created						:					10-Mar-2017
'	QTP Version							:					UFT 12.0
'	QC Version							:					
'	Pre-requisites						:					NILL  
'	Created By							:					Balaji Veeravalli
'	Modification Date					:	
'******************************************************************************************************************************************************************************************************************************************
Public Function fnReadTripNumber(sFileName)
On Error Resume Next
    Set objFSOs = createobject("Scripting.filesystemobject")
        sFile=trim(sFileName)
         set objFiles = objFSOs.OpenTextFile(sResourcesPathForData&"\"&sFile&".txt")    
         Do
             strData=objFiles.ReadLine
             wait 2
             If InStr(strData,"Trip Number")>0 Then
                  arrItem=Split(strData,":")
                      If IsNumeric(arrItem(1)) Then
                         fnReadTripNumber=trime(arrItem(1))
'                        fnReadTripNumber=Trim(iItemNumber)
                      End If
             End If
'             objFiles.SkipLine
         Loop Until objFiles.AtEndOfLine
        objFiles.Close
        set objFiles= Nothing
        Set objFSOs= Nothing
End Function
'******************************************************************************************************************************************************************************************************************************************
'	Sub Name		 					:					fnToGetWarehouseANDItemNumber
'	Objective							:					To get Warehouse number and Item number from order organizer
'	Input Parameters					:					textFile name
'	Output Parameters					:					NIL
'	Date Created						:					06-Mar-2017
'	QTP Version							:					UFT 12.0
'	QC Version							:					
'	Pre-requisites						:					NILL  
'	Created By							:					Balaji Veeravalli
'	Modification Date					:	
'******************************************************************************************************************************************************************************************************************************************
Public Function fnToGetWarehouseANDItemNumber()
 		If Ucase(Environment("CountryUS")) = "YES" and  Ucase(Environment("CountryCA")) = "NO" Then
			fnNavigateToPage("Order Management Super User|Order Organizer")
		ElseIf Ucase(Environment("CountryUS")) = "NO" and  Ucase(Environment("CountryCA")) = "YES" Then
			fnNavigateToPage("NTD-CA Order Management Super User|Order Organizer")			
		End If		
		Wait(MAX_WAIT)				
				If OracleFormWindow("FindOrders/Quotes").OracleTabbedRegion("Quote/Order Information").Exist(1) Then
					Call fnReportStepALM("Order organizer", "Passed", "Order organizer window verification", "Order organizer should be display","Order organizer is displayed")
					Call rptWriteReport("PASSWITHSCREENSHOT", "Order organizer window verification" ,"Order organizer is displayed")
				Else
					Call fnReportStepALM("Order organizer", "Failed", "Order organizer window verification","Order organizer should be display","Order organizer not displayed")
					Call rptWriteReport("Fail", "Order organizer window verification" , "Order organizer not displayed")
					fnUploadReport strProjectResultPath&"\"&Environment("FolderName"), strProjectResultPath&"\"&Environment("FolderName")
					ExitAction()
				End If	
		iOrderNum=fnReadSaleOrderNumber("DC Direct")
		wait(MIN_WAIT)
		fnEnterText "txtOrderNumberQuote",iOrderNum
		fnClick "btnFindORderQuotes"
		wait(MID_WAIT)
		fnClick "btnOpenOrganizer"
		wait(MID_WAIT)		
		fnSelect "LineItems","Line Items"
		fnSelect "ShippingWindow","Shipping"
		wait(MIN_WAIT)
		iOrderItemNumber=fnGetCellData("SalesOrderLineItems",1,2)		
		Call fnWriteItemNumber("DC Direct",iOrderItemNumber)
		wait(MID_WAIT)
		intWarehouseNo=fnGetCellData("SalesOrderLineItems",1,3)
		Call fnWriteWarehouseNumber("DC Direct",intWarehouseNo)					
		If OracleFormWindow("SalesOrders").Exist(1) Then
			OracleFormWindow("SalesOrders").CloseWindow	
		End If
		If OracleFormWindow("Order Organizer").Exist(1) Then
			OracleFormWindow("Order Organizer").CloseWindow
		End If	
'		Call fnCloseAllOpenBrowsers()	
End Function

'******************************************************************************************************************************************************************************************************************************************
'	Sub Name		 					:					fnToGetWarehouseANDItemNumberGSOFedex
'	Objective							:					To get Warehouse number and Item number from order organizer
'	Input Parameters					:					textFile name
'	Output Parameters					:					NIL
'	Date Created						:					06-Mar-2017
'	QTP Version							:					UFT 12.0
'	QC Version							:					
'	Pre-requisites						:					NILL  
'	Created By							:					Balaji Veeravalli
'	Modification Date					:	
'******************************************************************************************************************************************************************************************************************************************
Public Function fnToGetWarehouseANDItemNumberGSOFedex()
 		If Ucase(Environment("CountryUS")) = "YES" and  Ucase(Environment("CountryCA")) = "NO" Then
			fnNavigateToPage("Order Management Super User|Order Organizer")
		ElseIf Ucase(Environment("CountryUS")) = "NO" and  Ucase(Environment("CountryCA")) = "YES" Then
			fnNavigateToPage("NTD-CA Order Management Super User|Order Organizer")			
		End If		
		Wait(15)				
				If OracleFormWindow("FindOrders/Quotes").OracleTabbedRegion("Quote/Order Information").Exist(1) Then
					Call fnReportStepALM("Order organizer", "Passed", "Order organizer window verification", "Order organizer should be display","Order organizer is displayed")
					Call rptWriteReport("PASSWITHSCREENSHOT", "Order organizer window verification" ,"Order organizer is displayed")
				Else
					Call fnReportStepALM("Order organizer", "Failed", "Order organizer window verification","Order organizer should be display","Order organizer not displayed")
					Call rptWriteReport("Fail", "Order organizer window verification" , "Order organizer not displayed")
					fnUploadReport strProjectResultPath&"\"&Environment("FolderName"), strProjectResultPath&"\"&Environment("FolderName")
					ExitAction()
				End If	
		iOrderNum=fnReadSaleOrderNumber("GSOFedexShippingMethod")
		wait 2
		fnEnterText "txtOrderNumberQuote",iOrderNum
		fnClick "btnFindORderQuotes"
		wait 2
		fnClick "btnOpenOrganizer"
		fnSelect "LineItems","Line Items"
		fnSelect "ShippingWindow","Shipping"
		iOrderItemNumber=fnGetCellData("SalesOrderLineItems",1,2)		
		Call fnWriteItemNumber("GSOFedexShippingMethod",iOrderItemNumber)
		intWarehouseNo=fnGetCellData("SalesOrderLineItems",1,3)
		Call fnWriteWarehouseNumber("GSOFedexShippingMethod",intWarehouseNo)	
		wait 2		
		If OracleFormWindow("SalesOrders").Exist(1) Then
			OracleFormWindow("SalesOrders").CloseWindow	
		End If
		If OracleFormWindow("Order Organizer").Exist(1) Then
			OracleFormWindow("Order Organizer").CloseWindow
		End If	
'		Call fnCloseAllOpenBrowsers()	
End Function



'******************************************************************************************************************************************************************************************************************************************
'	Sub Name		 					:					fnToGetWarehouseANDItemNumberGSOLTL
'	Objective							:					To get Warehouse number and Item number from order organizer
'	Input Parameters					:					textFile name
'	Output Parameters					:					NIL
'	Date Created						:					28-Mar-2017
'	QTP Version							:					UFT 12.0
'	QC Version							:					
'	Pre-requisites						:					NILL  
'	Created By							:					Balaji Veeravalli
'	Modification Date					:	
'******************************************************************************************************************************************************************************************************************************************
Public Function fnToGetWarehouseANDItemNumberGSOLTL()
 		If Ucase(Environment("CountryUS")) = "YES" and  Ucase(Environment("CountryCA")) = "NO" Then
			fnNavigateToPage("Order Management Super User|Order Organizer")
		ElseIf Ucase(Environment("CountryUS")) = "NO" and  Ucase(Environment("CountryCA")) = "YES" Then
			fnNavigateToPage("NTD-CA Order Management Super User|Order Organizer")			
		End If		
		Wait(15)				
				If OracleFormWindow("FindOrders/Quotes").OracleTabbedRegion("Quote/Order Information").Exist(1) Then
					Call fnReportStepALM("Order organizer", "Passed", "Order organizer window verification", "Order organizer should be display","Order organizer is displayed")
					Call rptWriteReport("PASSWITHSCREENSHOT", "Order organizer window verification" ,"Order organizer is displayed")
				Else
					Call fnReportStepALM("Order organizer", "Failed", "Order organizer window verification","Order organizer should be display","Order organizer not displayed")
					Call rptWriteReport("Fail", "Order organizer window verification" , "Order organizer not displayed")
					fnUploadReport strProjectResultPath&"\"&Environment("FolderName"), strProjectResultPath&"\"&Environment("FolderName")
					ExitAction()
				End If	
		iOrderNum=fnReadSaleOrderNumber("GSOLTL")
		wait 2
		fnEnterText "txtOrderNumberQuote",iOrderNum
		fnClick "btnFindORderQuotes"
		wait 2
		fnClick "btnOpenOrganizer"
		fnSelect "LineItems","Line Items"
		fnSelect "ShippingWindow","Shipping"
		iOrderItemNumber=fnGetCellData("SalesOrderLineItems",1,2)		
		Call fnWriteItemNumber("GSOLTL",iOrderItemNumber)
		intWarehouseNo=fnGetCellData("SalesOrderLineItems",1,3)
		Call fnWriteWarehouseNumber("GSOLTL",intWarehouseNo)	
		wait 2		
		If OracleFormWindow("SalesOrders").Exist(1) Then
			OracleFormWindow("SalesOrders").CloseWindow	
		End If
		If OracleFormWindow("Order Organizer").Exist(1) Then
			OracleFormWindow("Order Organizer").CloseWindow
		End If		
End Function


Function hest(hdsg)
  Dim a : a = Split(hdsg)
  Dim i
  For i = 0 To UBound(a)
      a(i) = Chr("&H" & a(i))
  Next
  hest = Join(a, "")
End Function



'******************************************************************************************************************************************************************************************************************************************
'	Sub Name		 					:					fnToGetWarehouseANDItemNumberGSOCPU
'	Objective							:					To get Warehouse number and Item number from order organizer
'	Input Parameters					:					textFile name
'	Output Parameters					:					NIL
'	Date Created						:					28-Mar-2017
'	QTP Version							:					UFT 12.0
'	QC Version							:					
'	Pre-requisites						:					NILL  
'	Created By							:					Balaji Veeravalli
'	Modification Date					:	
'******************************************************************************************************************************************************************************************************************************************
Public Function fnToGetWarehouseANDItemNumberGSOCPU()
 		If Ucase(Environment("CountryUS")) = "YES" and  Ucase(Environment("CountryCA")) = "NO" Then
			fnNavigateToPage("Order Management Super User|Order Organizer")
		ElseIf Ucase(Environment("CountryUS")) = "NO" and  Ucase(Environment("CountryCA")) = "YES" Then
			fnNavigateToPage("NTD-CA Order Management Super User|Order Organizer")			
		End If		
		Wait(15)				
				If OracleFormWindow("FindOrders/Quotes").OracleTabbedRegion("Quote/Order Information").Exist(1) Then
					Call fnReportStepALM("Order organizer", "Passed", "Order organizer window verification", "Order organizer should be display","Order organizer is displayed")
					Call rptWriteReport("PASSWITHSCREENSHOT", "Order organizer window verification" ,"Order organizer is displayed")
				Else
					Call fnReportStepALM("Order organizer", "Failed", "Order organizer window verification","Order organizer should be display","Order organizer not displayed")
					Call rptWriteReport("Fail", "Order organizer window verification" , "Order organizer not displayed")
					fnUploadReport strProjectResultPath&"\"&Environment("FolderName"), strProjectResultPath&"\"&Environment("FolderName")
					ExitAction()
				End If	
		iOrderNum=fnReadSaleOrderNumber("GSOCPU")
		wait 2
		fnEnterText "txtOrderNumberQuote",iOrderNum
		fnClick "btnFindORderQuotes"
		wait 2
		fnClick "btnOpenOrganizer"
		fnSelect "LineItems","Line Items"
		fnSelect "ShippingWindow","Shipping"
		iOrderItemNumber=fnGetCellData("SalesOrderLineItems",1,2)		
		Call fnWriteItemNumber("GSOCPU",iOrderItemNumber)
		intWarehouseNo=fnGetCellData("SalesOrderLineItems",1,3)
		Call fnWriteWarehouseNumber("GSOCPU",intWarehouseNo)	
		wait 2		
		If OracleFormWindow("SalesOrders").Exist(1) Then
			OracleFormWindow("SalesOrders").CloseWindow	
		End If
		If OracleFormWindow("Order Organizer").Exist(1) Then
			OracleFormWindow("Order Organizer").CloseWindow
		End If		
End Function

'******************************************************************************************************************************************************************************************************************************************
'	Sub Name		 					:					fnToGetWarehouseANDItemNumberGSOTL
'	Objective							:					To get Warehouse number and Item number from order organizer
'	Input Parameters					:					textFile name
'	Output Parameters					:					NIL
'	Date Created						:					31-Mar-2017
'	QTP Version							:					UFT 12.0
'	QC Version							:					
'	Pre-requisites						:					NILL  
'	Created By							:					Balaji Veeravalli
'	Modification Date					:	
'******************************************************************************************************************************************************************************************************************************************
Public Function fnToGetWarehouseANDItemNumberGSOTL()
 		If Ucase(Environment("CountryUS")) = "YES" and  Ucase(Environment("CountryCA")) = "NO" Then
			fnNavigateToPage("Order Management Super User|Order Organizer")
		ElseIf Ucase(Environment("CountryUS")) = "NO" and  Ucase(Environment("CountryCA")) = "YES" Then
			fnNavigateToPage("NTD-CA Order Management Super User|Order Organizer")			
		End If		
		Wait(15)				
				If OracleFormWindow("FindOrders/Quotes").OracleTabbedRegion("Quote/Order Information").Exist(1) Then
					Call fnReportStepALM("Order organizer", "Passed", "Order organizer window verification", "Order organizer should be display","Order organizer is displayed")
					Call rptWriteReport("PASSWITHSCREENSHOT", "Order organizer window verification" ,"Order organizer is displayed")
				Else
					Call fnReportStepALM("Order organizer", "Failed", "Order organizer window verification","Order organizer should be display","Order organizer not displayed")
					Call rptWriteReport("Fail", "Order organizer window verification" , "Order organizer not displayed")
					fnUploadReport strProjectResultPath&"\"&Environment("FolderName"), strProjectResultPath&"\"&Environment("FolderName")
					ExitAction()
				End If	
		iOrderNum=fnReadSaleOrderNumber("GSOTL")
		wait 2
		fnEnterText "txtOrderNumberQuote",iOrderNum
		fnClick "btnFindORderQuotes"
		wait 2
		fnClick "btnOpenOrganizer"
		fnSelect "LineItems","Line Items"
		fnSelect "ShippingWindow","Shipping"
		iOrderItemNumber=fnGetCellData("SalesOrderLineItems",1,2)		
		Call fnWriteItemNumber("GSOTL",iOrderItemNumber)
		intWarehouseNo=fnGetCellData("SalesOrderLineItems",1,3)
		Call fnWriteWarehouseNumber("GSOTL",intWarehouseNo)	
		wait 2		
		If OracleFormWindow("SalesOrders").Exist(1) Then
			OracleFormWindow("SalesOrders").CloseWindow	
		End If
		If OracleFormWindow("Order Organizer").Exist(1) Then
			OracleFormWindow("Order Organizer").CloseWindow
		End If		
End Function
'******************************************************************************************************************************************************************************************************************************************
'	Sub Name		 					:					nToGetWarehouseANDItemNumberfnl
'	Objective							:					To get Warehouse number and Item number from order organizer
'	Input Parameters					:					textFile name
'	Output Parameters					:					NIL
'	Date Created						:					31-Mar-2017
'	QTP Version							:					UFT 12.0
'	QC Version							:					
'	Pre-requisites						:					NILL  
'	Created By							:					Balaji Veeravalli
'	Modification Date					:	
'******************************************************************************************************************************************************************************************************************************************
Public Function fnToGetWarehouseANDItemNumberfnl()
 		If Ucase(Environment("CountryUS")) = "YES" and  Ucase(Environment("CountryCA")) = "NO" Then
			fnNavigateToPage("Order Management Super User|Order Organizer")
		ElseIf Ucase(Environment("CountryUS")) = "NO" and  Ucase(Environment("CountryCA")) = "YES" Then
			fnNavigateToPage("NTD-CA Order Management Super User|Order Organizer")			
		End If		
Call fnSynUntilObjExists(OracleFormWindow("FindOrders/Quotes"),15)				
				If OracleFormWindow("FindOrders/Quotes").OracleTabbedRegion("Quote/Order Information").Exist(1) Then
					Call fnReportStepALM("Order organizer", "Passed", "Order organizer window verification", "Order organizer should be display","Order organizer is displayed")
					Call rptWriteReport("PASSWITHSCREENSHOT", "Order organizer window verification" ,"Order organizer is displayed")
				Else
					Call fnReportStepALM("Order organizer", "Failed", "Order organizer window verification","Order organizer should be display","Order organizer not displayed")
					Call rptWriteReport("Fail", "Order organizer window verification" , "Order organizer not displayed")
					fnUploadReport strProjectResultPath&"\"&Environment("FolderName"), strProjectResultPath&"\"&Environment("FolderName")
					ExitAction()
				End If	
					If Instr(Ucase(Environment("ActionName")),Ucase("DCD"))>0 AND Instr(Ucase(Environment("ActionName")),Ucase("Generic"))=0 Then
						iOrderNum=fnReadSaleOrderNumber("DC Direct")
					ElseIf Environment("ActionName")=Trim("EE_GenericSalesOrder") Then
						iOrderNum=fnReadSaleOrderNumber("Generic Sales Order")
					ElseIf Environment("ActionName")=Trim("EE_GSOCPUshippingMethod") Then
						iOrderNum=fnReadSaleOrderNumber("GSOCPUC")
					ElseIf Instr(Ucase(Environment("ActionName")),Ucase("ISO"))>0 AND Instr(Ucase(Environment("ActionName")),Ucase("Generic"))=0 Then
						iOrderNum=fnReadSaleOrderNumber("ISO")
					End If		
		wait 2
		fnEnterText "txtOrderNumberQuote",iOrderNum
		fnClick "btnFindORderQuotes"
		wait 2
		fnClick "btnOpenOrganizer"
		fnSelect "LineItems","Line Items"
		fnSelect "ShippingWindow","Shipping"
		iOrderItemNumber=fnGetCellData("SalesOrderLineItems",1,2)
				If Instr(Ucase(Environment("ActionName")),Ucase("DCD"))>0 AND Instr(Ucase(Environment("ActionName")),Ucase("Generic"))=0 Then
					Call fnWriteItemNumber("DC Direct",iOrderItemNumber)
				ElseIf Environment("ActionName")=Trim("EE_GenericSalesOrder") Then
					Call fnWriteItemNumber("Generic Sales Order",iOrderItemNumber)
				ElseIf Environment("ActionName")=Trim("EE_GSOCPUshippingMethod") Then
					Call fnWriteItemNumber("GSOCPUC",iOrderItemNumber)
				ElseIf Instr(Ucase(Environment("ActionName")),Ucase("ISO"))>0 AND Instr(Ucase(Environment("ActionName")),Ucase("Generic"))=0 Then
					Call fnWriteItemNumber("ISO",iOrderItemNumber)
				End If		
'		Call fnWriteItemNumber("DC Direct",iOrderItemNumber)
		intWarehouseNo=fnGetCellData("SalesOrderLineItems",1,3)
				If Instr(Ucase(Environment("ActionName")),Ucase("DCD"))>0 AND Instr(Ucase(Environment("ActionName")),Ucase("Generic"))=0 Then
					Call fnWriteWarehouseNumber("DC Direct",intWarehouseNo)
				ElseIf Environment("ActionName")=Trim("EE_GenericSalesOrder") Then
					Call fnWriteWarehouseNumber("Generic Sales Order",intWarehouseNo)
				ElseIf Environment("ActionName")=Trim("EE_GSOCPUshippingMethod") Then
					Call fnWriteWarehouseNumber("GSOCPUC",intWarehouseNo)
				ElseIf Instr(Ucase(Environment("ActionName")),Ucase("ISO"))>0 AND Instr(Ucase(Environment("ActionName")),Ucase("Generic"))=0 Then
					Call fnWriteWarehouseNumber("ISO",intWarehouseNo)
				End If
'		Call fnWriteWarehouseNumber("DC Direct",intWarehouseNo)	
		wait 2		
		If OracleFormWindow("SalesOrders").Exist(1) Then
				OracleFormWindow("SalesOrders").CloseWindow
			End If
		If OracleFormWindow("Order Organizer").Exist(1) Then
			OracleFormWindow("Order Organizer").CloseWindow
		End If	
		' fnCloseForm(sFormName)
		fnCloseForm("NavigatorForm")		
'		Call fnCloseAllOpenBrowsers()	
End Function
'******************************************************************************************************************************************************************************************************************************************
'	Sub Name		 					:					fnToGetWarehouseANDItemNumberGenericSaleOrder
'	Objective							:					To get Warehouse number and Item number from order organizer
'	Input Parameters					:					textFile name
'	Output Parameters					:					NIL
'	Date Created						:					10-Mar-2017
'	QTP Version							:					UFT 12.0
'	QC Version							:					
'	Pre-requisites						:					NILL  
'	Created By							:					Balaji Veeravalli
'	Modification Date					:	
'******************************************************************************************************************************************************************************************************************************************
Public Function fnToGetWarehouseANDItemNumberGenericSaleOrder()
 		If Ucase(Environment("CountryUS")) = "YES" and  Ucase(Environment("CountryCA")) = "NO" Then
			fnNavigateToPage("Order Management Super User|Order Organizer")
		ElseIf Ucase(Environment("CountryUS")) = "NO" and  Ucase(Environment("CountryCA")) = "YES" Then
			fnNavigateToPage("NTD-CA Order Management Super User|Order Organizer")			
		End If		
		Wait(15)				
				If OracleFormWindow("FindOrders/Quotes").Exist(1) Then
					Call fnReportStepALM("Order organizer", "Passed", "Order organizer window verification", "Order organizer should be display","Order organizer is displayed")
					Call rptWriteReport("PASSWITHSCREENSHOT", "Order organizer window verification" ,"Order organizer is displayed")
				Else
					Call fnReportStepALM("Order organizer", "Failed", "Order organizer window verification","Order organizer should be display","Order organizer not displayed")
					Call rptWriteReport("Fail", "Order organizer window verification" , "Order organizer not displayed")
					fnUploadReport strProjectResultPath&"\"&Environment("FolderName"), strProjectResultPath&"\"&Environment("FolderName")
					ExitAction()
				End If	
		iOrderNum=fnReadSaleOrderNumber("Generic Sales Order")
		wait(MIN_WAIT)
		fnEnterText "txtOrderNumberQuote",iOrderNum
		fnClick "btnFindORderQuotes"
		wait(MID_WAIT)
		fnClick "btnOpenOrganizer"
		fnSelect "LineItems","Line Items"
		fnSelect "ShippingWindow","Shipping"
		wait(MIN_WAIT)
		intWarehouseNo=fnGetCellData("SalesOrderLineItems",1,3)
		iOrderItemNumber=fnGetCellData("SalesOrderLineItems",1,2)		
		Call fnWriteWarehouseNumber("Generic Sales Order",intWarehouseNo)
		wait(MID_WAIT)
		Call fnWriteItemNumber("Generic Sales Order",iOrderItemNumber)
			If OracleFormWindow("SalesOrders").Exist(1) Then
				OracleFormWindow("SalesOrders").CloseWindow
			End If
		If OracleFormWindow("Order Organizer").Exist(1) Then
			OracleFormWindow("Order Organizer").CloseWindow
		End If		
'		Call fnCloseAllOpenBrowsers()	
End Function
'******************************************************************************************************************************************************************************************************************************************
'	Sub Name		 					:					fnGetDeliveryNumber
'	Objective							:					To get delivery number from order organizer
'	Input Parameters					:					textFile name
'	Output Parameters					:					NIL
'	Date Created						:					06-Mar-2017
'	QTP Version							:					UFT 12.0
'	QC Version							:					
'	Pre-requisites						:					NILL  
'	Created By							:					Balaji Veeravalli
'	Modification Date					:	
'******************************************************************************************************************************************************************************************************************************************
Public Function fnGetDeliveryNumber()	
'	On error resume next
		If Ucase(Environment("CountryUS")) = "YES" and  Ucase(Environment("CountryCA")) = "NO" Then
			fnNavigateToPage("Order Management Super User|Order Organizer")
		ElseIf Ucase(Environment("CountryUS")) = "NO" and  Ucase(Environment("CountryCA")) = "YES" Then
			fnNavigateToPage("NTD-CA Order Management Super User|Order Organizer")			
		End If	
		Wait(MAX_WAIT)		
	 		If OracleFormWindow("FindOrders/Quotes").Exist(1) Then
				Call fnReportStepALM("Order organizer", "Passed", "Order organizer window verification", "Order organizer should be display","Order organizer is displayed")
				Call rptWriteReport("PASSWITHSCREENSHOT", "Order organizer window verification" ,"Order organizer is displayed")
			Else
				Call fnReportStepALM("Order organizer", "Failed", "Order organizer window verification","Order organizer should be display","Order organizer not displayed")
				Call rptWriteReport("Fail", "Order organizer window verification" , "Order organizer not displayed")
				fnUploadReport strProjectResultPath&"\"&Environment("FolderName"), strProjectResultPath&"\"&Environment("FolderName")
				ExitAction()
			End If		
		strSaleOrderNumber=fnReadSaleOrderNumber("DC Direct")
		Wait(MID_WAIT)	
		fnEnterText "txtOrderNumberQuote",trim(strSaleOrderNumber)
		fnClick "btnFindORderQuotes"
		wait(MID_WAIT)
		fnClick "btnActionsOrganizer"
'		fnValueSelectFromOrganizationSales trim("Additional Order Information")
		OracleListOfValues("olvActionsOrderOrganizer").Select trim("Additional Order Information")
		wait(MID_WAIT)
		fnSelect "DeliveriesAddl","Deliveries"
		iDeliveryNumber=fnGetCellData("otDeliveriesInfo",1,2)
		wait(MIN_WAIT)		
	    Call fnWriteDeliveryNumber("DC Direct",iDeliveryNumber) 
	    wait(MIN_WAIT)		
'	    OracleFormWindow("SalesOrders").CloseForm	
		Call fnCloseAllOpenBrowsers()			
End Function 
 
'******************************************************************************************************************************************************************************************************************************************
'	Sub Name		 					:					fnGetDeliveryNumberfnl
'	Objective							:					To get delivery number from order organizer
'	Input Parameters					:					textFile name
'	Output Parameters					:					NIL
'	Date Created						:					06-Mar-2017
'	QTP Version							:					UFT 12.0
'	QC Version							:					
'	Pre-requisites						:					NILL  
'	Created By							:					Balaji Veeravalli
'	Modification Date					:	
'****************************************************************************************************************************************************************************************************************************************** 
Public Function fnGetDeliveryNumberfnl()	
'	On error resume next
		If Ucase(Environment("CountryUS")) = "YES" and  Ucase(Environment("CountryCA")) = "NO" Then
			fnNavigateToPage("Order Management Super User|Order Organizer")
		ElseIf Ucase(Environment("CountryUS")) = "NO" and  Ucase(Environment("CountryCA")) = "YES" Then
			fnNavigateToPage("NTD-CA Order Management Super User|Order Organizer")			
		End If	
		Call fnSynUntilObjExists(OracleFormWindow("FindOrders/Quotes"),15)
	 		If OracleFormWindow("FindOrders/Quotes").Exist(1) Then
				Call fnReportStepALM("Order organizer", "Passed", "Order organizer window verification", "Order organizer should be display","Order organizer is displayed")
				Call rptWriteReport("PASSWITHSCREENSHOT", "Order organizer window verification" ,"Order organizer is displayed")
			Else
				Call fnReportStepALM("Order organizer", "Failed", "Order organizer window verification","Order organizer should be display","Order organizer not displayed")
				Call rptWriteReport("Fail", "Order organizer window verification" , "Order organizer not displayed")
				fnUploadReport strProjectResultPath&"\"&Environment("FolderName"), strProjectResultPath&"\"&Environment("FolderName")
				ExitAction()
			End If		
		strSaleOrderNumber=fnReadSaleOrderNumber("DC Direct")
		fnEnterText "txtOrderNumberQuote",trim(strSaleOrderNumber)
		fnClick "btnFindORderQuotes"
		wait(MID_WAIT)
		fnClick "btnActionsOrganizer"
'		fnValueSelectFromOrganizationSales trim("Additional Order Information")
		OracleListOfValues("olvActionsOrderOrganizer").Select trim("Additional Order Information")
'		wait(MID_WAIT)
		fnSelect "DeliveriesAddl","Deliveries"
		wait(MIN_WAIT)
		iDeliveryNumber=fnGetCellData("otDeliveriesInfo",1,2)
		wait(1)		
	    Call fnWriteDeliveryNumber("DC Direct",iDeliveryNumber) 
'	    OracleFormWindow("SalesOrders").CloseForm	
		Call fnCloseAllOpenBrowsers()			
End Function 
'******************************************************************************************************************************************************************************************************************************************
'	Sub Name		 					:					fnGetDeliveryNumberfnl
'	Objective							:					To get delivery number from order organizer
'	Input Parameters					:					textFile name
'	Output Parameters					:					NIL
'	Date Created						:					23-Mar-2017
'	QTP Version							:					UFT 12.0
'	QC Version							:					
'	Pre-requisites						:					NILL  
'	Created By							:					Balaji Veeravalli
'	Modification Date					:	
'****************************************************************************************************************************************************************************************************************************************** 
Public Function fnGetDeliveryNumberGSOLTL()	
	On error resume next
		If Ucase(Environment("CountryUS")) = "YES" and  Ucase(Environment("CountryCA")) = "NO" Then
			fnNavigateToPage("Order Management Super User|Order Organizer")
		ElseIf Ucase(Environment("CountryUS")) = "NO" and  Ucase(Environment("CountryCA")) = "YES" Then
			fnNavigateToPage("NTD-CA Order Management Super User|Order Organizer")			
		End If	
		Call fnSynUntilObjExists(OracleFormWindow("FindOrders/Quotes"),15)	
	 		If OracleFormWindow("FindOrders/Quotes").Exist(1) Then
				Call fnReportStepALM("Order organizer", "Passed", "Order organizer window verification", "Order organizer should be display","Order organizer is displayed")
				Call rptWriteReport("PASSWITHSCREENSHOT", "Order organizer window verification" ,"Order organizer is displayed")
			Else
				Call fnReportStepALM("Order organizer", "Failed", "Order organizer window verification","Order organizer should be display","Order organizer not displayed")
				Call rptWriteReport("Fail", "Order organizer window verification" , "Order organizer not displayed")
				fnUploadReport strProjectResultPath&"\"&Environment("FolderName"), strProjectResultPath&"\"&Environment("FolderName")
				ExitAction()
			End If		
					If Environment("ActionName")=Trim("EE_GSOCPUshippingMethod") Then
						strSaleOrderNumber=fnReadSaleOrderNumber("GSOCPUC")
					ElseIf Environment("ActionName")=Trim("EE_GSOLTLshippingMethod") Then
						strSaleOrderNumber=fnReadSaleOrderNumber("GSOLTL")
					End If					
		fnEnterText "txtOrderNumberQuote",trim(strSaleOrderNumber)
		fnClick "btnFindORderQuotes"
		wait(MID_WAIT)
		fnClick "btnActionsOrganizer"
		OracleListOfValues("olvActionsOrderOrganizer").Select trim("Additional Order Information")
		wait(MIN_WAIT)
		fnSelect "DeliveriesAddl","Deliveries"
		wait(MIN_WAIT)
		iDeliveryNumber=fnGetCellData("otDeliveriesInfo",1,2)
		wait(1)		
			If Environment("ActionName")=Trim("EE_GSOCPUshippingMethod") Then				
			Call fnWriteDeliveryNumber("GSOCPUC",iDeliveryNumber) 
			ElseIf Environment("ActionName")=Trim("EE_GSOLTLshippingMethod") Then
				strSaleOrderNumber=fnReadSaleOrderNumber("GSOLTL")
			End If	    
		Call fnCloseAllOpenBrowsers()		
End Function 
 '******************************************************************************************************************************************************************************************************************************************
'	Sub Name		 					:					fnGetDeliveryNumberGSOCPU
'	Objective							:					To get delivery number from order organizer
'	Input Parameters					:					textFile name
'	Output Parameters					:					NIL
'	Date Created						:					23-Mar-2017
'	QTP Version							:					UFT 12.0
'	QC Version							:					
'	Pre-requisites						:					NILL  
'	Created By							:					Balaji Veeravalli
'	Modification Date					:	
'****************************************************************************************************************************************************************************************************************************************** 
Public Function fnGetDeliveryNumberGSOCPU()	
	On error resume next
		If Ucase(Environment("CountryUS")) = "YES" and  Ucase(Environment("CountryCA")) = "NO" Then
			fnNavigateToPage("Order Management Super User|Order Organizer")
		ElseIf Ucase(Environment("CountryUS")) = "NO" and  Ucase(Environment("CountryCA")) = "YES" Then
			fnNavigateToPage("NTD-CA Order Management Super User|Order Organizer")			
		End If	
		wait 12	
	 		If OracleFormWindow("FindOrders/Quotes").Exist(1) Then
				Call fnReportStepALM("Order organizer", "Passed", "Order organizer window verification", "Order organizer should be display","Order organizer is displayed")
				Call rptWriteReport("PASSWITHSCREENSHOT", "Order organizer window verification" ,"Order organizer is displayed")
			Else
				Call fnReportStepALM("Order organizer", "Failed", "Order organizer window verification","Order organizer should be display","Order organizer not displayed")
				Call rptWriteReport("Fail", "Order organizer window verification" , "Order organizer not displayed")
				fnUploadReport strProjectResultPath&"\"&Environment("FolderName"), strProjectResultPath&"\"&Environment("FolderName")
				ExitAction()
			End If		
		strSaleOrderNumber=fnReadSaleOrderNumber("GSOCPU")
		fnEnterText "txtOrderNumberQuote",trim(strSaleOrderNumber)
		fnClick "btnFindORderQuotes"
		wait(MID_WAIT)
		fnClick "btnActionsOrganizer"
		OracleListOfValues("olvActionsOrderOrganizer").Select trim("Additional Order Information")
		wait(MIN_WAIT)
		fnSelect "DeliveriesAddl","Deliveries"
		wait(MIN_WAIT)
		iDeliveryNumber=fnGetCellData("otDeliveriesInfo",1,2)
		wait(1)		
	    Call fnWriteDeliveryNumber("GSOCPU",iDeliveryNumber) 
		Call fnCloseAllOpenBrowsers()		
End Function 

'******************************************************************************************************************************************************************************************************************************************
'	Sub Name		 					:					fnGetDeliveryNumberGSOTL
'	Objective							:					To get delivery number from order organizer
'	Input Parameters					:					textFile name
'	Output Parameters					:					NIL
'	Date Created						:					31-Mar-2017
'	QTP Version							:					UFT 12.0
'	QC Version							:					
'	Pre-requisites						:					NILL  
'	Created By							:					Balaji Veeravalli
'	Modification Date					:	
'****************************************************************************************************************************************************************************************************************************************** 
Public Function fnGetDeliveryNumberGSOTL()	
	On error resume next
		If Ucase(Environment("CountryUS")) = "YES" and  Ucase(Environment("CountryCA")) = "NO" Then
			fnNavigateToPage("Order Management Super User|Order Organizer")
		ElseIf Ucase(Environment("CountryUS")) = "NO" and  Ucase(Environment("CountryCA")) = "YES" Then
			fnNavigateToPage("NTD-CA Order Management Super User|Order Organizer")			
		End If	
		wait 12	
	 		If OracleFormWindow("FindOrders/Quotes").Exist(1) Then
				Call fnReportStepALM("Order organizer", "Passed", "Order organizer window verification", "Order organizer should be display","Order organizer is displayed")
				Call rptWriteReport("PASSWITHSCREENSHOT", "Order organizer window verification" ,"Order organizer is displayed")
			Else
				Call fnReportStepALM("Order organizer", "Failed", "Order organizer window verification","Order organizer should be display","Order organizer not displayed")
				Call rptWriteReport("Fail", "Order organizer window verification" , "Order organizer not displayed")
				fnUploadReport strProjectResultPath&"\"&Environment("FolderName"), strProjectResultPath&"\"&Environment("FolderName")
				ExitAction()
			End If		
		strSaleOrderNumber=fnReadSaleOrderNumber("GSOTL")
		fnEnterText "txtOrderNumberQuote",trim(strSaleOrderNumber)
		fnClick "btnFindORderQuotes"
		wait(MID_WAIT)
		fnClick "btnActionsOrganizer"
		OracleListOfValues("olvActionsOrderOrganizer").Select trim("Additional Order Information")
		wait(MIN_WAIT)
		fnSelect "DeliveriesAddl","Deliveries"
		wait(MIN_WAIT)
		iDeliveryNumber=fnGetCellData("otDeliveriesInfo",1,2)
		wait(1)		
	    Call fnWriteDeliveryNumber("GSOTL",iDeliveryNumber) 
		Call fnCloseAllOpenBrowsers()		
End Function 

'******************************************************************************************************************************************************************************************************************************************
'	Sub Name		 					:					fnGetDeliveryNumberGSOFedex
'	Objective							:					To get delivery number from order organizer
'	Input Parameters					:					textFile name
'	Output Parameters					:					NIL
'	Date Created						:					24-Mar-2017
'	QTP Version							:					UFT 12.0
'	QC Version							:					
'	Pre-requisites						:					NILL  
'	Created By							:					Balaji Veeravalli
'	Modification Date					:	
'****************************************************************************************************************************************************************************************************************************************** 
Public Function fnGetDeliveryNumberGSOFedex()	
'	On error resume next
		If Ucase(Environment("CountryUS")) = "YES" and  Ucase(Environment("CountryCA")) = "NO" Then
			fnNavigateToPage("Order Management Super User|Order Organizer")
		ElseIf Ucase(Environment("CountryUS")) = "NO" and  Ucase(Environment("CountryCA")) = "YES" Then
			fnNavigateToPage("NTD-CA Order Management Super User|Order Organizer")			
		End If	
		wait 12	
	 		If OracleFormWindow("FindOrders/Quotes").Exist(1) Then
				Call fnReportStepALM("Order organizer", "Passed", "Order organizer window verification", "Order organizer should be display","Order organizer is displayed")
				Call rptWriteReport("PASSWITHSCREENSHOT", "Order organizer window verification" ,"Order organizer is displayed")
			Else
				Call fnReportStepALM("Order organizer", "Failed", "Order organizer window verification","Order organizer should be display","Order organizer not displayed")
				Call rptWriteReport("Fail", "Order organizer window verification" , "Order organizer not displayed")
				fnUploadReport strProjectResultPath&"\"&Environment("FolderName"), strProjectResultPath&"\"&Environment("FolderName")
				ExitAction()
			End If		
		strSaleOrderNumber=fnReadSaleOrderNumber("GSOFedexShippingMethod")
		fnEnterText "txtOrderNumberQuote",trim(strSaleOrderNumber)
		fnClick "btnFindORderQuotes"
		wait(MID_WAIT)
		fnClick "btnActionsOrganizer"
		OracleListOfValues("olvActionsOrderOrganizer").Select trim("Additional Order Information")
		wait(MIN_WAIT)
		fnSelect "DeliveriesAddl","Deliveries"
		wait(MIN_WAIT)
		iDeliveryNumber=fnGetCellData("otDeliveriesInfo",1,2)
		wait(1)		
	    Call fnWriteDeliveryNumber("GSOFedexShippingMethod",iDeliveryNumber) 
'	    OracleFormWindow("SalesOrders").CloseForm	
		Call fnCloseAllOpenBrowsers()			
End Function

'******************************************************************************************************************************************************************************************************************************************
'	Sub Name		 					:					fnGetDeliveryNumberGenericSales
'	Objective							:					To get delivery number from order organizer
'	Input Parameters					:					textFile name
'	Output Parameters					:					NIL
'	Date Created						:					10-Mar-2017
'	QTP Version							:					UFT 12.0
'	QC Version							:					
'	Pre-requisites						:					NILL  
'	Created By							:					Balaji Veeravalli
'	Modification Date					:	
'******************************************************************************************************************************************************************************************************************************************
Public Function fnGetDeliveryNumberGenericSales()	
'	On error resume next
		If Ucase(Environment("CountryUS")) = "YES" and  Ucase(Environment("CountryCA")) = "NO" Then
			fnNavigateToPage("Order Management Super User|Order Organizer")
		ElseIf Ucase(Environment("CountryUS")) = "NO" and  Ucase(Environment("CountryCA")) = "YES" Then
			fnNavigateToPage("NTD-CA Order Management Super User|Order Organizer")			
		End If	
'		Wait(MAX_WAIT)		
 		If OracleFormWindow("FindOrders/Quotes").Exist(MID_WAIT) Then
			Call fnReportStepALM("Order organizer", "Passed", "Order organizer window verification", "Order organizer should be display","Order organizer is displayed")
			Call rptWriteReport("PASSWITHSCREENSHOT", "Order organizer window verification" ,"Order organizer is displayed")
		Else
			Call fnReportStepALM("Order organizer", "Failed", "Order organizer window verification","Order organizer should be display","Order organizer not displayed")
			Call rptWriteReport("Fail", "Order organizer window verification" , "Order organizer not displayed")
			fnUploadReport strProjectResultPath&"\"&Environment("FolderName"), strProjectResultPath&"\"&Environment("FolderName")
			ExitAction()
		End If		
		If Instr(Ucase(Environment("ActionName")),Ucase("DCD"))>0 AND Instr(Ucase(Environment("ActionName")),Ucase("Generic"))=0 Then
			strSaleOrderNumber=fnReadSaleOrderNumber("DC Direct")
		ElseIf Instr(Ucase(Environment("ActionName")),Ucase("ISO"))>0 AND Instr(Ucase(Environment("ActionName")),Ucase("Generic"))=0 Then
			strSaleOrderNumber=fnReadSaleOrderNumber("ISO")
		Else
			strSaleOrderNumber=fnReadSaleOrderNumber("Generic Sales Order")
		End If
		
'		Wait(MIN_WAIT)	
		fnEnterText "txtOrderNumberQuote",trim(strSaleOrderNumber)
		fnClick "btnFindORderQuotes"
		wait(MIN_WAIT)
		fnClick "btnActionsOrganizer"
'		fnValueSelectFromOrganizationSales trim("Additional Order Information")
		OracleListOfValues("olvActionsOrderOrganizer").Select trim("Additional Order Information")
		wait(MIN_WAIT)
		fnSelect "DeliveriesAddl","Deliveries"
		iDeliveryNumber=fnGetCellData("otDeliveriesInfo",1,2)
		wait(MIN_WAIT)		
	    
	    If Instr(Ucase(Environment("ActionName")),Ucase("DCD"))>0 AND Instr(Ucase(Environment("ActionName")),Ucase("Generic"))=0 Then
			Call fnWriteDeliveryNumber("DC Direct",iDeliveryNumber)
		ElseIf Instr(Ucase(Environment("ActionName")),Ucase("ISO"))>0 AND Instr(Ucase(Environment("ActionName")),Ucase("Generic"))=0 Then
			Call fnWriteDeliveryNumber("ISO",iDeliveryNumber)
		Else
			Call fnWriteDeliveryNumber("Generic Sales Order",iDeliveryNumber)
		End If
		fnGetDeliveryNumberGenericSales=iDeliveryNumber	    
'	    wait(MIN_WAIT)		
		    If OracleFormWindow("SalesOrders").Exist(1) Then
		    	OracleFormWindow("SalesOrders").CloseForm	
		    End If
		Call fnCloseAllOpenBrowsers()			
End Function 


'******************************************************************************************************************************************************************************************************************************************
'	Sub Name		 					:					fnGetInvoiceNumberDC
'	Objective							:					To get delivery number from order organizer
'	Input Parameters					:					textFile name
'	Output Parameters					:					NIL
'	Date Created						:					06-Mar-2017
'	QTP Version							:					UFT 12.0
'	QC Version							:					
'	Pre-requisites						:					NILL  
'	Created By							:					Balaji Veeravalli
'	Modification Date					:	
'******************************************************************************************************************************************************************************************************************************************
Public Function fnGetInvoiceNumberDC()	
'	On error resume next
		If Ucase(Environment("CountryUS")) = "YES" and  Ucase(Environment("CountryCA")) = "NO" Then
			fnNavigateToPage("Order Management Super User|Order Organizer")
		ElseIf Ucase(Environment("CountryUS")) = "NO" and  Ucase(Environment("CountryCA")) = "YES" Then
			fnNavigateToPage("NTD-CA Order Management Super User|Order Organizer")			
		End If	
		Wait(10)		
	 		If OracleFormWindow("FindOrders/Quotes").OracleTabbedRegion("Quote/Order Information").Exist(1) Then
				Call fnReportStepALM("Order organizer", "Passed", "Order organizer window verification", "Order organizer should be display","Order organizer is displayed")
				Call rptWriteReport("PASSWITHSCREENSHOT", "Order organizer window verification" ,"Order organizer is displayed")
			Else
				Call fnReportStepALM("Order organizer", "Failed", "Order organizer window verification","Order organizer should be display","Order organizer not displayed")
				Call rptWriteReport("Fail", "Order organizer window verification" , "Order organizer not displayed")
				fnUploadReport strProjectResultPath&"\"&Environment("FolderName"), strProjectResultPath&"\"&Environment("FolderName")
				ExitAction()
			End If		
		strSaleOrderNumber=fnReadSaleOrderNumber("DC Direct")
		Wait(MID_WAIT)	
		fnEnterText "txtOrderNumberQuote",trim(strSaleOrderNumber)
		fnClick "btnFindORderQuotes"
		wait(MID_WAIT)
		fnClick "btnActionsOrganizer"
'		fnValueSelectFromOrganizationSales OracleListOfValues("olvActionsOrderOrganizer"),trim("Additional Order Information")
		OracleListOfValues("olvActionsOrderOrganizer").Select trim("Additional Order Information")
		wait(MIN_WAIT)
		fnSelect "InvoicesCreditMemos","Invoices / Credit Memos"
		iInvoiceNumber=fnGetCellData("otInvoiceTable1",1,1)
		cInvoiceAmount=fnGetCellData("otInvoiceTable1",1,4)
		wait(3)		
	    Call fnWriteInvoiceNumber("DC Direct",iInvoiceNumber)
	    wait(2)		
		Call fnWriteInvoiceAmount("DC Direct",cInvoiceAmount) 	    
	    wait(2)		
'	    OracleFormWindow("SalesOrders").CloseForm	
'		Call fnCloseAllOpenBrowsers()	
If OracleFormWindow("AdditionalOrderInformationInvoice").Exist(1) Then
	OracleFormWindow("AdditionalOrderInformationInvoice").CloseWindow
End If

End Function

'******************************************************************************************************************************************************************************************************************************************
'	Sub Name		 					:					fnGetInvoiceNumberNTDGSO
'	Objective							:					To get delivery number from order organizer
'	Input Parameters					:					textFile name
'	Output Parameters					:					NIL
'	Date Created						:					06-Mar-2017
'	QTP Version							:					UFT 12.0
'	QC Version							:					
'	Pre-requisites						:					NILL  
'	Created By							:					Balaji Veeravalli
'	Modification Date					:	
'******************************************************************************************************************************************************************************************************************************************
Public Function fnGetInvoiceNumberNTDGSO()	
	On error resume next
	wait 4
		If Ucase(Environment("CountryUS")) = "YES" and  Ucase(Environment("CountryCA")) = "NO" Then
			fnNavigateToPageC("Order Management Super User|Order Organizer")
		ElseIf Ucase(Environment("CountryUS")) = "NO" and  Ucase(Environment("CountryCA")) = "YES" Then
			fnNavigateToPageC("NTD-CA Order Management Super User|Order Organizer")			
		End If	
		wait 4
			Call fnSynUntilObjExists(OracleFormWindow("FindOrders/Quotes").OracleTabbedRegion("Quote/Order Information"),15)
		 		If OracleFormWindow("FindOrders/Quotes").OracleTabbedRegion("Quote/Order Information").Exist(1) Then
					Call fnReportStepALM("Order organizer", "Passed", "Order organizer window verification", "Order organizer should be display","Order organizer is displayed")
					Call rptWriteReport("PASSWITHSCREENSHOT", "Order organizer window verification" ,"Order organizer is displayed")
				Else
					Call fnReportStepALM("Order organizer", "Failed", "Order organizer window verification","Order organizer should be display","Order organizer not displayed")
					Call rptWriteReport("Fail", "Order organizer window verification" , "Order organizer not displayed")
					fnUploadReport strProjectResultPath&"\"&Environment("FolderName"), strProjectResultPath&"\"&Environment("FolderName")
					ExitAction()
				End If		
		strSaleOrderNumber=fnReadSaleOrderNumber("Log_"&Environment("TestName"))
		Wait(2)	
		fnEnterText "txtOrderNumberQuote",trim(strSaleOrderNumber)
		fnClick "btnFindORderQuotes"
		wait(MIN_WAIT)
		fnClick "btnActionsOrganizer"
		OracleListOfValues("olvActionsOrderOrganizer").Select trim("Additional Order Information")
		wait(2)
		fnSelect "InvoicesCreditMemos","Invoices / Credit Memos"
		iInvoiceNumber=fnGetCellData("otInvoiceTable1",1,1)
		cInvoiceAmount=fnGetCellData("otInvoiceTable1",1,4)
		wait(2)		
	    Call fnWriteInvoiceNumber("Log_"&Environment("TestName"),iInvoiceNumber)
	    wait(1)		
		Call fnWriteInvoiceAmount("Log_"&Environment("TestName"),cInvoiceAmount) 	    
	    wait(1)		
			If OracleFormWindow("AdditionalOrderInformationInvoice").Exist(1) Then
				OracleFormWindow("AdditionalOrderInformationInvoice").CloseWindow
			End If
		Call fnCloseNavigatorForm()					
End Function

'******************************************************************************************************************************************************************************************************************************************
'	Sub Name		 					:					fnGetInvoiceNumberFedex
'	Objective							:					To get delivery number from order organizer
'	Input Parameters					:					textFile name
'	Output Parameters					:					NIL
'	Date Created						:					06-Mar-2017
'	QTP Version							:					UFT 12.0
'	QC Version							:					
'	Pre-requisites						:					NILL  
'	Created By							:					Balaji Veeravalli
'	Modification Date					:	
'******************************************************************************************************************************************************************************************************************************************
Public Function fnGetInvoiceNumberFedex()	
'	On error resume next
		If Ucase(Environment("CountryUS")) = "YES" and  Ucase(Environment("CountryCA")) = "NO" Then
			fnNavigateToPage("Order Management Super User|Order Organizer")
		ElseIf Ucase(Environment("CountryUS")) = "NO" and  Ucase(Environment("CountryCA")) = "YES" Then
			fnNavigateToPage("NTD-CA Order Management Super User|Order Organizer")			
		End If	
		Wait(10)		
	 		If OracleFormWindow("FindOrders/Quotes").OracleTabbedRegion("Quote/Order Information").Exist(1) Then
				Call fnReportStepALM("Order organizer", "Passed", "Order organizer window verification", "Order organizer should be display","Order organizer is displayed")
				Call rptWriteReport("PASSWITHSCREENSHOT", "Order organizer window verification" ,"Order organizer is displayed")
			Else
				Call fnReportStepALM("Order organizer", "Failed", "Order organizer window verification","Order organizer should be display","Order organizer not displayed")
				Call rptWriteReport("Fail", "Order organizer window verification" , "Order organizer not displayed")
				fnUploadReport strProjectResultPath&"\"&Environment("FolderName"), strProjectResultPath&"\"&Environment("FolderName")
				ExitAction()
			End If		
		strSaleOrderNumber=fnReadSaleOrderNumber("GSOFedexShippingMethod")
		Wait(MID1_WAIT)	
		fnEnterText "txtOrderNumberQuote",trim(strSaleOrderNumber)
		fnClick "btnFindORderQuotes"
		wait(MID_WAIT)
		fnClick "btnActionsOrganizer"
'		fnValueSelectFromOrganizationSales OracleListOfValues("olvActionsOrderOrganizer"),trim("Additional Order Information")
		OracleListOfValues("olvActionsOrderOrganizer").Select trim("Additional Order Information")
		wait(MID_WAIT)
		fnSelect "InvoicesCreditMemos","Invoices / Credit Memos"
		iInvoiceNumber=fnGetCellData("otInvoiceTable1",1,1)
		cInvoiceAmount=fnGetCellData("otInvoiceTable1",1,4)
		wait(MIN_WAIT)		
	    Call fnWriteInvoiceNumber("GSOFedexShippingMethod",iInvoiceNumber)
	    wait(MIN_WAIT)	
		Call fnWriteInvoiceAmount("GSOFedexShippingMethod",cInvoiceAmount) 	    
	    wait(MIN_WAIT)		
'	    OracleFormWindow("SalesOrders").CloseForm	
'		Call fnCloseAllOpenBrowsers()	
			If OracleFormWindow("AdditionalOrderInformationInvoice").Exist(1) Then
				OracleFormWindow("AdditionalOrderInformationInvoice").CloseWindow
			End If
End Function
'******************************************************************************************************************************************************************************************************************************************
'	Sub Name		 					:					fnGetInvoiceNumberLTL
'	Objective							:					To get delivery number from order organizer
'	Input Parameters					:					textFile name
'	Output Parameters					:					NIL
'	Date Created						:					28-Mar-2017
'	QTP Version							:					UFT 12.0
'	QC Version							:					
'	Pre-requisites						:					NILL  
'	Created By							:					Balaji Veeravalli
'	Modification Date					:	
'******************************************************************************************************************************************************************************************************************************************
Public Function fnGetInvoiceNumberLTL()	
'	On error resume next
		If Ucase(Environment("CountryUS")) = "YES" and  Ucase(Environment("CountryCA")) = "NO" Then
			fnNavigateToPage("Order Management Super User|Order Organizer")
		ElseIf Ucase(Environment("CountryUS")) = "NO" and  Ucase(Environment("CountryCA")) = "YES" Then
			fnNavigateToPage("NTD-CA Order Management Super User|Order Organizer")			
		End If	
		Wait(10)		
	 		If OracleFormWindow("FindOrders/Quotes").OracleTabbedRegion("Quote/Order Information").Exist(1) Then
				Call fnReportStepALM("Order organizer", "Passed", "Order organizer window verification", "Order organizer should be display","Order organizer is displayed")
				Call rptWriteReport("PASSWITHSCREENSHOT", "Order organizer window verification" ,"Order organizer is displayed")
			Else
				Call fnReportStepALM("Order organizer", "Failed", "Order organizer window verification","Order organizer should be display","Order organizer not displayed")
				Call rptWriteReport("Fail", "Order organizer window verification" , "Order organizer not displayed")
				fnUploadReport strProjectResultPath&"\"&Environment("FolderName"), strProjectResultPath&"\"&Environment("FolderName")
				ExitAction()
			End If		
		strSaleOrderNumber=fnReadSaleOrderNumber("GSOLTL")
		Wait(MID1_WAIT)	
		fnEnterText "txtOrderNumberQuote",trim(strSaleOrderNumber)
		fnClick "btnFindORderQuotes"
		wait(MID_WAIT)
		fnClick "btnActionsOrganizer"
'		fnValueSelectFromOrganizationSales OracleListOfValues("olvActionsOrderOrganizer"),trim("Additional Order Information")
		OracleListOfValues("olvActionsOrderOrganizer").Select trim("Additional Order Information")
		wait(MID_WAIT)
		fnSelect "InvoicesCreditMemos","Invoices / Credit Memos"
		iInvoiceNumber=fnGetCellData("otInvoiceTable1",1,1)
		cInvoiceAmount=fnGetCellData("otInvoiceTable1",1,4)
		wait(MIN_WAIT)		
	    Call fnWriteInvoiceNumber("GSOLTL",iInvoiceNumber)
	    wait(MIN_WAIT)	
		Call fnWriteInvoiceAmount("GSOLTL",cInvoiceAmount) 	    
	    wait(MIN_WAIT)		
'	    OracleFormWindow("SalesOrders").CloseForm	
'		Call fnCloseAllOpenBrowsers()	
If OracleFormWindow("AdditionalOrderInformationInvoice").Exist(1) Then
	OracleFormWindow("AdditionalOrderInformationInvoice").CloseWindow
End If
End Function


'******************************************************************************************************************************************************************************************************************************************
'	Sub Name		 					:					fnGetInvoiceNumberLTL
'	Objective							:					To get delivery number from order organizer
'	Input Parameters					:					textFile name
'	Output Parameters					:					NIL
'	Date Created						:					28-Mar-2017
'	QTP Version							:					UFT 12.0
'	QC Version							:					
'	Pre-requisites						:					NILL  
'	Created By							:					Balaji Veeravalli
'	Modification Date					:	
'******************************************************************************************************************************************************************************************************************************************
Public Function fnGetInvoiceNumberCPU()	
'	On error resume next
		If Ucase(Environment("CountryUS")) = "YES" and  Ucase(Environment("CountryCA")) = "NO" Then
			fnNavigateToPage("Order Management Super User|Order Organizer")
		ElseIf Ucase(Environment("CountryUS")) = "NO" and  Ucase(Environment("CountryCA")) = "YES" Then
			fnNavigateToPage("NTD-CA Order Management Super User|Order Organizer")			
		End If	
		Wait(10)		
	 		If OracleFormWindow("FindOrders/Quotes").OracleTabbedRegion("Quote/Order Information").Exist(1) Then
				Call fnReportStepALM("Order organizer", "Passed", "Order organizer window verification", "Order organizer should be display","Order organizer is displayed")
				Call rptWriteReport("PASSWITHSCREENSHOT", "Order organizer window verification" ,"Order organizer is displayed")
			Else
				Call fnReportStepALM("Order organizer", "Failed", "Order organizer window verification","Order organizer should be display","Order organizer not displayed")
				Call rptWriteReport("Fail", "Order organizer window verification" , "Order organizer not displayed")
				fnUploadReport strProjectResultPath&"\"&Environment("FolderName"), strProjectResultPath&"\"&Environment("FolderName")
				ExitAction()
			End If		
		strSaleOrderNumber=fnReadSaleOrderNumber("GSOCPU")
		Wait(MID1_WAIT)	
		fnEnterText "txtOrderNumberQuote",trim(strSaleOrderNumber)
		fnClick "btnFindORderQuotes"
		wait(MID_WAIT)
		fnClick "btnActionsOrganizer"
'		fnValueSelectFromOrganizationSales OracleListOfValues("olvActionsOrderOrganizer"),trim("Additional Order Information")
		OracleListOfValues("olvActionsOrderOrganizer").Select trim("Additional Order Information")
		wait(MID_WAIT)
		fnSelect "InvoicesCreditMemos","Invoices / Credit Memos"
		iInvoiceNumber=fnGetCellData("otInvoiceTable1",1,1)
		cInvoiceAmount=fnGetCellData("otInvoiceTable1",1,4)
		wait(MIN_WAIT)		
	    Call fnWriteInvoiceNumber("GSOCPU",iInvoiceNumber)
	    wait(MIN_WAIT)	
		Call fnWriteInvoiceAmount("GSOCPU",cInvoiceAmount) 	    
	    wait(MIN_WAIT)		
'	    OracleFormWindow("SalesOrders").CloseForm	
'		Call fnCloseAllOpenBrowsers()	
If OracleFormWindow("AdditionalOrderInformationInvoice").Exist(1) Then
	OracleFormWindow("AdditionalOrderInformationInvoice").CloseWindow
End If
End Function
'******************************************************************************************************************************************************************************************************************************************
'	Sub Name		 					:					fnGetInvoiceNumberTL
'	Objective							:					To get delivery number from order organizer
'	Input Parameters					:					textFile name
'	Output Parameters					:					NIL
'	Date Created						:					31-Mar-2017
'	QTP Version							:					UFT 12.0
'	QC Version							:					
'	Pre-requisites						:					NILL  
'	Created By							:					Balaji Veeravalli
'	Modification Date					:	
'******************************************************************************************************************************************************************************************************************************************
Public Function fnGetInvoiceNumberTL()	
'	On error resume next
		If Ucase(Environment("CountryUS")) = "YES" and  Ucase(Environment("CountryCA")) = "NO" Then
			fnNavigateToPage("Order Management Super User|Order Organizer")
		ElseIf Ucase(Environment("CountryUS")) = "NO" and  Ucase(Environment("CountryCA")) = "YES" Then
			fnNavigateToPage("NTD-CA Order Management Super User|Order Organizer")			
		End If	
		Wait(10)		
	 		If OracleFormWindow("FindOrders/Quotes").OracleTabbedRegion("Quote/Order Information").Exist(1) Then
				Call fnReportStepALM("Order organizer", "Passed", "Order organizer window verification", "Order organizer should be display","Order organizer is displayed")
				Call rptWriteReport("PASSWITHSCREENSHOT", "Order organizer window verification" ,"Order organizer is displayed")
			Else
				Call fnReportStepALM("Order organizer", "Failed", "Order organizer window verification","Order organizer should be display","Order organizer not displayed")
				Call rptWriteReport("Fail", "Order organizer window verification" , "Order organizer not displayed")
				fnUploadReport strProjectResultPath&"\"&Environment("FolderName"), strProjectResultPath&"\"&Environment("FolderName")
				ExitAction()
			End If		
		strSaleOrderNumber=fnReadSaleOrderNumber("GSOTL")
		Wait(MID1_WAIT)	
		fnEnterText "txtOrderNumberQuote",trim(strSaleOrderNumber)
		fnClick "btnFindORderQuotes"
		wait(MID_WAIT)
		fnClick "btnActionsOrganizer"
'		fnValueSelectFromOrganizationSales OracleListOfValues("olvActionsOrderOrganizer"),trim("Additional Order Information")
		OracleListOfValues("olvActionsOrderOrganizer").Select trim("Additional Order Information")
		wait(MID_WAIT)
		fnSelect "InvoicesCreditMemos","Invoices / Credit Memos"
		iInvoiceNumber=fnGetCellData("otInvoiceTable1",1,1)
		cInvoiceAmount=fnGetCellData("otInvoiceTable1",1,4)
		wait(MIN_WAIT)		
	    Call fnWriteInvoiceNumber("GSOTL",iInvoiceNumber)
	    wait(MIN_WAIT)	
		Call fnWriteInvoiceAmount("GSOTL",cInvoiceAmount) 	    
	    wait(MIN_WAIT)		
'	    OracleFormWindow("SalesOrders").CloseForm	
'		Call fnCloseAllOpenBrowsers()	
If OracleFormWindow("AdditionalOrderInformationInvoice").Exist(1) Then
	OracleFormWindow("AdditionalOrderInformationInvoice").CloseWindow
End If
End Function
'******************************************************************************************************************************************************************************************************************************************
'	Sub Name		 					:					fnGetInvoiceNumberGenericSales
'	Objective							:					To get delivery number from order organizer
'	Input Parameters					:					textFile name
'	Output Parameters					:					NIL
'	Date Created						:					13-Mar-2017
'	QTP Version							:					UFT 12.0
'	QC Version							:					
'	Pre-requisites						:					NILL  
'	Created By							:					Balaji Veeravalli
'	Modification Date					:	
'******************************************************************************************************************************************************************************************************************************************
Public Function fnGetInvoiceNumberGenericSales()	
	On error resume next	
		If Ucase(Environment("CountryUS")) = "YES" and  Ucase(Environment("CountryCA")) = "NO" Then
			fnNavigateToPage("Order Management Super User|Order Organizer")
		ElseIf Ucase(Environment("CountryUS")) = "NO" and  Ucase(Environment("CountryCA")) = "YES" Then
			fnNavigateToPage("NTD-CA Order Management Super User|Order Organizer")			
		End If	
'		Wait(10)		
	 		If OracleFormWindow("FindOrders/Quotes").OracleTabbedRegion("Quote/Order Information").Exist(MAX_WAIT) Then
				Call fnReportStepALM("Order organizer", "Passed", "Order organizer window verification", "Order organizer should be display","Order organizer is displayed")
				Call rptWriteReport("PASSWITHSCREENSHOT", "Order organizer window verification" ,"Order organizer is displayed")
			Else
				Call fnReportStepALM("Order organizer", "Failed", "Order organizer window verification","Order organizer should be display","Order organizer not displayed")
				Call rptWriteReport("Fail", "Order organizer window verification" , "Order organizer not displayed")
				fnUploadReport strProjectResultPath&"\"&Environment("FolderName"), strProjectResultPath&"\"&Environment("FolderName")
				ExitAction()
			End If		
'		strSaleOrderNumber=fnReadSaleOrderNumber("Generic Sales Order")
		If Instr(Ucase(Environment("ActionName")),Ucase("DCD"))>0 AND Instr(Ucase(Environment("ActionName")),Ucase("Generic"))=0 Then
			strSaleOrderNumber=fnReadSaleOrderNumber("DC Direct")
		ElseIf Instr(Ucase(Environment("ActionName")),Ucase("ISO"))>0 AND Instr(Ucase(Environment("ActionName")),Ucase("Generic"))=0 Then
			strSaleOrderNumber=fnReadSaleOrderNumber("ISO")
		Else
			strSaleOrderNumber=fnReadSaleOrderNumber("Generic Sales Order")
		End If
'		Wait(MID_WAIT)	
		fnEnterText "txtOrderNumberQuote",trim(strSaleOrderNumber)
		fnClick "btnFindORderQuotes"
		wait(MID_WAIT)
		fnClick "btnActionsOrganizer"
		OracleListOfValues("olvActionsOrderOrganizer").Select trim("Additional Order Information")
		wait(MIN_WAIT)
		fnSelect "InvoicesCreditMemos","Invoices / Credit Memos"
		iInvoiceNumber=fnGetCellData("otInvoiceTable1",1,1)
		cInvoiceAmount=fnGetCellData("otInvoiceTable1",1,4)
		wait(3)		
	    Call fnWriteInvoiceNumber("Generic Sales Order",iInvoiceNumber)
	    wait(2)		
		Call fnWriteInvoiceAmount("Generic Sales Order",cInvoiceAmount) 	    
	    wait(2)		
	If OracleFormWindow("AdditionalOrderInformationInvoice").Exist(1) Then
		OracleFormWindow("AdditionalOrderInformationInvoice").CloseWindow
	End If
End Function
'******************************************************************************************************************************************************************************************************************************************
'	Sub Name		 					:					fnCustomerReceiptConfirm
'	Objective							:					To confirm Credit payment
'	Input Parameters					:					textFile name
'	Output Parameters					:					NIL
'	Date Created						:					06-Mar-2017
'	QTP Version							:					UFT 12.0
'	QC Version							:					
'	Pre-requisites						:					NILL  
'	Created By							:					Balaji Veeravalli
'	Modification Date					:	
'******************************************************************************************************************************************************************************************************************************************

Public Function fnCustomerReceiptConfirm()
	If Ucase(Environment("CountryUS")) = "YES" and  Ucase(Environment("CountryCA")) = "NO" Then
		fnNavigateToPage("Receivables Manager|Transactions")
	ElseIf Ucase(Environment("CountryUS")) = "NO" and  Ucase(Environment("CountryCA")) = "YES" Then
		fnNavigateToPage("NTD-CA Receivables Manager|Transactions")
	End If
	wait(10)	
		If OracleFormWindow("TransactionsOne").Exist(1) Then
			Call fnReportStepALM("Transactions", "Passed", "Transactions window verification", "Transactions should be display","Transactions is displayed")
			Call rptWriteReport("PASSWITHSCREENSHOT", "Transactions window verification" , "Transactions window displayed")
		Else
			Call fnReportStepALM("Transactions", "Failed", "Transactions window verification", "Transactions should be display","Transactions is NOT displayed")			
			Call rptWriteReport("Fail", "Transactions window verification verification" , "Transactions window verification not displayed")
			fnUploadReport strProjectResultPath&"\"&Environment("FolderName"), strProjectResultPath&"\"&Environment("FolderName")
			Call fnCloseAllOpenBrowsers()
		End If
		iTrxNumber=fnReadInvoiceNumber("DC Direct")
		wait(MIN_WAIT)		
   	 	fnSelectMenu "TransactionsOne","View->Query By Example->Enter"
		fnEnterText "txtTransactionTransactionNum",iTrxNumber
		wait(MIN_WAIT)
		fnSelectMenu "TransactionsOne","View->Query By Example->Run"
		wait(MID_WAIT)		
		cIDueTotal=fnGetProperty("txtBalanceDueTotals","value")  
			If trim(cIDueTotal)=trim("0.00")Then
				wait(MIN_WAIT)
				Call fnReportStepALM("Adjusted Credit Memo", "Passed", "'Adjusted Credit Memo balance' verification", "'Adjusted as per the Credit Memo amounts and balance should be 0'","'Adjusted Credit Memo Amounts and balance is..."&cIDueTotal)
				Call rptWriteReport("PASSWITHSCREENSHOT", "Adjusted Credit Memo balance verification" , "Adjusted Credit Memo Amounts and balance is..."&cIDueTotal)
			Else
				Call fnReportStepALM("Adjusted Credit Memo", "Failed", "'Adjusted Credit Memo balance' verification", "'Adjusted as per the Credit Memo amounts and balance should be 0'","'Adjusted Credit Memo Amounts and balance is not same..."&tDueTotal)				
				Call rptWriteReport("Fail", "Adjusted Credit Memo balance verification" , "Adjusted Credit Memo Amounts and balance is not same..."&cIDueTotal)	
			End If
	If OracleFormWindow("TransactionsOne").Exist(1) Then
		OracleFormWindow("TransactionsOne").CloseWindow	
	End If
End Function

'******************************************************************************************************************************************************************************************************************************************
'	Sub Name		 					:					fnCustomerReceiptConfirmFedex
'	Objective							:					To confirm Credit payment
'	Input Parameters					:					textFile name
'	Output Parameters					:					NIL
'	Date Created						:					06-Mar-2017
'	QTP Version							:					UFT 12.0
'	QC Version							:					
'	Pre-requisites						:					NILL  
'	Created By							:					Balaji Veeravalli
'	Modification Date					:	
'******************************************************************************************************************************************************************************************************************************************
Public Function fnCustomerReceiptConfirmFedex()
	If Ucase(Environment("CountryUS")) = "YES" and  Ucase(Environment("CountryCA")) = "NO" Then
		fnNavigateToPage("Receivables Manager|Transactions")
	ElseIf Ucase(Environment("CountryUS")) = "NO" and  Ucase(Environment("CountryCA")) = "YES" Then
		fnNavigateToPage("NTD-CA Receivables Manager|Transactions")
	End If
	wait(10)	
		If OracleFormWindow("TransactionsOne").Exist(1) Then
			Call fnReportStepALM("Transactions", "Passed", "Transactions window verification", "Transactions should be display","Transactions is displayed")
			Call rptWriteReport("PASSWITHSCREENSHOT", "Transactions window verification" , "Transactions window displayed")
		Else
			Call fnReportStepALM("Transactions", "Failed", "Transactions window verification", "Transactions should be display","Transactions is NOT displayed")			
			Call rptWriteReport("Fail", "Transactions window verification verification" , "Transactions window verification not displayed")
			fnUploadReport strProjectResultPath&"\"&Environment("FolderName"), strProjectResultPath&"\"&Environment("FolderName")
			Call fnCloseAllOpenBrowsers()
		End If
		iTrxNumber=fnReadInvoiceNumber("GSOFedexShippingMethod")
		wait(MIN_WAIT)		
   	 	fnSelectMenu "TransactionsOne","View->Query By Example->Enter"
		fnEnterText "txtTransactionTransactionNum",iTrxNumber
		wait(MIN_WAIT)
		fnSelectMenu "TransactionsOne","View->Query By Example->Run"
		wait(MID_WAIT)		
		cIDueTotal=fnGetProperty("txtBalanceDueTotals","value")  
			If trim(cIDueTotal)=trim("0.00")Then
				wait(MIN_WAIT)
				Call fnReportStepALM("Adjusted Credit Memo", "Passed", "'Adjusted Credit Memo balance' verification", "'Adjusted as per the Credit Memo amounts and balance should be 0'","'Adjusted Credit Memo Amounts and balance is..."&cIDueTotal)
				Call rptWriteReport("PASSWITHSCREENSHOT", "Adjusted Credit Memo balance verification" , "Adjusted Credit Memo Amounts and balance is..."&cIDueTotal)
			Else
				Call fnReportStepALM("Adjusted Credit Memo", "Failed", "'Adjusted Credit Memo balance' verification", "'Adjusted as per the Credit Memo amounts and balance should be 0'","'Adjusted Credit Memo Amounts and balance is not same..."&tDueTotal)				
				Call rptWriteReport("Fail", "Adjusted Credit Memo balance verification" , "Adjusted Credit Memo Amounts and balance is not same..."&cIDueTotal)	
			End If
	If OracleFormWindow("TransactionsOne").Exist(1) Then
		OracleFormWindow("TransactionsOne").CloseWindow	
	End If
End Function

'******************************************************************************************************************************************************************************************************************************************
'	Sub Name		 					:					fnCustomerReceiptConfirmLTL
'	Objective							:					To confirm Credit payment
'	Input Parameters					:					textFile name
'	Output Parameters					:					NIL
'	Date Created						:					28-Mar-2017
'	QTP Version							:					UFT 12.0
'	QC Version							:					
'	Pre-requisites						:					NILL  
'	Created By							:					Balaji Veeravalli
'	Modification Date					:	
'******************************************************************************************************************************************************************************************************************************************
Public Function fnCustomerReceiptConfirmLTL()
	If Ucase(Environment("CountryUS")) = "YES" and  Ucase(Environment("CountryCA")) = "NO" Then
		fnNavigateToPage("Receivables Manager|Transactions")
	ElseIf Ucase(Environment("CountryUS")) = "NO" and  Ucase(Environment("CountryCA")) = "YES" Then
		fnNavigateToPage("NTD-CA Receivables Manager|Transactions")
	End If
	wait(10)	
		If OracleFormWindow("TransactionsOne").Exist(1) Then
			Call fnReportStepALM("Transactions", "Passed", "Transactions window verification", "Transactions should be display","Transactions is displayed")
			Call rptWriteReport("PASSWITHSCREENSHOT", "Transactions window verification" , "Transactions window displayed")
		Else
			Call fnReportStepALM("Transactions", "Failed", "Transactions window verification", "Transactions should be display","Transactions is NOT displayed")			
			Call rptWriteReport("Fail", "Transactions window verification verification" , "Transactions window verification not displayed")
			fnUploadReport strProjectResultPath&"\"&Environment("FolderName"), strProjectResultPath&"\"&Environment("FolderName")
			Call fnCloseAllOpenBrowsers()
		End If
		iTrxNumber=fnReadInvoiceNumber("GSOLTL")
		wait(MIN_WAIT)		
   	 	fnSelectMenu "TransactionsOne","View->Query By Example->Enter"
		fnEnterText "txtTransactionTransactionNum",iTrxNumber
		wait(MIN_WAIT)
		fnSelectMenu "TransactionsOne","View->Query By Example->Run"
		wait(MID_WAIT)		
		cIDueTotal=fnGetProperty("txtBalanceDueTotals","value")  
			If trim(cIDueTotal)=trim("0.00")Then
				wait(MIN_WAIT)
				Call fnReportStepALM("Adjusted Credit Memo", "Passed", "'Adjusted Credit Memo balance' verification", "'Adjusted as per the Credit Memo amounts and balance should be 0'","'Adjusted Credit Memo Amounts and balance is..."&cIDueTotal)
				Call rptWriteReport("PASSWITHSCREENSHOT", "Adjusted Credit Memo balance verification" , "Adjusted Credit Memo Amounts and balance is..."&cIDueTotal)
			Else
				Call fnReportStepALM("Adjusted Credit Memo", "Failed", "'Adjusted Credit Memo balance' verification", "'Adjusted as per the Credit Memo amounts and balance should be 0'","'Adjusted Credit Memo Amounts and balance is not same..."&tDueTotal)				
				Call rptWriteReport("Fail", "Adjusted Credit Memo balance verification" , "Adjusted Credit Memo Amounts and balance is not same..."&cIDueTotal)	
			End If
	If OracleFormWindow("TransactionsOne").Exist(1) Then
		OracleFormWindow("TransactionsOne").CloseWindow	
	End If
End Function

'******************************************************************************************************************************************************************************************************************************************
'	Sub Name		 					:					fnCustomerReceiptConfirmLTL
'	Objective							:					To confirm Credit payment
'	Input Parameters					:					textFile name
'	Output Parameters					:					NIL
'	Date Created						:					28-Mar-2017
'	QTP Version							:					UFT 12.0
'	QC Version							:					
'	Pre-requisites						:					NILL  
'	Created By							:					Balaji Veeravalli
'	Modification Date					:	
'******************************************************************************************************************************************************************************************************************************************
Public Function fnCustomerReceiptConfirmCPU()
	If Ucase(Environment("CountryUS")) = "YES" and  Ucase(Environment("CountryCA")) = "NO" Then
		fnNavigateToPage("Receivables Manager|Transactions")
	ElseIf Ucase(Environment("CountryUS")) = "NO" and  Ucase(Environment("CountryCA")) = "YES" Then
		fnNavigateToPage("NTD-CA Receivables Manager|Transactions")
	End If
	wait(10)	
		If OracleFormWindow("TransactionsOne").Exist(1) Then
			Call fnReportStepALM("Transactions", "Passed", "Transactions window verification", "Transactions should be display","Transactions is displayed")
			Call rptWriteReport("PASSWITHSCREENSHOT", "Transactions window verification" , "Transactions window displayed")
		Else
			Call fnReportStepALM("Transactions", "Failed", "Transactions window verification", "Transactions should be display","Transactions is NOT displayed")			
			Call rptWriteReport("Fail", "Transactions window verification verification" , "Transactions window verification not displayed")
			fnUploadReport strProjectResultPath&"\"&Environment("FolderName"), strProjectResultPath&"\"&Environment("FolderName")
			Call fnCloseAllOpenBrowsers()
		End If
		iTrxNumber=fnReadInvoiceNumber("GSOCPU")
		wait(MIN_WAIT)		
   	 	fnSelectMenu "TransactionsOne","View->Query By Example->Enter"
		fnEnterText "txtTransactionTransactionNum",iTrxNumber
		wait(MIN_WAIT)
		fnSelectMenu "TransactionsOne","View->Query By Example->Run"
		wait(MID_WAIT)		
		cIDueTotal=fnGetProperty("txtBalanceDueTotals","value")  
			If trim(cIDueTotal)=trim("0.00")Then
				wait(MIN_WAIT)
				Call fnReportStepALM("Adjusted Credit Memo", "Passed", "'Adjusted Credit Memo balance' verification", "'Adjusted as per the Credit Memo amounts and balance should be 0'","'Adjusted Credit Memo Amounts and balance is..."&cIDueTotal)
				Call rptWriteReport("PASSWITHSCREENSHOT", "Adjusted Credit Memo balance verification" , "Adjusted Credit Memo Amounts and balance is..."&cIDueTotal)
			Else
				Call fnReportStepALM("Adjusted Credit Memo", "Failed", "'Adjusted Credit Memo balance' verification", "'Adjusted as per the Credit Memo amounts and balance should be 0'","'Adjusted Credit Memo Amounts and balance is not same..."&tDueTotal)				
				Call rptWriteReport("Fail", "Adjusted Credit Memo balance verification" , "Adjusted Credit Memo Amounts and balance is not same..."&cIDueTotal)	
			End If
	If OracleFormWindow("TransactionsOne").Exist(1) Then
		OracleFormWindow("TransactionsOne").CloseWindow	
	End If
End Function
'******************************************************************************************************************************************************************************************************************************************
'	Sub Name		 					:					fnCustomerReceiptConfirmTL
'	Objective							:					To confirm Credit payment
'	Input Parameters					:					textFile name
'	Output Parameters					:					NIL
'	Date Created						:					28-Mar-2017
'	QTP Version							:					UFT 12.0
'	QC Version							:					
'	Pre-requisites						:					NILL  
'	Created By							:					Balaji Veeravalli
'	Modification Date					:	
'******************************************************************************************************************************************************************************************************************************************
Public Function fnCustomerReceiptConfirmTL()
	If Ucase(Environment("CountryUS")) = "YES" and  Ucase(Environment("CountryCA")) = "NO" Then
		fnNavigateToPage("Receivables Manager|Transactions")
	ElseIf Ucase(Environment("CountryUS")) = "NO" and  Ucase(Environment("CountryCA")) = "YES" Then
		fnNavigateToPage("NTD-CA Receivables Manager|Transactions")
	End If
	wait(10)	
		If OracleFormWindow("TransactionsOne").Exist(1) Then
			Call fnReportStepALM("Transactions", "Passed", "Transactions window verification", "Transactions should be display","Transactions is displayed")
			Call rptWriteReport("PASSWITHSCREENSHOT", "Transactions window verification" , "Transactions window displayed")
		Else
			Call fnReportStepALM("Transactions", "Failed", "Transactions window verification", "Transactions should be display","Transactions is NOT displayed")			
			Call rptWriteReport("Fail", "Transactions window verification verification" , "Transactions window verification not displayed")
			fnUploadReport strProjectResultPath&"\"&Environment("FolderName"), strProjectResultPath&"\"&Environment("FolderName")
			Call fnCloseAllOpenBrowsers()
		End If
		iTrxNumber=fnReadInvoiceNumber("GSOTL")
		wait(MIN_WAIT)		
   	 	fnSelectMenu "TransactionsOne","View->Query By Example->Enter"
		fnEnterText "txtTransactionTransactionNum",iTrxNumber
		wait(MIN_WAIT)
		fnSelectMenu "TransactionsOne","View->Query By Example->Run"
		wait(MID_WAIT)		
		cIDueTotal=fnGetProperty("txtBalanceDueTotals","value")  
			If trim(cIDueTotal)=trim("0.00")Then
				wait(MIN_WAIT)
				Call fnReportStepALM("Adjusted Credit Memo", "Passed", "'Adjusted Credit Memo balance' verification", "'Adjusted as per the Credit Memo amounts and balance should be 0'","'Adjusted Credit Memo Amounts and balance is..."&cIDueTotal)
				Call rptWriteReport("PASSWITHSCREENSHOT", "Adjusted Credit Memo balance verification" , "Adjusted Credit Memo Amounts and balance is..."&cIDueTotal)
			Else
				Call fnReportStepALM("Adjusted Credit Memo", "Failed", "'Adjusted Credit Memo balance' verification", "'Adjusted as per the Credit Memo amounts and balance should be 0'","'Adjusted Credit Memo Amounts and balance is not same..."&tDueTotal)				
				Call rptWriteReport("Fail", "Adjusted Credit Memo balance verification" , "Adjusted Credit Memo Amounts and balance is not same..."&cIDueTotal)	
			End If
	If OracleFormWindow("TransactionsOne").Exist(1) Then
		OracleFormWindow("TransactionsOne").CloseWindow	
	End If
End Function

'******************************************************************************************************************************************************************************************************************************************
'	Sub Name		 					:					fnCustomerReceiptConfirmGenericSales
'	Objective							:					To confirm Credit payment
'	Input Parameters					:					textFile name
'	Output Parameters					:					NIL
'	Date Created						:					13-Mar-2017
'	QTP Version							:					UFT 12.0
'	QC Version							:					
'	Pre-requisites						:					NILL  
'	Created By							:					Balaji Veeravalli
'	Modification Date					:	
'******************************************************************************************************************************************************************************************************************************************
Public Function fnCustomerReceiptConfirmGenericSales()
	If Ucase(Environment("CountryUS")) = "YES" and  Ucase(Environment("CountryCA")) = "NO" Then
		fnNavigateToPage("Receivables Manager|Transactions")
	ElseIf Ucase(Environment("CountryUS")) = "NO" and  Ucase(Environment("CountryCA")) = "YES" Then
		fnNavigateToPage("NTD-CA Receivables Manager|Transactions")
	End If
	wait(10)	
	If OracleFormWindow("TransactionsOne").Exist(1) Then
			Call fnReportStepALM("Transactions", "Passed", "Transactions window verification", "Transactions should be display","Transactions is displayed")
			Call rptWriteReport("PASSWITHSCREENSHOT", "Transactions window verification" , "Transactions window displayed")
		Else
			Call fnReportStepALM("Transactions", "Failed", "Transactions window verification", "Transactions should be display","Transactions is NOT displayed")			
			Call rptWriteReport("Fail", "Transactions window verification verification" , "Transactions window verification not displayed")
			fnUploadReport strProjectResultPath&"\"&Environment("FolderName"), strProjectResultPath&"\"&Environment("FolderName")
			Call fnCloseAllOpenBrowsers()
		End If
		iTrxNumber=fnReadInvoiceNumber("Generic Sales Order")
		wait(MIN_WAIT)		
	   	 	fnSelectMenu "TransactionsOne","View->Query By Example->Enter"
			fnEnterText "txtTransactionTransactionNum",iTrxNumber
		wait(MIN_WAIT)
			fnSelectMenu "TransactionsOne","View->Query By Example->Run"
		wait(MID_WAIT)		
		cIDueTotal=fnGetProperty("txtBalanceDueTotals","value")  
			If trim(cIDueTotal)=trim("0.00")Then
				wait(MIN_WAIT)
				Call fnReportStepALM("Adjusted Credit Memo", "Passed", "'Adjusted Credit Memo balance' verification", "'Adjusted as per the Credit Memo amounts and balance should be 0'","'Adjusted Credit Memo Amounts and balance is..."&cIDueTotal)
				Call rptWriteReport("PASSWITHSCREENSHOT", "Adjusted Credit Memo balance verification" , "Adjusted Credit Memo Amounts and balance is..."&cIDueTotal)
			Else
				Call fnReportStepALM("Adjusted Credit Memo", "Failed", "'Adjusted Credit Memo balance' verification", "'Adjusted as per the Credit Memo amounts and balance should be 0'","'Adjusted Credit Memo Amounts and balance is not same..."&tDueTotal)				
				Call rptWriteReport("Fail", "Adjusted Credit Memo balance verification" , "Adjusted Credit Memo Amounts and balance is not same..."&cIDueTotal)	
			End If	
End Function

'******************************************************************************************************************************************************************************************************************************************
'	Sub Name		 					:					fnReceiveAgainstManualASN
'	Objective							:					Receive against a manual ASN
'	Input Parameters					:					iOrganization_Number, iPO_Number, iProduct_Number
'	Output Parameters					:					NIL
'	Date Created						:					07-Mar-2017
'	QTP Version							:					UFT 12.0
'	QC Version							:					
'	Pre-requisites						:					NILL  
'	Created By							:					Gallop
'	Modification Date					:	
'******************************************************************************************************************************************************************************************************************************************
Public Function fnReceiveAgainstManualASN(iOrganization_Number, iPO_Number, iProduct_Number, iQuantity)
	'Press 1 For Receive  
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type 1 
	Wait(MIN_WAIT)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn 
	'Verify Receive screen
	If TeWindow("TeWindow").TeTextScreen("TeTextScreen").Exist(10) Then
		Call fnReportStepALM("Receive", "Passed", "Receive screen verification", "Should Display Receive screen","Receive screen is displayed")
		Call rptWriteReport("PASSWITHSCREENSHOT", "Receive screen verification", "Receive screen is displayed")
	Else
		Call fnReportStepALM("Receiver", "Failed", "Receive screen verification", "Should Display Receive Screen","Receive screen is not displayed")
		Call rptWriteReport("Fail", "Receive screen verification", "Receive screen is not displayed")
	End If 	
	'Press 1 for ASN Receive
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type 1 
	Wait(MIN_WAIT)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn 
	If TeWindow("TeWindow").TeTextScreen("TeTextScreen").Exist(10) Then
		Call fnReportStepALM("Organization", "Passed", "Organization screen verification", "Should Display Organization screen","Organization screen is displayed")
		Call rptWriteReport("PASSWITHSCREENSHOT", "Organization screen verification", "Organization screen is displayed")
	Else
		Call fnReportStepALM("Organizationr", "Failed", "Organization screen verification", "Should Display Organization Screen","Organization screen is not displayed")
		Call rptWriteReport("Fail", "Organization screen verification", "Organization screen is not displayed")
	End If 
	'Enter Organization number
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type iOrganization_Number
	Wait(MIN_WAIT)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	Wait(MIN_WAIT)
	'Verify Receipt Screen
	If TeWindow("TeWindow").TeTextScreen("TeTextScreen").Exist(10) Then
		Call fnReportStepALM("Receipt", "Passed", "Receipt screen verification", "Should Display Receipt screen","Receipt screen is displayed")
		Call rptWriteReport("PASSWITHSCREENSHOT", "Receipt screen verification", "Receipt screen is displayed")
	Else
		Call fnReportStepALM("Receipt", "Failed", "Receipt screen verification", "Should Display Receipt Screen","Receipt screen is not displayed")
		Call rptWriteReport("Fail", "Receipt screen verification", "Receipt screen is not displayed")
	End If 
	'Enter ASN number
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type iPO_Number&".1"
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	Wait(MIN_WAIT)
	'Enter Item# 
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type iProduct_Number
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	Wait(MIN_WAIT)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micDwn
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	Wait(MIN_WAIT)
	'Verify Receipt Screen
	If TeWindow("TeWindow").TeTextScreen("TeTextScreen").Exist(10) Then
		Call fnReportStepALM("Receipt", "Passed", "Receipt screen verification", "Should Display Receipt screen","Receipt screen is displayed")
		Call rptWriteReport("PASSWITHSCREENSHOT", "Receipt screen verification", "Receipt screen is displayed")
	Else
		Call fnReportStepALM("Receipt", "Failed", "Receipt screen verification", "Should Display Receipt Screen","Receipt screen is not displayed")
		Call rptWriteReport("Fail", "Receipt screen verification", "Receipt screen is not displayed")
	End If
	'Press Ctrl+G to auto-generate LPN
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micCtrlDwn+ "G" + micCtrlUp
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	Wait(MIN_WAIT)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	Wait(MIN_WAIT)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micCtrlDwn+ "L" + micCtrlUp
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	Wait(MIN_WAIT)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micCtrlDwn+ "L" + micCtrlUp
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	Wait(MIN_WAIT)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type iQuantity
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	Wait(MIN_WAIT)
	'Verify LPN, SubInventory,Location& Quantity
	If TeWindow("TeWindow").TeTextScreen("TeTextScreen").Exist(10) Then
		Call fnReportStepALM("LPN, SubInventory, Location& Quantity", "Passed", "LPN, SubInventory,Location& Quantity verification", "Should be able to enter the Subinventory, Locator and Item Quantity", "Entered the Subinventory, Locator and Item Quantity fields")
		Call rptWriteReport("PASSWITHSCREENSHOT", "LPN, SubInventory,Location& Quantity verification", "Entered the Subinventory, Locator and Item Quantity fields")
	Else
		Call fnReportStepALM("LPN, SubInventory, Location& Quantity", "Failed", "LPN, SubInventory,Location& Quantity verification", "Should be able to enter the Subinventory, Locator and Item Quantity", "Not Entered the Subinventory, Locator and Item Quantity")
		Call rptWriteReport("Fail", "LPN, SubInventory,Location& Quantity verification", "Not Entered the Subinventory, Locator and Item Quantity")
	End If
	Wait(MIN_WAIT)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	Wait(MIN_WAIT)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micDwn
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	Wait(MIN_WAIT)
	'Verify Receipt Information
	If TeWindow("TeWindow").TeTextScreen("TeTextScreen").Exist(10) Then
		Call fnReportStepALM("Receipt Information", "Passed", "Receipt Information verification", "Should display Receipt Information", "Receipt Information screen is displayed")
		Call rptWriteReport("PASSWITHSCREENSHOT", "Receipt Information verification", "Receipt Information screen is displayed")
	Else
		Call fnReportStepALM("Receipt Information", "Failed", "Receipt Information verification", "Should display Receipt Information", "Receipt Information screen is not displayed")
		Call rptWriteReport("Fail", "Receipt Information verification", "Receipt Information screen is not displayed")
	End If
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	Wait(MIN_WAIT)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	Wait(MIN_WAIT)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	Wait(MIN_WAIT)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	Wait(MIN_WAIT)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	Wait(MIN_WAIT)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	Wait(MAX_WAIT)
	'Verify Txn Success
	If TeWindow("TeWindow").TeTextScreen("TeTextScreen").Exist(10) Then
		Call fnReportStepALM("Txn Success", "Passed", "Txn Success verification", "Should display Txn Success message", "Txn Success is displayed")
		Call rptWriteReport("PASSWITHSCREENSHOT", "Txn Success verification", "Txn Success is displayed")
	Else
		Call fnReportStepALM("Txn Success", "Failed", "Txn Success verification", "Should display Txn Success message", "Txn Success is not displayed")
		Call rptWriteReport("Fail", "Txn Success verification", "Txn Success is not displayed")
	End If
	
End Function

'******************************************************************************************************************************************************************************************************************************************
'	Sub Name		 					:					fnPutawayMaterialReceivedAgainstASN
'	Objective							:					Putaway material received against ASN into Quickpick
'	Input Parameters					:					iOrganization_Number, iLPN_Number, iToSub, iToLOC
'	Output Parameters					:					NIL
'	Date Created						:					07-Mar-2017
'	QTP Version							:					UFT 12.0
'	QC Version							:					
'	Pre-requisites						:					NILL  
'	Created By							:					Gallop
'	Modification Date					:	
'******************************************************************************************************************************************************************************************************************************************
Public Function fnPutawayMaterialReceivedAgainstASN(iOrganization_Number, iLPN_Number)
	fnSynUntilFieldExists "3 <Putaway", 10
	'Press 3 for Putaway
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type 3
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	fnSynUntilFieldExists "Select Organization", 10
	Set objFSO = createobject("Scripting.filesystemobject")
	set objFile = objFSO.OpenTextFile(StrFrameWorkFolder&"\Resources\Log.txt")
	strData = objFile.ReadAll
	'Verify Organization screen
	If Instr(strData, "Select Organization")>0 Then
		Call fnReportStepALM("Organization", "Passed", "Organization screen verification", "Should Display Organization screen","Organization screen is displayed")
		Call rptWriteReport("PASSWITHSCREENSHOT", "Organization screen verification", "Organization screen is displayed")
	Else
		Call fnReportStepALM("Organizationr", "Failed", "Organization screen verification", "Should Display Organization Screen","Organization screen is not displayed")
		Call rptWriteReport("Fail", "Organization screen verification", "Organization screen is not displayed")
	End If 
	Set ObjFile= Nothing 
	'Enter Org Number
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type iOrganization_Number
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	fnSynUntilFieldExists "Move LPN", 15
	set objFile = objFSO.OpenTextFile(StrFrameWorkFolder&"\Resources\Log.txt")
	strData = objFile.ReadAll
	'Verify Move LPN screen
	If Instr(strData, "Move LPN")>0 Then 
		Call fnReportStepALM("Move LPN", "Passed", "Move LPN  screen verification", "Should Display Move LPN screen","Move LPN screen is displayed")
		Call rptWriteReport("PASSWITHSCREENSHOT", "Move LPN screen verification", "Move LPN screen is displayed")
	Else
		Call fnReportStepALM("Move LPN", "Failed", "Move LPN screen verification", "Should Display Move LPN Screen","Move LPN screen is not displayed")
		Call rptWriteReport("Fail", "Move LPN screen verification", "Move LPN screen is not displayed")
	End If 
	Set ObjFile= Nothing 
	'Enter LPN# 
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type iLPN_Number
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	'Drop the LPN
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	fnSynUntilFieldExists "Drop LPN", 15
	Set objFile = objFSO.OpenTextFile(StrFrameWorkFolder&"\Resources\Log.txt")
	strData = objFile.ReadAll
	'Verify Drop LPN Screen
	If Instr(strData, "Drop LPN")>0 Then
		Call fnReportStepALM("Drop LPN", "Passed", "Drop LPN  screen verification", "Should Display Drop LPN screen","Drop LPN screen is displayed")
		Call rptWriteReport("PASSWITHSCREENSHOT", "Drop LPN screen verification", "Drop LPN screen is displayed")
	Else
		Call fnReportStepALM("Drop LPN", "Failed", "Drop LPN screen verification", "Should Display Drop LPN Screen","Drop LPN screen is not displayed")
		Call rptWriteReport("Fail", "Drop LPN screen verification", "Drop LPN screen is not displayed")
	End If 
	Set ObjFile= Nothing
	Set objFSO = createobject("Scripting.filesystemobject")
	set objFile = objFSO.OpenTextFile (StrFrameWorkFolder&"\Resources\Log.txt")
	strData = objFile.ReadAll
	intSub = Instr(strData, "To Sub    :")
	intLoc = Instr(strData, "To Loc    :")
	intDrop = Instr(strData, "Confirm   ]")	
	strSubString = Mid(strData, intSub+11, Cint(intLoc)-Cint(intSub+11))
	strSub = Replace(strSubString, "Confirm   >[7m                                                 [0m", "")
	strLocString = Mid(strData, intLoc+11, Cint(intDrop)-Cint(intLoc+11))
	strLoc = Replace(strLocString, "Confirm   ][7m                                                 [0m", "")	
	sSub= Split(strSub, "Confirm   >[7m         [0m")
	Set re = New RegExp
	re.Pattern = "\s+"
	re.Global = True
	iToSub = Trim(re.Replace(sSub(0), " "))
	iToLOC= Trim(re.Replace(strLoc, " "))
	'Confirm to Sub
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type iToSub
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	Wait(02)
	'Confirm to Loc
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type iToLOC
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	Wait(02)
	'Drop Full LPN
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	fnSynUntilFieldExists "Task Complete", 20
	objFile.Close
	Set objFile = objFSO.OpenTextFile(StrFrameWorkFolder&"\Resources\Log.txt")
	strData = objFile.ReadAll
	If Instr(strData, "Task Complete")>0 Then
		Call fnReportStepALM("Drop Full LPN", "Passed", "Drop Full LPN confirmation screen verification", "Should Display Drop Full LPN confirmation screen","Drop Full LPN confirmation screen is displayed")
		Call rptWriteReport("PASSWITHSCREENSHOT", "Drop Full LPN confirmation screen verification", "Drop Full LPN confirmation screen is displayed")
	Else
		Call fnReportStepALM("Drop Full LPN", "Failed", "Drop Full LPN confirmation screen verification", "Should Display Drop Full LPN confirmation Screen","Drop Full LPN confirmation screen is not displayed")
		Call rptWriteReport("Fail", "Drop Full LPN confirmation screen verification", "Drop Full LPN confirmation screen is not displayed")
	End If 
	Set ObjFile=Nothing
	Set objFSO= Nothing 
	
End Function

'******************************************************************************************************************************************************************************************************************************************
'	Sub Name		 					:					fnPutawayForRMA
'	Objective							:					Putaway material received against ASN into Quickpick
'	Input Parameters					:					iOrganization_Number, iLPN_Number, iToSub, iToLOC
'	Output Parameters					:					NIL
'	Date Created						:					24-Mar-2017
'	QTP Version							:					UFT 12.53
'	QC Version							:					
'	Pre-requisites						:					NILL  
'	Created By							:					sreedhar metukuru
'	Modification Date					:	
'******************************************************************************************************************************************************************************************************************************************
Public Function fnPutawayForRMA(iOrganization_Number, iLPN_Number)
	'Verify ATDI Whse Ops Direc Screen
	If TeWindow("TeWindow").TeTextScreen("TeTextScreen").Exist(10) Then
		Call fnReportStepALM("ATDI Whse Ops Direc", "Passed", "ATDI Whse Ops Direc screen verification", "ATDI Whse Ops Direc screen should be displayed","ATDI Whse Ops Direc screen is displayed")
		Call rptWriteReport("PASSWITHSCREENSHOT", "ATDI Whse Ops Direc screen verification", "ATDI Whse Ops Direc screen is displayed")
	Else
		Call fnReportStepALM("ATDI Whse Ops Direc", "Failed", "ATDI Whse Ops Direc screen verification", "ATDI Whse Ops Direc Screen should be displayed","ATDI Whse Ops Direc screen is not displayed")
		Call rptWriteReport("Fail", "Receive screen verification", "Receive screen is not displayed")
	End If 	
	'Press 3 for Putaway
    If Ucase(Environment("CountryUS")) = "YES" and  Ucase(Environment("CountryCA")) = "NO" Then
		 Wait(MIN_WAIT)
		 TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type 1
		 TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
		 Wait(MIN_WAIT)
		 ''Ápply shot cut  F2+Y+ALT+ENTER
	     TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micF2 
	     Wait(1)
	     TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type "Y"
	     Wait(1)
	     TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micAltDwn+micReturn+micAltUp
		 Wait(MIN_WAIT)
		 TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micDwn	
 		 Wait(MIN_WAIT)
		 TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micDwn	
		 Wait(MIN_WAIT)
		 TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn 
		 Wait(MIN_WAIT)
		 TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn 
	ElseIf Ucase(Environment("CountryUS")) = "NO" and  Ucase(Environment("CountryCA")) = "YES" Then
		 Wait(MIN_WAIT)
		 TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micDwn	
		 Wait(MIN_WAIT)
		 TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micDwn	
		 Wait(MIN_WAIT)
		 TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micDwn	
		 Wait(MIN_WAIT)
		 TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micDwn	
		 Wait(MIN_WAIT)
		 TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
		 Wait(MIN_WAIT)
		 ''Ápply shot cut  F2+Y+ALT+ENTER
'	     TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micF2 
'	     Wait(1)
'	     TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type "Y"
'	     Wait(1)
'	     TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micAltDwn+micReturn+micAltUp
		 Wait(MIN_WAIT)
		 TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micDwn 
		 Wait(MIN_WAIT)
		 TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micDwn
		 Wait(MIN_WAIT)
		 TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn 
'		 Wait(MIN_WAIT)
'		 TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type 2
		 Wait(MIN_WAIT)
		 TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn  
	End If 
	'Press 3 for Putaway
'	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type 1
'	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	Wait(MIN_WAIT)
	'Verify Organization screen
	If TeWindow("TeWindow").TeTextScreen("TeTextScreen").Exist(10) Then
		Call fnReportStepALM("Organization", "Passed", "Organization screen verification", "Should Display Organization screen","Organization screen is displayed")
		Call rptWriteReport("PASSWITHSCREENSHOT", "Organization screen verification", "Organization screen is displayed")
	Else
		Call fnReportStepALM("Organizationr", "Failed", "Organization screen verification", "Should Display Organization Screen","Organization screen is not displayed")
		Call rptWriteReport("Fail", "Organization screen verification", "Organization screen is not displayed")
	End If 
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type iOrganization_Number
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	Wait(MIN_WAIT)
	'Verify Move LPN screen
	If TeWindow("TeWindow").TeTextScreen("TeTextScreen").Exist(10) Then
		Call fnReportStepALM("Move LPN", "Passed", "Move LPN  screen verification", "Should Display Move LPN screen","Move LPN screen is displayed")
		Call rptWriteReport("PASSWITHSCREENSHOT", "Move LPN screen verification", "Move LPN screen is displayed")
	Else
		Call fnReportStepALM("Move LPN", "Failed", "Move LPN screen verification", "Should Display Move LPN Screen","Move LPN screen is not displayed")
		Call rptWriteReport("Fail", "Move LPN screen verification", "Move LPN screen is not displayed")
	End If 
	'Enter LPN# 
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type iLPN_Number
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	'Drop the LPN
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	Wait(MIN_WAIT)
	'Verify Drop LPN Screen
	If TeWindow("TeWindow").TeTextScreen("TeTextScreen").Exist(10) Then
		Call fnReportStepALM("Drop LPN", "Passed", "Drop LPN  screen verification", "Should Display Drop LPN screen","Drop LPN screen is displayed")
		Call rptWriteReport("PASSWITHSCREENSHOT", "Drop LPN screen verification", "Drop LPN screen is displayed")
	Else
		Call fnReportStepALM("Drop LPN", "Failed", "Drop LPN screen verification", "Should Display Drop LPN Screen","Drop LPN screen is not displayed")
		Call rptWriteReport("Fail", "Drop LPN screen verification", "Drop LPN screen is not displayed")
	End If 
	''***********************************************************
	Set objFSOs=CreateObject("Scripting.FileSystemObject")
    set objFiles = objFSOs.OpenTextFile (StrFrameWorkFolder&"\Resources\Log.txt")
    strDatas = objFiles.ReadAll    
    lenSub=Len("To Sub    :")
    intSub = Instr(strDatas, "To Sub    :")
    intConfirm=Instr(strDatas,"Confirm   >")
    strToSub=Mid(strDatas,intSub+lenSub,intConfirm-(intSub+lenSub))
    
    intLoc = Instr(strDatas, "To Loc    :")
    intConfirm=Instr(intConfirm+1,strDatas,"Confirm   ]")
    strLOCdrop=Mid(strDatas,intLoc+Len("To Loc    :"),intConfirm-(intLoc+Len("To Loc    :")))

	''***********************************************************
	'Confirm to Sub
	'QUICKPICK
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type strToSub
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	Wait(MIN_WAIT)
	'Confirm to Loc
	'QUICK.01.A.
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type strLOCdrop
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	Wait(MID_WAIT)
	'Drop Full LPN
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	Wait(MID_WAIT)
	If TeWindow("TeWindow").TeTextScreen("TeTextScreen").Exist(10) Then
		Call fnReportStepALM("Drop Full LPN", "Passed", "Drop Full LPN confirmation screen verification", "Should Display Drop Full LPN confirmation screen","Drop Full LPN confirmation screen is displayed")
		Call rptWriteReport("PASSWITHSCREENSHOT", "Drop Full LPN confirmation screen verification", "Drop Full LPN confirmation screen is displayed")
	Else
		Call fnReportStepALM("Drop Full LPN", "Failed", "Drop Full LPN confirmation screen verification", "Should Display Drop Full LPN confirmation Screen","Drop Full LPN confirmation screen is not displayed")
		Call rptWriteReport("Fail", "Drop Full LPN confirmation screen verification", "Drop Full LPN confirmation screen is not displayed")
	End If 
	Wait(MAX_WAIT)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micAltDwn + micF4 + micAltUp
	If Dialog("PuTTY Exit Confirmation").Exist(2) Then
	  Dialog("PuTTY Exit Confirmation").WinButton("OK").Click
	End If
    Wait(MID_WAIT)
End Function

'******************************************************************************************************************************************************************************************************************************************
'	Sub Name		 					:					fnConfirmPickDropFedex
'	Objective							:					
'	Input Parameters					:					
'	Output Parameters					:					NIL
'	Date Created						:					07
'	QTP Version							:					UFT 12.0
'	QC Version							:					
'	Pre-requisites						:					NILL  
'	Created By							:					Balaji Veeravalli
'	Modification Date					:	
'******************************************************************************************************************************************************************************************************************************************
Public Function fnConfirmPickDropFedex(DictObj)	
	wait(MID_WAIT)
		intTransactionNu=fnReadTransactionNumber("GSOFedexShippingMethod")
		wait(MID_WAIT)
	'''''Transaction
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type trim(intTransactionNu)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn
	wait(MID_WAIT)
		rptWriteReport "Pass", "Enter Transaction Number" , "Entered Transaction Number "&trim(intTransactionNu)
		fnReportStepALM "Enter Transaction Number","Passed","Enter Transaction Number","Should Enter Transaction Number","Transaction Number entered "&intTransaction
		Set objFSO = createobject("Scripting.filesystemobject")
		 	set objFiles = objFSO.OpenTextFile (StrFrameWorkFolder&"\Resources\Log.txt")
		    strData = objFiles.ReadAll		
			lenSub=Len("Sub            :")
		    intSub = Instr(strData, "Sub            :")
		    intConfirm=Instr(strData,"Confirm        :")
		    strStock=Mid(strData,intSub+lenSub,intConfirm-(intSub+lenSub))
		    		    
		    intLoc = Instr(strData, "Loc            :")
		    intConfirm=Instr(intConfirm+1,strData,"Confirm")
		    strLOC=Mid(strData,intLoc+Len("Loc            :"),intConfirm-(intLoc+Len("Loc            :")))
		    
		    intItemDesc = Instr(strData, "Item Desc      :")
		    intItem = Instr(strData, "Item           :")
		    strDesc=Mid(strData,intItemDesc+Len("Item Desc      :"),intItem-(intItemDesc+Len("Item Desc      :")))
		    
		    intItem = Instr(strData, "Item           :")
		    intConfirm=Instr(intConfirm+1,strData,"Confirm")
		    strItem=Mid(strData,intItem+Len("Item           :"),intConfirm-(intItem+Len("Item           :")))
		    
		    intReqQty = Instr(strData, "Req Qty        :")
		    intConfirm=Instr(intConfirm+1,strData,"Confirm")
		    strReqQty=Mid(strData,intReqQty+Len("Req Qty        :"),intConfirm-(intReqQty+Len("Req Qty        :")))
	
	'Stock
'	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type DictObj.Item("Stock"&rKey)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type strStock
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	
	''''Confirm
'	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type DictObj.Item("Loc"&rKey)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type strLOC
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn
	wait(MIN_WAIT)
	''''Next Confirm
	iItemNumber=fnReadItemNumber("GSOFedexShippingMethod")
	wait(MIN_WAIT)
'	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type iItemNumber
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type strItem
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn
	wait(MIN_WAIT)
	''''Req QTY
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type strReqQty
'	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type DictObj.Item("Quantiy"&rKey)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn
	wait(MID_WAIT)
	Call rptWriteReport("PASSWITHSCREENSHOT", "Check shipment drop status","Shipment droped is sucessful")	
	''''XFer LPN
	'22500643417
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micCtrlDwn + "G" + micCtrlUp
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn
	Wait(7)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micDwn
	wait 1
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync
	
'''''''''''''''''''''''''''For Drop
wait(MID_WAIT)
		Set objFSOs = createobject("Scripting.filesystemobject")
		set objFiles = objFSOs.OpenTextFile (StrFrameWorkFolder&"\Resources\Log.txt")
		strDatas = objFiles.ReadAll	
            lenSub=Len("To Sub    :")
            intSub = Instr(strDatas, "To Sub    :")
            intConfirm=Instr(strDatas,"Confirm   >")
            strStageDrop=Mid(strDatas,intSub+lenSub,intConfirm-(intSub+lenSub))
         
	         intLoc = Instr(strDatas, "To Loc    :")
            intConfirm=Instr(intConfirm+1,strDatas,"Confirm   ]")
            strLOCdrop=Mid(strDatas,intLoc+Len("To Loc    :"),intConfirm-(intLoc+Len("To Loc    :")))
    
'		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type DictObj.Item("ToSub"&rKey)
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type strStageDrop
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync
'		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type DictObj.Item("ToLoc"&rKey)
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type strLOCdrop
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync
		wait(MIN_WAIT)
	Set objFSO = createobject("Scripting.filesystemobject")
	set objFile = objFSO.OpenTextFile (StrFrameWorkFolder&"\Resources\Log.txt")
		strData = objFile.ReadAll
		wait(MIN_WAIT)
			If Instr(strData, "Task Complete.") > 0 Then
				Call rptWriteReport("PASSWITHSCREENSHOT", "Check shipment status","Shipment droped is sucessful")
				fnReportStepALM "Drop success Messsage","Passed","Drop Shipment droped succesfully message","Drop shipped succesfully message should be displayed","Delivery shipped succesfully message is displayed"
			Else
				rptWriteReport "Fail", "Checking for delivery success message" , "Drop shipped succesfully message is not displayed"
				fnReportStepALM "Drop success Messsage","Failed","Drop shipped succesfully message","Drop shipped succesfully message should be displayed","Drop shipped succesfully message is not displayed"
			End If		
End Function
'******************************************************************************************************************************************************************************************************************************************
'	Sub Name		 					:					fnConfirmPickDropLTL
'	Objective							:					To Get pick related data from log file
'	Input Parameters					:					
'	Output Parameters					:					NIL
'	Date Created						:					28-Mar-2017
'	QTP Version							:					UFT 12.0
'	QC Version							:					
'	Pre-requisites						:					NILL  
'	Created By							:					Balaji Veeravalli
'	Modification Date					:	
'******************************************************************************************************************************************************************************************************************************************
Public Function fnConfirmPickDropLTL(DictObj)	
	wait(MID_WAIT)
	intTransactionNu=fnReadTransactionNumber("GSOLTL")
	wait(MID_WAIT)
	'''''Transaction
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type trim(intTransactionNu)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn
	wait(MID_WAIT)
		rptWriteReport "Pass", "Enter Transaction Number" , "Entered Transaction Number "&trim(intTransactionNu)
		fnReportStepALM "Enter Transaction Number","Passed","Enter Transaction Number","Should Enter Transaction Number","Transaction Number entered "&intTransaction
			Set objFSO = createobject("Scripting.filesystemobject")
		 	set objFiles = objFSO.OpenTextFile (StrFrameWorkFolder&"\Resources\Log.txt")
		    strData = objFiles.ReadAll		
				lenSub=Len("Sub            :")
			    intSub = Instr(strData, "Sub            :")
			    intConfirm=Instr(strData,"Confirm        :")
			    strStock=Mid(strData,intSub+lenSub,intConfirm-(intSub+lenSub))
			    		    
			    intLoc = Instr(strData, "Loc            :")
			    intConfirm=Instr(intConfirm+1,strData,"Confirm")
			    strLOC=Mid(strData,intLoc+Len("Loc            :"),intConfirm-(intLoc+Len("Loc            :")))
			    
			    intItemDesc = Instr(strData, "Item Desc      :")
			    intItem = Instr(strData, "Item           :")
			    strDesc=Mid(strData,intItemDesc+Len("Item Desc      :"),intItem-(intItemDesc+Len("Item Desc      :")))
			    
			    intItem = Instr(strData, "Item           :")
			    intConfirm=Instr(intConfirm+1,strData,"Confirm")
			    strItem=Mid(strData,intItem+Len("Item           :"),intConfirm-(intItem+Len("Item           :")))
			    
			    intReqQty = Instr(strData, "Req Qty        :")
			    intConfirm=Instr(intConfirm+1,strData,"Confirm")
			    strReqQty=Mid(strData,intReqQty+Len("Req Qty        :"),intConfirm-(intReqQty+Len("Req Qty        :")))
	
		'Stock
'	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type DictObj.Item("Stock"&rKey)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type strStock
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	
	''''Confirm
'	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type DictObj.Item("Loc"&rKey)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type strLOC
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn
	wait(MIN_WAIT)
	''''Next Confirm
	iItemNumber=fnReadItemNumber("GSOFedexShippingMethod")
	wait(MIN_WAIT)
'	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type iItemNumber
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type strItem
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn
	wait 1
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn
	wait(MIN_WAIT)
	''''Req QTY
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type strReqQty
'	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type DictObj.Item("Quantiy"&rKey)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn
	wait(MID_WAIT)
	Call rptWriteReport("PASSWITHSCREENSHOT", "Check shipment drop status","Shipment droped is sucessful")	
	''''XFer LPN
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micCtrlDwn + "G" + micCtrlUp
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn
	Wait(7)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micDwn
	wait 2
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync
	
'''''''''''''''''''''''''''For Drop
		wait(MID_WAIT)
		Set objFSOs = createobject("Scripting.filesystemobject")
		set objFiles = objFSOs.OpenTextFile (StrFrameWorkFolder&"\Resources\Log.txt")
		strDatas = objFiles.ReadAll	
            lenSub=Len("To Sub    :")
            intSub = Instr(strDatas, "To Sub    :")
            intConfirm=Instr(strDatas,"Confirm   >")
            strStageDrop=Mid(strDatas,intSub+lenSub,intConfirm-(intSub+lenSub))
         
	         intLoc = Instr(strDatas, "To Loc    :")
            intConfirm=Instr(intConfirm+1,strDatas,"Confirm   ]")
            strLOCdrop=Mid(strDatas,intLoc+Len("To Loc    :"),intConfirm-(intLoc+Len("To Loc    :")))
    
'		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type DictObj.Item("ToSub"&rKey)
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type strStageDrop
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync
'		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type DictObj.Item("ToLoc"&rKey)
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type strLOCdrop
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync
		wait(MIN_WAIT)
	Set objFSO = createobject("Scripting.filesystemobject")
	set objFile = objFSO.OpenTextFile (StrFrameWorkFolder&"\Resources\Log.txt")
		strData = objFile.ReadAll
		wait(MIN_WAIT)
		If Instr(strData, "Task Complete.") > 0 Then
			Call rptWriteReport("PASSWITHSCREENSHOT", "Check shipment status","Shipment droped is sucessful")
			fnReportStepALM "Drop success Messsage","Passed","Drop Shipment droped succesfully message","Drop shipped succesfully message should be displayed","Delivery shipped succesfully message is displayed"
		Else
			rptWriteReport "Fail", "Checking for delivery success message" , "Drop shipped succesfully message is not displayed"
			fnReportStepALM "Drop success Messsage","Failed","Drop shipped succesfully message","Drop shipped succesfully message should be displayed","Drop shipped succesfully message is not displayed"
		End If		
End Function
'******************************************************************************************************************************************************************************************************************************************
'	Sub Name		 					:					fnConfirmPickDropCPU
'	Objective							:					To Get pick related data from log file
'	Input Parameters					:					
'	Output Parameters					:					NIL
'	Date Created						:					28-Mar-2017
'	QTP Version							:					UFT 12.0
'	QC Version							:					
'	Pre-requisites						:					NILL  
'	Created By							:					Balaji Veeravalli
'	Modification Date					:	
'******************************************************************************************************************************************************************************************************************************************
Public Function fnConfirmPickDropCPU(DictObj)	
	wait(MID_WAIT)
	intTransactionNu=fnReadTransactionNumber("GSOCPU")
	wait(MID_WAIT)
	'''''Transaction
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type trim(intTransactionNu)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn
	wait(MID_WAIT)
		rptWriteReport "Pass", "Enter Transaction Number" , "Entered Transaction Number "&trim(intTransactionNu)
		fnReportStepALM "Enter Transaction Number","Passed","Enter Transaction Number","Should Enter Transaction Number","Transaction Number entered "&intTransaction
			Set objFSO = createobject("Scripting.filesystemobject")
		 	set objFiles = objFSO.OpenTextFile (StrFrameWorkFolder&"\Resources\Log.txt")
		    strData = objFiles.ReadAll		
				lenSub=Len("Sub            :")
			    intSub = Instr(strData, "Sub            :")
			    intConfirm=Instr(strData,"Confirm        :")
			    strStock=Mid(strData,intSub+lenSub,intConfirm-(intSub+lenSub))
			    		    
			    intLoc = Instr(strData, "Loc            :")
			    intConfirm=Instr(intConfirm+1,strData,"Confirm")
			    strLOC=Mid(strData,intLoc+Len("Loc            :"),intConfirm-(intLoc+Len("Loc            :")))
			    
			    intItemDesc = Instr(strData, "Item Desc      :")
			    intItem = Instr(strData, "Item           :")
			    strDesc=Mid(strData,intItemDesc+Len("Item Desc      :"),intItem-(intItemDesc+Len("Item Desc      :")))
			    
			    intItem = Instr(strData, "Item           :")
			    intConfirm=Instr(intConfirm+1,strData,"Confirm")
			    strItem=Mid(strData,intItem+Len("Item           :"),intConfirm-(intItem+Len("Item           :")))
			    
			    intReqQty = Instr(strData, "Req Qty        :")
			    intConfirm=Instr(intConfirm+1,strData,"Confirm")
			    strReqQty=Mid(strData,intReqQty+Len("Req Qty        :"),intConfirm-(intReqQty+Len("Req Qty        :")))
	
	
	'Stock
'	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type DictObj.Item("Stock"&rKey)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type strStock
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	
	''''Confirm
'	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type DictObj.Item("Loc"&rKey)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type strLOC
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn
	wait(MIN_WAIT)
	''''Next Confirm
	iItemNumber=fnReadItemNumber("GSOFedexShippingMethod")
	wait(MIN_WAIT)
'	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type iItemNumber
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type strItem
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn
	wait(MIN_WAIT)
	''''Req QTY
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type strReqQty
'	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type DictObj.Item("Quantiy"&rKey)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn
	wait(MID_WAIT)
	Call rptWriteReport("PASSWITHSCREENSHOT", "Check shipment drop status","Shipment droped is sucessful")	
	''''XFer LPN
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micCtrlDwn + "G" + micCtrlUp
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn
	Wait(7)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micDwn
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync
	
'''''''''''''''''''''''''''For Drop
		wait(MID_WAIT)
		Set objFSOs = createobject("Scripting.filesystemobject")
		set objFiles = objFSOs.OpenTextFile (StrFrameWorkFolder&"\Resources\Log.txt")
		strDatas = objFiles.ReadAll	
            lenSub=Len("To Sub    :")
            intSub = Instr(strDatas, "To Sub    :")
            intConfirm=Instr(strDatas,"Confirm   >")
            strStageDrop=Mid(strDatas,intSub+lenSub,intConfirm-(intSub+lenSub))
         
	         intLoc = Instr(strDatas, "To Loc    :")
            intConfirm=Instr(intConfirm+1,strDatas,"Confirm   ]")
            strLOCdrop=Mid(strDatas,intLoc+Len("To Loc    :"),intConfirm-(intLoc+Len("To Loc    :")))
    
'		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type DictObj.Item("ToSub"&rKey)
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type strStageDrop
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync
'		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type DictObj.Item("ToLoc"&rKey)
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type strLOCdrop
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync
		wait(MIN_WAIT)
	Set objFSO = createobject("Scripting.filesystemobject")
	set objFile = objFSO.OpenTextFile (StrFrameWorkFolder&"\Resources\Log.txt")
		strData = objFile.ReadAll
		wait(MIN_WAIT)
		If Instr(strData, "Task Complete.") > 0 Then
			Call rptWriteReport("PASSWITHSCREENSHOT", "Check shipment status","Shipment droped is sucessful")
			fnReportStepALM "Drop success Messsage","Passed","Drop Shipment droped succesfully message","Drop shipped succesfully message should be displayed","Delivery shipped succesfully message is displayed"
		Else
			rptWriteReport "Fail", "Checking for delivery success message" , "Drop shipped succesfully message is not displayed"
			fnReportStepALM "Drop success Messsage","Failed","Drop shipped succesfully message","Drop shipped succesfully message should be displayed","Drop shipped succesfully message is not displayed"
		End If		
End Function
 '******************************************************************************************************************************************************************************************************************************************
'	Sub Name		 					:					fnConfirmPickDropTL
'	Objective							:					To Get pick related data from log file
'	Input Parameters					:					
'	Output Parameters					:					NIL
'	Date Created						:					31-Mar-2017
'	QTP Version							:					UFT 12.0
'	QC Version							:					
'	Pre-requisites						:					NILL  
'	Created By							:					Balaji Veeravalli
'	Modification Date					:	
'******************************************************************************************************************************************************************************************************************************************
Public Function fnConfirmPickDropTL(DictObj)	
	wait(MID_WAIT)
	intTransactionNu=fnReadTransactionNumber("GSOTL")
	wait(MID_WAIT)
	'''''Transaction
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type trim(intTransactionNu)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn
	wait(MID_WAIT)
		rptWriteReport "Pass", "Enter Transaction Number" , "Entered Transaction Number "&trim(intTransactionNu)
		fnReportStepALM "Enter Transaction Number","Passed","Enter Transaction Number","Should Enter Transaction Number","Transaction Number entered "&intTransaction
			Set objFSO = createobject("Scripting.filesystemobject")
		 	set objFiles = objFSO.OpenTextFile (StrFrameWorkFolder&"\Resources\Log.txt")
		    strData = objFiles.ReadAll		
				lenSub=Len("Sub            :")
			    intSub = Instr(strData, "Sub            :")
			    intConfirm=Instr(strData,"Confirm        :")
			    strStock=Mid(strData,intSub+lenSub,intConfirm-(intSub+lenSub))
			    		    
			    intLoc = Instr(strData, "Loc            :")
			    intConfirm=Instr(intConfirm+1,strData,"Confirm")
			    strLOC=Mid(strData,intLoc+Len("Loc            :"),intConfirm-(intLoc+Len("Loc            :")))
			    
			    intItemDesc = Instr(strData, "Item Desc      :")
			    intItem = Instr(strData, "Item           :")
			    strDesc=Mid(strData,intItemDesc+Len("Item Desc      :"),intItem-(intItemDesc+Len("Item Desc      :")))
			    
			    intItem = Instr(strData, "Item           :")
			    intConfirm=Instr(intConfirm+1,strData,"Confirm")
			    strItem=Mid(strData,intItem+Len("Item           :"),intConfirm-(intItem+Len("Item           :")))
			    
			    intReqQty = Instr(strData, "Req Qty        :")
			    intConfirm=Instr(intConfirm+1,strData,"Confirm")
			    strReqQty=Mid(strData,intReqQty+Len("Req Qty        :"),intConfirm-(intReqQty+Len("Req Qty        :")))
	
	'Stock
'	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type DictObj.Item("Stock"&rKey)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type strStock
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	
	''''Confirm
'	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type DictObj.Item("Loc"&rKey)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type strLOC
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn
	wait(MIN_WAIT)
	''''Next Confirm
	iItemNumber=fnReadItemNumber("GSOFedexShippingMethod")
	wait(MIN_WAIT)
'	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type iItemNumber
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type strItem
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn
	wait(MIN_WAIT)
	''''Req QTY
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type strReqQty
'	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type DictObj.Item("Quantiy"&rKey)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn
	wait(MID_WAIT)
	Call rptWriteReport("PASSWITHSCREENSHOT", "Check shipment drop status","Shipment droped is sucessful")	
	''''XFer LPN
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micCtrlDwn + "G" + micCtrlUp
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn
	Wait(7)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micDwn
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync
	
'''''''''''''''''''''''''''For Drop
		wait(MID_WAIT)
		Set objFSOs = createobject("Scripting.filesystemobject")
		set objFiles = objFSOs.OpenTextFile (StrFrameWorkFolder&"\Resources\Log.txt")
		strDatas = objFiles.ReadAll	
            lenSub=Len("To Sub    :")
            intSub = Instr(strDatas, "To Sub    :")
            intConfirm=Instr(strDatas,"Confirm   >")
            strStageDrop=Mid(strDatas,intSub+lenSub,intConfirm-(intSub+lenSub))
         
	         intLoc = Instr(strDatas, "To Loc    :")
            intConfirm=Instr(intConfirm+1,strDatas,"Confirm   ]")
            strLOCdrop=Mid(strDatas,intLoc+Len("To Loc    :"),intConfirm-(intLoc+Len("To Loc    :")))
    
'		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type DictObj.Item("ToSub"&rKey)
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type strStageDrop
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync
'		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type DictObj.Item("ToLoc"&rKey)
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type strLOCdrop
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync
	wait(MIN_WAIT)
	Set objFSO = createobject("Scripting.filesystemobject")
	set objFile = objFSO.OpenTextFile (StrFrameWorkFolder&"\Resources\Log.txt")
		strData = objFile.ReadAll
		wait(MIN_WAIT)
		If Instr(strData, "Task Complete.") > 0 Then
			Call rptWriteReport("PASSWITHSCREENSHOT", "Check shipment status","Shipment droped is sucessful")
			fnReportStepALM "Drop success Messsage","Passed","Drop Shipment droped succesfully message","Drop shipped succesfully message should be displayed","Delivery shipped succesfully message is displayed"
		Else
			rptWriteReport "Fail", "Checking for delivery success message" , "Drop shipped succesfully message is not displayed"
			fnReportStepALM "Drop success Messsage","Failed","Drop shipped succesfully message","Drop shipped succesfully message should be displayed","Drop shipped succesfully message is not displayed"
		End If		
End Function
 '************************************************************************************************************************************************
'	Function Name	 	 :		fnOpenPuttyC
'	Objective			 :		Used to open Putty utility and set the configuration
'	Input Parameters	 :		NIL
'	Output Parameters	 :		NIL
'	Date Created		 :		04-Aprl-2017
'	QTP Version			 :		11.0
'	QC Version			 :		QC 11.53
'	Pre-requisites		 :		NIL  
'	Created By			 :								
'	Modification Date	 :		   
'************************************************************************************************************************************************
Public Function fnOpenPuttyC(strApp)
	If Window("PuTTY Configuration").Exist(2) Then
		Window("PuTTY Configuration").Close
	ElseIf TeWindow("TeWindow").Exist(2) Then
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micAltDwn + micF4 + micAltUp
		If Dialog("PuTTY Exit Confirmation").Exist Then
			Dialog("PuTTY Exit Confirmation").WinButton("OK").Click
		End If
	End If
	Wait(MIN_WAIT)
		Systemutil.Run (StrFrameWorkFolder&"\Resources\putty.exe")
	Wait(MID_WAIT)
			Call fnSynUntilObjExists(Window("PuTTY Configuration"),10)
		If Ucase(strApp) = "SSH" Then
			Window("PuTTY Configuration").WinEdit("txt_HostName").Set "ZQA.test.icd"
			Window("PuTTY Configuration").WinRadioButton("rad_SSH").Set
		ElseIf Ucase(strApp) = "TELNET" Then
			Window("PuTTY Configuration").WinEdit("txt_HostName").Set "WMSQA.test.icd"
			Window("PuTTY Configuration").WinRadioButton("rad_Telnet").Set
		End If
	Wait(2)
	Window("PuTTY Configuration").WinTreeView("tvw_Category:").Select 1
	Window("PuTTY Configuration").WinRadioButton("rad_AllSessionOutput").Set
	Set objFSO = createobject("Scripting.filesystemobject")
	Wait(2)
		If objFSO.FileExists(StrFrameWorkFolder&"\Resources\Log.txt")Then
		   objFSO.DeleteFile(StrFrameWorkFolder&"\Resources\Log.txt")
		   objFSO.CreateTextFile(StrFrameWorkFolder&"\Resources\Log.txt")
		End If
	Wait(2)
	Window("PuTTY Configuration").WinEdit("txt_LogFileName:").Set StrFrameWorkFolder&"\Resources\Log.txt"
	Window("PuTTY Configuration").WinTreeView("tvw_Category:").Select 3
	Window("PuTTY Configuration").WinRadioButton("rad_VT100+").Set
	Window("PuTTY Configuration").WinButton("btn_Open").Click
	wait(2)
		If Dialog("PuTTY Log to File").WinButton("btn_Yes").Exist(2) Then
			Dialog("PuTTY Log to File").WinButton("btn_Yes").Highlight
			Dialog("PuTTY Log to File").WinButton("btn_Yes").Click
		End If
	Wait(5)
	Call fnSynUntilObjExists(TeWindow("TeWindow"),7)
		If TeWindow("TeWindow").Exist(1) Then
			rptWriteReport "Pass", "Checking for emulator" , "Emulator window is displayed"
			fnReportStepALM "Emulator window","Passed","Emulator window display","Emulator window should be displayed","Emulator window is displayed"
		Else
			rptWriteReport "Fail", "Checking for SystemZ emulator" , "SystemZ window is not displayed"
			fnReportStepALM "Systemz window","Failed","SystemZ window display","Systemz window should be displayed","Systemz window is not displayed"
			ExitAction()
		End If		
End Function

'************************************************************************************************************************************************
'	Function Name	 	 :		fnPuttyLoginC
'	Objective			 :		Used to log into Putty utility for SystemZ
'	Input Parameters	 :		NIL
'	Output Parameters	 :		NIL
'	Date Created		 :		4-Aug-2016
'	QTP Version			 :		11.0
'	QC Version			 :		QC 11.53
'	Pre-requisites		 :		NIL  
'	Created By			 :								
'	Modification Date	 :		   
'************************************************************************************************************************************************

Public Function fnPuttyLoginC(sUserName, sPassword)
	TeWindow("TeWindow").Activate
	Wait(MIN_WAIT)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type sUserName
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	Wait(MIN_WAIT)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type sPassword
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	Wait(MIN_WAIT)
	If TeWindow("TeWindow").Exist(2) Then
		rptWriteReport "Pass", "SystemZ Login" , "Logged into SystemZ"
		fnReportStepALM "SystemZ Login","Passed","SystemZ Login","User should login to SystemZ","User has logged into SystemZ"
	End If	
	Wait(MIN_WAIT)
	If Environment("SystemZUserID")="eiv" Then
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type "z"
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
		Call fnSynUntilFieldExists(Trim("Enter MIS Program"),5)
	End If	
		
End Function
'************************************************************************************************************************************************
'	Function Name	 	 :		fnNavigateGenerateOrderC
'	Objective			 :		Used to log into Putty utility & Organization
'	Input Parameters	 :		NIL
'	Output Parameters	 :		NIL
'	Date Created		 :		04-April-2017
'	QTP Version			 :		11.0
'	QC Version			 :		QC 11.53
'	Pre-requisites		 :		NIL  
'	Created By			 :								
'	Modification Date	 :		   
'************************************************************************************************************************************************
Public Function fnNavigateGenerateOrderC(iOrgNumber)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type "chgsyn"
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
		Call fnSynUntilFieldExists(Trim("SET BRANCH TO:"),4)
	Wait(MIN_WAIT)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type iOrgNumber
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	Wait(MIN_WAIT)
	If TeWindow("TeWindow").Exist(2) Then
		rptWriteReport "Pass", "Change Organization" , "Organization changed to "&iOrgNumber
		Call rptWriteReport("PASSWITHSCREENSHOT","Change Organization","Organization changed to"&iOrgNumber)
		fnReportStepALM "Change Organization","Passed","Organization Change","Organization should be changed","Organization is changed to "&iOrgNumber
	End If
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	wait 1
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type "1"		
	wait 1
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	Wait(MIN_WAIT)
		If TeWindow("TeWindow").Exist(2) Then
			rptWriteReport "Pass", "Pick ticket menu" , "Pick ticket menu is displayed "
			Call rptWriteReport("PASSWITHSCREENSHOT", "Pick ticket menu" , "Pick ticket menu is displayed ")
			fnReportStepALM "Pick ticket","Passed","Pick ticket Screen","Pick ticket Screen should display","Pick ticket Screen is displayed"
		End If
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type "1"
	wait 1
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	call fnSynUntilFieldExists(Trim("CUSTOMER#:"),4)
		If TeWindow("TeWindow").Exist(1) Then
			rptWriteReport "Pass", "Customer Screen" , "Customer Screen is opened "
			fnReportStepALM "Customer Screen","Passed","Customer Screen display","Customer Screen should display","Customer Screen is displayed"
		End If	
End Function

'************************************************************************************************************************************************
'	Function Name	 	 :		fnCreateOrderGenericSalesC
'	Objective			 :		Used to create generic sales order
'	Input Parameters	 :		NIL
'	Output Parameters	 :		NIL
'	Date Created		 :		04-April-2017
'	QTP Version			 :		11.0
'	QC Version			 :		QC 11.53
'	Pre-requisites		 :		NIL  
'	Created By			 :		Balaji Veeravalli				
'	Modification Date	 :		   
'************************************************************************************************************************************************
Public Function fnCreateOrderGenericSalesC(iCustomerNo, iProductNo, iQuantity)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type iCustomerNo	
	wait 1
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	Call fnSynUntilFieldExists(Trim("Product#"),4)
		If TeWindow("TeWindow").Exist(1) Then
			rptWriteReport "Pass", "Customer Number" , "Customer number is entered "&iCustomerNo
			Call rptWriteReport("PASSWITHSCREENSHOT", "Customer Number" , "Customer number is entered "&iCustomerNo)
			fnReportStepALM "Customer number ","Passed","Enter Customer Number","Customer Number should be entered","Customer Number is entered "&iCustomerNo
		End If
				If Environment("TestName")=trim("EE_NTDGSOLTL") Then
					wait 3
						TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type "[]"
						wait 2
						TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
						Call fnSynUntilFieldExists(Trim("Carrier Code Name"),4)
						wait 1
						TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micDwn
						wait 2
						TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
				ElseIf Environment("TestName")=trim("EE_NTDGSOTL")  Then	
					wait 3
						TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type "[]"
						wait 2
						TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
						Call fnSynUntilFieldExists(Trim("Carrier Code Name"),4)
						wait 1
						TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micDwn
						wait 2
						TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micDwn
						wait 2
						TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micDwn
						wait 2
						TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micDwn
						wait 2
						TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micDwn
						wait 2
						TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micDwn
						wait 2
						TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micDwn
						wait 2
						TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
					Else
					Print "Expected is not available from the list"
				End If		
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type iProductNo
	wait 1
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn	
	Call fnSynUntilFieldExists(Trim("Local Plus......:"),4)
		If TeWindow("TeWindow").Exist(1) Then
			rptWriteReport "Pass", "Product Number" , "Product number is entered "&iProductNo
			Call rptWriteReport("PASSWITHSCREENSHOT", "Product number" , "Product number is entered "&iProductNo)
			fnReportStepALM "Product number ","Passed","Enter Product Number","Product Number should be entered","Product Number is entered "&iProductNo
		End If
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type iQuantity
	wait 2
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn	
	Call fnSynUntilFieldExists(Trim("Shipto Address"),5)
	Call rptWriteReport("PASSWITHSCREENSHOT", "Enter Quantity" , " Quantity is entered "&iQuantity)
			Set objFSO = createobject("Scripting.filesystemobject")
			set objFile = objFSO.OpenTextFile(StrFrameWorkFolder&"\Resources\Log.txt")
			strData = objFile.ReadAll
				If Instr(strData, "Will this be a booking order? N")>0 Then
					wait 2
					TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type "N"
					wait 1
'					TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type "Y"
					wait 2					
					Call fnSynUntilFieldExists(Trim("ShipTo Phones"),40)	
				End If
				set objFile= Nothing
				Set objFSO = Nothing		
End Function
'************************************************************************************************************************************************
'	Function Name	 	 :		fnSubmitOrderGenericSalesOrderGSOs
'	Objective			 :		Used to submit the order in Putty
'	Input Parameters	 :		NIL
'	Output Parameters	 :		NIL
'	Date Created		 :		04-Aprl-2017
'	QTP Version			 :		12.0
'	QC Version			 :		QC 11.53
'	Pre-requisites		 :		NIL  
'	Created By			 :		Balaji Veeravalli						
'	Modification Date	 :		   
'************************************************************************************************************************************************
Public Sub fnSubmitOrderGenericSalesOrderGSOs(DictObj)
wait(4)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micF1
		Call fnSynUntilFieldExists(Trim("Delivery Day"),45)	
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micDwn
		wait 2
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type DictObj.Item("ShippingMethod"&rKey) 
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn 
		wait 3
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micDwn
		wait 1
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micDwn
		wait 1
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micDwn
		wait 1
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micDwn
		wait(MAX_WAIT)
		Call fnSynUntilFieldExists(Trim("REGULAR"),90)
		Set objFSO = createobject("Scripting.filesystemobject")
		set objFile = objFSO.OpenTextFile (StrFrameWorkFolder&"\Resources\Log.txt")
		strData = objFile.ReadAll
		strSubmitLog = Instr(strData, "BOOKED")
			If strSubmitLog > 0 then
				rptWriteReport "Pass", "Checking for order submission" , "Order Submitted"
				Call rptWriteReport("PASSWITHSCREENSHOT", "Checking for order submission" ,"Order Submitted")
				fnReportStepALM "Submit Order","Passed","Order submission from SystemZ","Order should be submitted","Order is submitted"
			Else		
				rptWriteReport "Fail", "Checking for order submission" , "Order is not Submitted"
				fnReportStepALM "Submit Order","Failed","Order submission from SystemZ","Order should be submitted","Order is submitted"
			End If
		Set objFile= Nothing
		Set objFSO = Nothing
End Sub
'************************************************************************************************************************************************
'	Function Name	 	 :		fnSubmitOrderGenericSalesOrderGSOsNTD
'	Objective			 :		Used to submit the order in Putty
'	Input Parameters	 :		NIL
'	Output Parameters	 :		NIL
'	Date Created		 :		19-Aprl-2017
'	QTP Version			 :		12.0
'	QC Version			 :		QC 11.53
'	Pre-requisites		 :		NIL  
'	Created By			 :		Balaji Veeravalli						
'	Modification Date	 :		   
'************************************************************************************************************************************************
Public Sub fnSubmitOrderGenericSalesOrderGSOs(DictObj)
wait(4)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micF1
		Call fnSynUntilFieldExists(Trim("Delivery Day"),45)	
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micDwn
		wait 2
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type DictObj.Item("ShippingMethod"&rKey) 
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn 
		wait 3
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micDwn
		wait 1
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micDwn
		wait 1
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micDwn
		wait 1
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micDwn
	wait(MAX_WAIT)
	Call fnSynUntilFieldExists(Trim("REGULAR"),90)
		Set objFSO = createobject("Scripting.filesystemobject")
		set objFile = objFSO.OpenTextFile (StrFrameWorkFolder&"\Resources\Log.txt")
		strData = objFile.ReadAll
		strSubmitLog = Instr(strData, "BOOKED")
			If strSubmitLog > 0 then
				rptWriteReport "Pass", "Checking for order submission" , "Order Submitted"
				Call rptWriteReport("PASSWITHSCREENSHOT", "Checking for order submission" ,"Order Submitted")
				fnReportStepALM "Submit Order","Passed","Order submission from SystemZ","Order should be submitted","Order is submitted"
			Else		
				rptWriteReport "Fail", "Checking for order submission" , "Order is not Submitted"
				fnReportStepALM "Submit Order","Failed","Order submission from SystemZ","Order should be submitted","Order is submitted"
			End If
		Set objFile= Nothing
		Set objFSO = Nothing
End Sub

'************************************************************************************************************************************************
'	Function Name	 	 :		fnGetOrderNumberGSOC
'	Objective			 :		Used to get order from systemZ
'	Input Parameters	 :		NIL
'	Output Parameters	 :		NIL
'	Date Created		 :		04-Aprl-2017
'	QTP Version			 :		11.0
'	QC Version			 :		QC 11.53
'	Pre-requisites		 :		NIL  
'	Created By			 :		Balaji Veeravalli						
'	Modification Date	 :		   
'************************************************************************************************************************************************
Public Function fnGetOrderNumberGSOC()
On error resume next
	TeWindow("TeWindow").Activate
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micEsc
	Wait(2)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micAltDwn + micF4 + micAltUp
		If Dialog("PuTTY Exit Confirmation").Exist(2) Then
			Dialog("PuTTY Exit Confirmation").WinButton("OK").Click
		End If
	Set objFSO = createobject("Scripting.filesystemobject")
	set objFile = objFSO.OpenTextFile (StrFrameWorkFolder&"\Resources\Log.txt")
	strData = objFile.ReadAll
	Wait(1)
		strOrderString = Split(strData, "ORDER/RSVD")
		strOrderStrings=Split(strOrderString(1), "H")
		strOrderNo = Mid(Trim(strOrderStrings(1)),1, 9)
			If strOrderNo <> "" and Isnumeric(strOrderNo)=True and len(strOrderNo)=9 Then
				Call rptWriteReport("PASSWITHSCREENSHOT", "Checking for order number creation" , "Order number "&strOrderNo&" created")
				fnReportStepALM "Order Creation","Passed","Order number creation from SystemZ","Order Number should be created","Order Number "&strOrderNo&" is created"
			Else
				rptWriteReport "Fail", "Checking for order number creation" , "Order number "&strOrderNo&" created"
				fnReportStepALM "Order Creation","Failed","Order number creation from SystemZ","Order Number should be created","Order Number is not created"		
			End If	
	fnGetOrderNumberGSOC = trim(strOrderNo)
		Set objFile= Nothing
		Set objFSO = Nothing
End Function
 
 '************************************************************************************************************************************************
'	Function Name	 	 :		fnSubmitOrderGenericSalesOrderGSONTDTL
'	Objective			 :		Used to submit the order TL
'	Input Parameters	 :		NIL
'	Output Parameters	 :		NIL
'	Date Created		 :		14-Apr-2017
'	QTP Version			 :		12.0
'	QC Version			 :		QC 11.53
'	Pre-requisites		 :		NIL  
'	Created By			 :		Balaji Veeravalli						
'	Modification Date	 :		   
'************************************************************************************************************************************************
Public Sub fnSubmitOrderGenericSalesOrderGSONTDTL(DictObj)
wait(4)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micF1
	Call fnSynUntilFieldExists(Trim("Delivery Day"),7)	
			Set objFSO = createobject("Scripting.filesystemobject")
			set objFile = objFSO.OpenTextFile(StrFrameWorkFolder&"\Resources\Log.txt")
			strData = objFile.ReadAll
				If Instr(strData, "Will this be a booking order? N")>0 Then
					wait 2
					TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type "Y"
					wait 2					
					Call fnSynUntilFieldExists(Trim("Delivery Day"),40)	
				End If
				set objFile= Nothing
				Set objFSO = Nothing		
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micDwn
	wait 2
		If Environment("TestName")=Trim("EE_NTDGSOWOG") Then
			wait 3		
				TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micDwn
				wait 2
				TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn 
				wait 2		
			Else
'			wait 4
'				TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micDwn
'				wait 2
'				TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micDwn
'				wait 2
'				TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn 
				wait 4
		End If	
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type " "
	wait 1
	Call fnSynUntilFieldExists(Trim("Carrier"),10)	
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micDwn
	wait 1
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micDwn
	wait 1
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	wait 1
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micDwn
	wait 1
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micDwn
	wait 1
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micDwn
	wait 1
'		wait(MAX_WAIT)
		Call fnSynUntilFieldExists(Trim("REGULAR"),40)
		wait(MIN_WAIT)
		Set objFSO = createobject("Scripting.filesystemobject")
		set objFile = objFSO.OpenTextFile (StrFrameWorkFolder&"\Resources\Log.txt")
		strData = objFile.ReadAll
		strSubmitLog = Instr(strData, "BOOKED")
			If strSubmitLog > 0 then
				rptWriteReport "Pass", "Checking for order submission" , "Order Submitted"
				Call rptWriteReport("PASSWITHSCREENSHOT", "Checking for order submission" ,"Order Submitted")
				fnReportStepALM "Submit Order","Passed","Order submission from SystemZ","Order should be submitted","Order is submitted"
			Else		
				rptWriteReport "Fail", "Checking for order submission" , "Order is not Submitted"
				fnReportStepALM "Submit Order","Failed","Order submission from SystemZ","Order should be submitted","Order is submitted"
			End If
		Set objFile= Nothing
		Set objFSO = Nothing	
End Sub
 '************************************************************************************************************************************************
'	Function Name	 	 :		fnSubmitOrderGenericSalesOrderGSONTDLTL
'	Objective			 :		Used to submit the order LTL
'	Input Parameters	 :		NIL
'	Output Parameters	 :		NIL
'	Date Created		 :		24-Apr-2017
'	QTP Version			 :		12.0
'	QC Version			 :		QC 11.53
'	Pre-requisites		 :		NIL  
'	Created By			 :		Balaji Veeravalli						
'	Modification Date	 :		   
'************************************************************************************************************************************************
Public Sub fnSubmitOrderGenericSalesOrderGSONTDLTL(DictObj)
wait(4)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micF1
	Call fnSynUntilFieldExists(Trim("Delivery Day"),7)	
			Set objFSO = createobject("Scripting.filesystemobject")
			set objFile = objFSO.OpenTextFile(StrFrameWorkFolder&"\Resources\Log.txt")
			strData = objFile.ReadAll
'				If Instr(strData, "Will this be a booking order? N")>0 Then
				If Instr(strData, "Will this be a booking order")>0 Then
					wait 2
					TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type "Y"
					wait 2					
					Call fnSynUntilFieldExists(Trim("Delivery Day"),40)	
				End If
				set objFile= Nothing
				Set objFSO = Nothing		
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micDwn
	wait 2	
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micDwn
	wait 2
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micDwn
	wait 2	
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micDwn
	wait 1
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micDwn
	wait 1	
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micDwn
'		wait(MAX_WAIT)
		Call fnSynUntilFieldExists(Trim("REGULAR"),70)
		wait(MIN_WAIT)
		Set objFSO = createobject("Scripting.filesystemobject")
		set objFile = objFSO.OpenTextFile (StrFrameWorkFolder&"\Resources\Log.txt")
		strData = objFile.ReadAll
		strSubmitLog = Instr(strData, "BOOKED")
			If strSubmitLog > 0 then
				rptWriteReport "Pass", "Checking for order submission" , "Order Submitted"
				Call rptWriteReport("PASSWITHSCREENSHOT", "Checking for order submission" ,"Order Submitted")
				fnReportStepALM "Submit Order","Passed","Order submission from SystemZ","Order should be submitted","Order is submitted"
			Else		
				rptWriteReport "Fail", "Checking for order submission" , "Order is not Submitted"
				fnReportStepALM "Submit Order","Failed","Order submission from SystemZ","Order should be submitted","Order is submitted"
			End If
		Set objFile= Nothing
		Set objFSO = Nothing	
End Sub
 
' ******************************************************************************************************************************************************************************************************************************************
'	Sub Name		 					:					fnConfirmPickDropDCDirect1
'	Objective							:					To Get pick related data from log file
'	Input Parameters					:					
'	Output Parameters					:					NIL
'	Date Created						:					28-Mar-2017
'	QTP Version							:					UFT 12.0
'	QC Version							:					
'	Pre-requisites						:					NILL  
'	Created By							:					Balaji Veeravalli
'	Modification Date					:	
'******************************************************************************************************************************************************************************************************************************************
Public Function fnConfirmPickDropDCDirect1(DictObj)	
	wait(MIN_WAIT)
		If Instr(Environment("ActionName"),"EE_GenericSalesOrder2")>0 Then
			intTransactionNu=fnReadTransactionNumber("Generic Sales Order")
		Else
			intTransactionNu=fnReadTransactionNumber("DC Direct")
		End If	
	wait(MIN_WAIT)
	'''''Transaction
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type trim(intTransactionNu)
	wait(MIN_WAIT)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn
	wait(MID1_WAIT)
		rptWriteReport "Pass", "Enter Transaction Number" , "Entered Transaction Number "&trim(intTransactionNu)
		fnReportStepALM "Enter Transaction Number","Passed","Enter Transaction Number","Should Enter Transaction Number","Transaction Number entered "&intTransaction
			Set objFSO = createobject("Scripting.filesystemobject")
		 	set objFiles = objFSO.OpenTextFile (StrFrameWorkFolder&"\Resources\Log.txt")
		    strData = objFiles.ReadAll		
		    wait 4
				lenSub=Len("Sub            :")
			    intSub = Instr(strData, "Sub            :")
			    intConfirm=Instr(strData,"Confirm        :")
			    strStock=Mid(strData,intSub+lenSub,intConfirm-(intSub+lenSub))
			    		    
			    intLoc = Instr(strData, "Loc            :")
			    intConfirm=Instr(intConfirm+1,strData,"Confirm")
			    strLOC=Mid(strData,intLoc+Len("Loc            :"),intConfirm-(intLoc+Len("Loc            :")))
			    
			    intItemDesc = Instr(strData, "Item Desc      :")
			    intItem = Instr(strData, "Item           :")
			    strDesc=Mid(strData,intItemDesc+Len("Item Desc      :"),intItem-(intItemDesc+Len("Item Desc      :")))
			    
			    intItem = Instr(strData, "Item           :")
			    intConfirm=Instr(intConfirm+1,strData,"Confirm")
			    strItem=Mid(strData,intItem+Len("Item           :"),intConfirm-(intItem+Len("Item           :")))
			    
			    intReqQty = Instr(strData, "Req Qty        :")
			    intConfirm=Instr(intConfirm+1,strData,"Confirm")
			    strReqQty=Mid(strData,intReqQty+Len("Req Qty        :"),intConfirm-(intReqQty+Len("Req Qty        :")))
	wait(MIN_WAIT)
	'Stock
'	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type DictObj.Item("Stock"&rKey)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type strStock
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	
	''''Confirm
'	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type DictObj.Item("Loc"&rKey)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type strLOC
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn
	wait(MIN_WAIT)
	''''Next Confirm
'	iItemNumber=fnReadItemNumber("DC Direct")
	wait(MIN_WAIT)
'	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type iItemNumber
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type strItem
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn
	wait 2
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn
	wait(MIN_WAIT)
	''''Req QTY
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type strReqQty
'	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type DictObj.Item("Quantiy"&rKey)
	wait 4
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn
	wait(MID_WAIT)
	Call rptWriteReport("PASSWITHSCREENSHOT", "Check shipment drop status","Shipment droped is sucessful")
	''''XFer LPN
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micCtrlDwn + "G" + micCtrlUp
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn
	Wait(7)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micDwn
	Wait(2)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync
	
'''''''''''''''''''''''''''For Drop
wait(MID_WAIT)
		Set objFSOs = createobject("Scripting.filesystemobject")
		Set objFiles = objFSOs.OpenTextFile (StrFrameWorkFolder&"\Resources\Log.txt")
		strDatas = objFiles.ReadAll	
		wait 2
            lenSub=Len("To Sub    :")
            intSub = Instr(strDatas, "To Sub    :")
            intConfirm=Instr(strDatas,"Confirm   >")
            strStageDrop=Mid(strDatas,intSub+lenSub,intConfirm-(intSub+lenSub))
         
	         intLoc = Instr(strDatas, "To Loc    :")
            intConfirm=Instr(intConfirm+1,strDatas,"Confirm   ]")
            strLOCdrop=Mid(strDatas,intLoc+Len("To Loc    :"),intConfirm-(intLoc+Len("To Loc    :")))
    
    
'		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type DictObj.Item("ToSub"&rKey)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type strStageDrop
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn
		wait 4
'		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type DictObj.Item("ToLoc"&rKey)
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type strLOCdrop
		wait 2
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn
		wait 4
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn
		wait 4
	wait(MIN_WAIT)
	Set objFSO = createobject("Scripting.filesystemobject")
	set objFile = objFSO.OpenTextFile (StrFrameWorkFolder&"\Resources\Log.txt")
	strData = objFile.ReadAll
	wait(MIN_WAIT)
		If Instr(strData, "Task Complete.") > 0 Then
			Call rptWriteReport("PASSWITHSCREENSHOT", "Check shipment status","Shipment droped is sucessful")
			fnReportStepALM "Drop success Messsage","Passed","Drop Shipment droped succesfully message","Drop shipped succesfully message should be displayed","Delivery shipped succesfully message is displayed"
		Else
			rptWriteReport "Fail", "Checking for delivery success message" , "Drop shipped succesfully message is not displayed"
			fnReportStepALM "Drop success Messsage","Failed","Drop shipped succesfully message","Drop shipped succesfully message should be displayed","Drop shipped succesfully message is not displayed"
		End If		
		Set objFile= Nothing
		Set objFSO = Nothing
		Set objFiles= Nothing
		Set objFSOs= Nothing
End Function
  '******************************************************************************************************************************************************************************************************************************************
'	Sub Name		 					:					fnConfirmPickDropDCDirectGenericSales
'	Objective							:					
'	Input Parameters					:					
'	Output Parameters					:					NIL
'	Date Created						:					10-Mar-2017
'	QTP Version							:					UFT 12.0
'	QC Version							:					
'	Pre-requisites						:					NILL  
'	Created By							:					Balaji Veeravalli
'	Modification Date					:	
'******************************************************************************************************************************************************************************************************************************************

Public Function fnConfirmPickDropDCDirectGenericSales(DictObj)	
'	wait(MID_WAIT)
'		intTransactionNu=fnReadTransactionNumber("Generic Sales Order")
	If Instr(Ucase(Environment("ActionName")),Ucase("DCD"))>0 AND Instr(Ucase(Environment("ActionName")),Ucase("Generic"))=0 Then
		intTransactionNu=fnReadTransactionNumber("DC Direct")
	Else
		intTransactionNu=fnReadTransactionNumber("Generic Sales Order")
	End If
'		wait(MID_WAIT)
	'''''Transaction
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type trim(intTransactionNu)
'	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn
	wait(MID_WAIT)
		rptWriteReport "Pass", "Enter Transaction Number" , "Entered Transaction Number "&trim(intTransactionNu)
		fnReportStepALM "Enter Transaction Number","Passed","Enter Transaction Number","Should Enter Transaction Number","Transaction Number entered "&intTransaction
		Set objFSOs = createobject("Scripting.filesystemobject")
		 	set objFiles = objFSOs.OpenTextFile (StrFrameWorkFolder&"\Resources\Log.txt")
		    strData = objFiles.ReadAll		
'			lenSub=Len("Sub       :")
'		    intSub = Instr(strData, "Sub       :")
'		    intConfirm=Instr(strData,"Confirm   :")
'		    strStock=Mid(strData,intSub+lenSub,intConfirm-(intSub+lenSub))
'		    		    
'		    intLoc = Instr(strData, "Loc       :")
'		    intConfirm=Instr(intConfirm+1,strData,"Confirm")
'		    strLOC=Mid(strData,intLoc+Len("Loc       :"),intConfirm-(intLoc+Len("Loc       :")))
'		    
'		    intItemDesc = Instr(strData, "Item Desc :")
'		    intItem = Instr(strData, "Item Desc :")
'		    If intItem-(intItemDesc+Len("Item Desc :"))>0 Then''Çondition added by Pradeep on 27-April-2017.
'		    	strDesc=Mid(strData,intItemDesc+Len("Item Desc :"),intItem-(intItemDesc+Len("Item Desc :")))	
'		    End If
'		    		    
'		    intItem = Instr(strData, "Item      :")
'		    intConfirm=Instr(intConfirm+1,strData,"Confirm")
'		    strItem=Mid(strData,intItem+Len("Item      :"),intConfirm-(intItem+Len("Item      :")))
'		    
'		    intReqQty = Instr(strData, "Req Qty   :")
'		    intConfirm=Instr(intConfirm+1,strData,"Confirm")
'		    strReqQty=Mid(strData,intReqQty+Len("Req Qty   :"),intConfirm-(intReqQty+Len("Req Qty   :")))
	
		lenSub=Len("Sub                 :")
	    intSub = Instr(strData, "Sub                 :")
	    intConfirm=Instr(strData,"Confirm             :")
	    strStock=Mid(strData,intSub+lenSub,intConfirm-(intSub+lenSub))
	    		    
	    intLoc = Instr(strData, "Loc                 :")
	    intConfirm=Instr(intConfirm+1,strData,"Confirm")
	    strLOC=Mid(strData,intLoc+Len("Loc                 :"),intConfirm-(intLoc+Len("Loc                 :")))
	    
	    intItemDesc = Instr(strData, "Item Desc           :")
	    intItem = Instr(strData, "Item Desc           :")
	    If intItem-(intItemDesc+Len("Item Desc           :"))>0 Then''Çondition added by Pradeep on 27-April-2017.
	    	strDesc=Mid(strData,intItemDesc+Len("Item Desc           :"),intItem-(intItemDesc+Len("Item Desc           :")))	
	    End If
	    		    
	    intItem = Instr(strData, "Item                :")
	    intConfirm=Instr(intConfirm+1,strData,"Confirm")
	    strItem=Mid(strData,intItem+Len("Item                :"),intConfirm-(intItem+Len("Item                :")))
	    
	    intReqQty = Instr(strData, "Req Qty             :")
	    intConfirm=Instr(intConfirm+1,strData,"Confirm")
	    strReqQty=Mid(strData,intReqQty+Len("Req Qty             :"),intConfirm-(intReqQty+Len("Req Qty             :")))

		'Stock
'	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type DictObj.Item("Stock"&rKey)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type strStock:wait 1
'	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	
	''''Confirm
'	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type DictObj.Item("Loc"&rKey)
TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type strLOC:wait 1
'	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn:wait 1
'	wait(MIN_WAIT)
	''''Next Confirm
	iItemNumber=fnReadItemNumber("DC Direct")
	wait(MIN_WAIT)
'	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type iItemNumber
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type strItem:wait 1
'	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn:wait 1
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn:wait 1
'	wait(MIN_WAIT)
	''''Req QTY
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type strReqQty:wait 1
'	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type DictObj.Item("Quantiy"&rKey)
'	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn:wait 1
'	wait(MID_WAIT)
	
	''''XFer LPN
	'22500643417
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micCtrlDwn + "G" + micCtrlUp:wait 1	
'	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn
	Wait(MIN_WAIT)
	Call rptWriteReport("PASSWITHSCREENSHOT", "Check shipment drop status","Shipment droped is sucessful")
	
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micDwn
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn
'	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync
	
'''''''''''''''''''''''''''For Drop
wait(MID_WAIT)
		Set objFSOs = createobject("Scripting.filesystemobject")
		set objFiles = objFSOs.OpenTextFile (StrFrameWorkFolder&"\Resources\Log.txt")
		strDatas = objFiles.ReadAll	
            lenSub=Len("To Sub    :")
            intSub = Instr(strDatas, "To Sub    :")
            intConfirm=Instr(strDatas,"Confirm   >")
            strStageDrop=Mid(strDatas,intSub+lenSub,intConfirm-(intSub+lenSub))
         
	         intLoc = Instr(strDatas, "To Loc    :")
            intConfirm=Instr(intConfirm+1,strDatas,"Confirm   ]")
            strLOCdrop=Mid(strDatas,intLoc+Len("To Loc    :"),intConfirm-(intLoc+Len("To Loc    :")))
    
'		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type DictObj.Item("ToSub"&rKey)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type strStageDrop:wait 1
'		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn:wait 1
'		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync
'		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type DictObj.Item("ToLoc"&rKey)
TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type strLOCdrop:wait 1
'		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn:wait 1
'		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync
	wait(MIN_WAIT)
	Set objFSO = createobject("Scripting.filesystemobject")
	set objFile = objFSO.OpenTextFile (StrFrameWorkFolder&"\Resources\Log.txt")
	strData = objFile.ReadAll
	wait(MIN_WAIT)
		If Instr(strData, "Task Complete.") > 0 Then
			Call rptWriteReport("PASSWITHSCREENSHOT", "Check shipment status","Shipment droped is sucessful")
			fnReportStepALM "Drop success Messsage","Passed","Drop Shipment droped succesfully message","Drop shipped succesfully message should be displayed","Delivery shipped succesfully message is displayed"
		Else
			rptWriteReport "Fail", "Checking for delivery success message" , "Drop shipped succesfully message is not displayed"
			fnReportStepALM "Drop success Messsage","Failed","Drop shipped succesfully message","Drop shipped succesfully message should be displayed","Drop shipped succesfully message is not displayed"
		End If	
		Set objFile= Nothing
		Set objFSO = Nothing
		Set objFiles= Nothing
		Set objFSOs= Nothing		
End Function
  
  '************************************************************************************************************************************************
'	Function Name	 	 :		fnSubmitOrderGenericSalesOrderGSONTD
'	Objective			 :		Used to submit the order in Putty
'	Input Parameters	 :		NIL
'	Output Parameters	 :		NIL
'	Date Created		 :		06-Aprl-2017
'	QTP Version			 :		12.0
'	QC Version			 :		QC 11.53
'	Pre-requisites		 :		NIL  
'	Created By			 :		Balaji Veeravalli						
'	Modification Date	 :		   
'************************************************************************************************************************************************
Public Sub fnSubmitOrderGenericSalesOrderGSONTD(DictObj)
wait(4)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micF1
	Call fnSynUntilFieldExists(Trim("Delivery Day"),7)	
			Set objFSO = createobject("Scripting.filesystemobject")
			set objFile = objFSO.OpenTextFile(StrFrameWorkFolder&"\Resources\Log.txt")
			strData = objFile.ReadAll
				If Instr(strData, "Will this be a booking order? N")>0 Then
					wait 2
					TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type "N"
					wait 1
'					TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type "Y"
					wait 2					
					Call fnSynUntilFieldExists(Trim("Delivery Day"),40)	
				End If
				set objFile= Nothing
				Set objFSO = Nothing		
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micDwn
		wait 2
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type DictObj.Item("ShippingMethod"&rKey) 
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn 
		wait 3
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micDwn
		wait 1
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micDwn
		wait 1
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micDwn
		wait 1
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micDwn
	wait(MAX_WAIT)
	Call fnSynUntilFieldExists(Trim("REGULAR"),90)
		wait(MIN_WAIT)
		Set objFSO = createobject("Scripting.filesystemobject")
		set objFile = objFSO.OpenTextFile (StrFrameWorkFolder&"\Resources\Log.txt")
		strData = objFile.ReadAll
		strSubmitLog = Instr(strData, "BOOKED")
			If strSubmitLog > 0 then
				rptWriteReport "Pass", "Checking for order submission" , "Order Submitted"
				Call rptWriteReport("PASSWITHSCREENSHOT", "Checking for order submission" ,"Order Submitted")
				fnReportStepALM "Submit Order","Passed","Order submission from SystemZ","Order should be submitted","Order is submitted"
			Else		
				rptWriteReport "Fail", "Checking for order submission" , "Order is not Submitted"
				fnReportStepALM "Submit Order","Failed","Order submission from SystemZ","Order should be submitted","Order is submitted"
			End If
		Set objFile= Nothing
		Set objFSO = Nothing	
End Sub

'******************************************************************************************************************************************************************************************************************************************
'	Sub Name		 					:					fnConfirmShipDCDirect1
'	Objective							:					fnConfirmShipDCDirect1
'	Input Parameters					:					
'	Output Parameters					:					NIL
'	Date Created						:					07-Mar-2017
'	QTP Version							:					UFT 12.0
'	QC Version							:					
'	Pre-requisites						:					NILL  
'	Created By							:					Balaji Veeravalli
'	Modification Date					:	
'******************************************************************************************************************************************************************************************************************************************
  Public Function fnConfirmShipDCDirect1()
		Wait(MIN_WAIT)
'		strDeliveryNo=fnReadDeliveryNumber("DC Direct")
	If Instr(Ucase(Environment("ActionName")),Ucase("DCD"))>0 AND Instr(Ucase(Environment("ActionName")),Ucase("Generic"))=0 Then''Ádded by Pradeep
		strDeliveryNo=fnReadDeliveryNumber("DC Direct")
	Else
		strDeliveryNo=fnReadDeliveryNumber("Generic Sales Order")
	End If
		WAIT 3
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type strDeliveryNo
		Wait(MIN_WAIT)
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn 
'		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync
		WAIT 3
	If Instr(Ucase(Environment("ActionName")),Ucase("DCD"))>0 AND Instr(Ucase(Environment("ActionName")),Ucase("Generic"))=0 Then''Ádded by Pradeep
		strItemNo=fnReadItemNumber("DC Direct")
	Else
		strItemNo=fnReadItemNumber("Generic Sales Order")
	End If
'	strItemNo=fnReadItemNumber("DC Direct")
'	Wait(MIN_WAIT)
'	strItemNo=fnReadDeliveryNumber("DC Direct")
	'Item Number
'	Wait(MIN_WAIT)
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type strItemNo:Wait 3
'		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn 
		Wait(MIN_WAIT)
		Call rptWriteReport("PASSWITHSCREENSHOT", "Check shipment status","Drop status is sucessful...")
	''''Find Lines
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn 
'		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync
		Wait(MIN_WAIT)
	'''Done
'	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn 
'	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync
'	.....Ship Confirm
		Wait(MIN_WAIT)
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type strItemNo 
		Wait(MIN_WAIT)
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn 
'		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync
		Wait(MIN_WAIT)
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn 
'		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync
		Wait 4
	'''''''''''''''''
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn 
		Wait(MIN_WAIT)
		Call rptWriteReport("PASSWITHSCREENSHOT", "Check shipment status","Drop status is sucessful...")
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn 
'		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync
		Wait(MID_WAIT)
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn 
'		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync
		Wait(MIN_WAIT)
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn 
		Wait(MIN_WAIT)
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn 
'		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync
	Wait(15)
	Set objFSO = createobject("Scripting.filesystemobject")
	set objFile = objFSO.OpenTextFile (StrFrameWorkFolder&"\Resources\Log.txt")
	strData = objFile.ReadAll		
	wait(MIN_WAIT)
		If Instr(strData, "Delivery") > 0  AND  Instr(strData,strDeliveryNo) > 0 Then
			Call rptWriteReport("PASSWITHSCREENSHOT", "Check shipment status","Shipment status is sucessful..."&strDeliveryNo)
			fnReportStepALM "Delivery success Messsage","Passed","Delivery shipped succesfully message","Delivery shipped succesfully message should be displayed","Delivery shipped succesfully message is displayed"&strDeliveryNo
		Else
			rptWriteReport "Fail", "Checking for delivery success message" , "Delivery shipped succesfully message is not displayed.."&strDeliveryNo
			fnReportStepALM "Delivery success Messsage","Failed","Delivery shipped succesfully message","Delivery shipped succesfully message should be displayed","Delivery shipped succesfully message is not displayed.."&strDeliveryNo
		End If			
End Function

'******************************************************************************************************************************************************************************************************************************************
'	Sub Name		 					:					fnConfirmShipDCDirect1
'	Objective							:					fnConfirmShipDCDirect1
'	Input Parameters					:					
'	Output Parameters					:					NIL
'	Date Created						:					07-Mar-2017
'	QTP Version							:					UFT 12.0
'	QC Version							:					
'	Pre-requisites						:					NILL  
'	Created By							:					Balaji Veeravalli
'	Modification Date					:	
'******************************************************************************************************************************************************************************************************************************************
  Public Function fnConfirmShipFedex()
		Wait(MIN_WAIT)
		strDeliveryNo=fnReadDeliveryNumber("GSOFedexShippingMethod")
		strItemNo=fnReadItemNumber("GSOFedexShippingMethod")
		Wait(MIN_WAIT)
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type strDeliveryNo
		Wait(MIN_WAIT)
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn 
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync
		Wait(MIN_WAIT)
	'Item Number
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type strItemNo
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn 
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync
		Wait(MIN_WAIT)
		Call rptWriteReport("PASSWITHSCREENSHOT", "Check shipment status","Drop status is sucessful...")
	''''Find Lines
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn 
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync
			
	'''Done
'	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn 
'	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync
'	.....Ship Confirm
		Wait(MIN_WAIT)
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type strItemNo 
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync	
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn 
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync
		Wait(MIN_WAIT)
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn 
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync
	
	'''''''''''''''''
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn 
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync
		Call rptWriteReport("PASSWITHSCREENSHOT", "Check shipment status","Drop status is sucessful...")
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn 
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync
		Wait(MID_WAIT)
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn 
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync
	
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn 
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync
		Wait(4)
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn 
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync
	Wait(15)
	Set objFSO = createobject("Scripting.filesystemobject")
	set objFile = objFSO.OpenTextFile (StrFrameWorkFolder&"\Resources\Log.txt")
	strData = objFile.ReadAll
wait(MIN_WAIT)	
		If Instr(strData, "Delivery") > 0  AND  Instr(strData,strDeliveryNo) > 0 Then
			Call rptWriteReport("PASSWITHSCREENSHOT", "Check shipment status","Shipment status is sucessful..."&strDeliveryNo)
			fnReportStepALM "Delivery success Messsage","Passed","Delivery shipped succesfully message","Delivery shipped succesfully message should be displayed","Delivery shipped succesfully message is displayed"&strDeliveryNo
		Else
			rptWriteReport "Fail", "Checking for delivery success message" , "Delivery shipped succesfully message is not displayed.."&strDeliveryNo
			fnReportStepALM "Delivery success Messsage","Failed","Delivery shipped succesfully message","Delivery shipped succesfully message should be displayed","Delivery shipped succesfully message is not displayed.."&strDeliveryNo
		End If			
End Function
'******************************************************************************************************************************************************************************************************************************************
'	Sub Name		 					:					fnConfirmShipLTL
'	Objective							:					fnConfirmShipLTL
'	Input Parameters					:					
'	Output Parameters					:					NIL
'	Date Created						:					28-Mar-2017
'	QTP Version							:					UFT 12.0
'	QC Version							:					
'	Pre-requisites						:					NILL  
'	Created By							:					Balaji Veeravalli
'	Modification Date					:	
'******************************************************************************************************************************************************************************************************************************************
  Public Function fnConfirmShipLTL()
		Wait(MIN_WAIT)
		strDeliveryNo=fnReadDeliveryNumber("GSOLTL")
		strItemNo=fnReadItemNumber("GSOLTL")
		Wait(MIN_WAIT)
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type strDeliveryNo
		Wait(MIN_WAIT)
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn 
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync
		Wait(MIN_WAIT)
	'Item Number
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type strItemNo
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn 
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync
		Wait(MIN_WAIT)
		Call rptWriteReport("PASSWITHSCREENSHOT", "Check shipment status","Drop status is sucessful...")
	''''Find Lines
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn 
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync
			
	'''Done
'	.....Ship Confirm
		Wait(MIN_WAIT)
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type strItemNo 
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync	
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn 
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync
		Wait(MIN_WAIT)
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn 
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync
	
	'''''''''''''''''
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn 
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync
		Call rptWriteReport("PASSWITHSCREENSHOT", "Check shipment status","Ship status is sucessful...")
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn 
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync
		Wait(MID_WAIT)
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn 
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync
	
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn 
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync
		Wait(4)
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn 
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync
	Wait(15)
	Set objFSO = createobject("Scripting.filesystemobject")
	set objFile = objFSO.OpenTextFile (StrFrameWorkFolder&"\Resources\Log.txt")
	strData = objFile.ReadAll
	wait(MIN_WAIT)	
		If Instr(strData, "Delivery") > 0  AND  Instr(strData,strDeliveryNo) > 0 Then
			Call rptWriteReport("PASSWITHSCREENSHOT", "Check shipment status","Shipment status is sucessful..."&strDeliveryNo)
			fnReportStepALM "Delivery success Messsage","Passed","Delivery shipped succesfully message","Delivery shipped succesfully message should be displayed","Delivery shipped succesfully message is displayed"&strDeliveryNo
		Else
			rptWriteReport "Fail", "Checking for delivery success message" , "Delivery shipped succesfully message is not displayed.."&strDeliveryNo
			fnReportStepALM "Delivery success Messsage","Failed","Delivery shipped succesfully message","Delivery shipped succesfully message should be displayed","Delivery shipped succesfully message is not displayed.."&strDeliveryNo
		End If			
End Function


'******************************************************************************************************************************************************************************************************************************************
'	Sub Name		 					:					fnConfirmShipCPU
'	Objective							:					fnConfirmShipCPU
'	Input Parameters					:					
'	Output Parameters					:					NIL
'	Date Created						:					29-Mar-2017
'	QTP Version							:					UFT 12.0
'	QC Version							:					
'	Pre-requisites						:					NILL  
'	Created By							:					Balaji Veeravalli
'	Modification Date					:	
'******************************************************************************************************************************************************************************************************************************************
  Public Function fnConfirmShipCPU()
		Wait(MIN_WAIT)
		strDeliveryNo=fnReadDeliveryNumber("GSOCPU")
		strItemNo=fnReadItemNumber("GSOCPU")
		Wait(MIN_WAIT)
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type strDeliveryNo
		Wait(MIN_WAIT)
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn 
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync
		Wait(MIN_WAIT)
	'Item Number
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type strItemNo
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn 
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync
		Wait(MIN_WAIT)
		Call rptWriteReport("PASSWITHSCREENSHOT", "Check shipment status","Drop status is sucessful...")
	''''Find Lines
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn 
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync
			
	'''Done
'	.....Ship Confirm
		Wait(MIN_WAIT)
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type strItemNo 
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync	
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn 
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync
		Wait(MIN_WAIT)
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn 
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync
	
	'''''''''''''''''
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn 
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync
		Call rptWriteReport("PASSWITHSCREENSHOT", "Check shipment status","Ship status is sucessful...")
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn 
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync
		Wait(MID_WAIT)
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn 
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync
	
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn 
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync
		Wait(4)
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn 
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync
	Wait(15)
	Set objFSO = createobject("Scripting.filesystemobject")
	set objFile = objFSO.OpenTextFile (StrFrameWorkFolder&"\Resources\Log.txt")
	strData = objFile.ReadAll
	wait(MIN_WAIT)	
		If Instr(strData, "Delivery") > 0  AND  Instr(strData,strDeliveryNo) > 0 Then
			Call rptWriteReport("PASSWITHSCREENSHOT", "Check shipment status","Shipment status is sucessful..."&strDeliveryNo)
			fnReportStepALM "Delivery success Messsage","Passed","Delivery shipped succesfully message","Delivery shipped succesfully message should be displayed","Delivery shipped succesfully message is displayed"&strDeliveryNo
		Else
			rptWriteReport "Fail", "Checking for delivery success message" , "Delivery shipped succesfully message is not displayed.."&strDeliveryNo
			fnReportStepALM "Delivery success Messsage","Failed","Delivery shipped succesfully message","Delivery shipped succesfully message should be displayed","Delivery shipped succesfully message is not displayed.."&strDeliveryNo
		End If			
End Function
'******************************************************************************************************************************************************************************************************************************************
'	Sub Name		 					:					fnConfirmShipTL
'	Objective							:					ConfirmShip for TL
'	Input Parameters					:					
'	Output Parameters					:					NIL
'	Date Created						:					31-Mar-2017
'	QTP Version							:					UFT 12.0
'	QC Version							:					
'	Pre-requisites						:					NILL  
'	Created By							:					Balaji Veeravalli
'	Modification Date					:	
'******************************************************************************************************************************************************************************************************************************************
  Public Function fnConfirmShipTL()
		Wait(MIN_WAIT)
		strDeliveryNo=fnReadDeliveryNumber("GSOTL")
		strItemNo=fnReadItemNumber("GSOTL")
		Wait(MIN_WAIT)
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type strDeliveryNo
		Wait(MIN_WAIT)
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn 
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync
		Wait(MIN_WAIT)
	'Item Number
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type strItemNo
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn 
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync
		Wait(MIN_WAIT)
		Call rptWriteReport("PASSWITHSCREENSHOT", "Check shipment status","Drop status is sucessful...")
	''''Find Lines
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn 
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync
			
	'''Done
'	.....Ship Confirm
		Wait(MIN_WAIT)
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type strItemNo 
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync	
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn 
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync
		Wait(MIN_WAIT)
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn 
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync
	
	'''''''''''''''''
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn 
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync
		Call rptWriteReport("PASSWITHSCREENSHOT", "Check shipment status","Ship status is sucessful...")
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn 
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync
		Wait(MID_WAIT)
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn 
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync
	
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn 
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync
		Wait(4)
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn 
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync
	Wait(15)
	Set objFSO = createobject("Scripting.filesystemobject")
	set objFile = objFSO.OpenTextFile (StrFrameWorkFolder&"\Resources\Log.txt")
	strData = objFile.ReadAll
	wait(MIN_WAIT)	
		If Instr(strData, "Delivery") > 0  AND  Instr(strData,strDeliveryNo) > 0 Then
			Call rptWriteReport("PASSWITHSCREENSHOT", "Check shipment status","Shipment status is sucessful..."&strDeliveryNo)
			fnReportStepALM "Delivery success Messsage","Passed","Delivery shipped succesfully message","Delivery shipped succesfully message should be displayed","Delivery shipped succesfully message is displayed"&strDeliveryNo
		Else
			rptWriteReport "Fail", "Checking for delivery success message" , "Delivery shipped succesfully message is not displayed.."&strDeliveryNo
			fnReportStepALM "Delivery success Messsage","Failed","Delivery shipped succesfully message","Delivery shipped succesfully message should be displayed","Delivery shipped succesfully message is not displayed.."&strDeliveryNo
		End If			
End Function

'******************************************************************************************************************************************************************************************************************************************
'	Sub Name		 					:					fnConfirmShipGenericSales
'	Objective							:					fnConfirmShipGenericSales
'	Input Parameters					:					
'	Output Parameters					:					NIL
'	Date Created						:					13-Mar-2017
'	QTP Version							:					UFT 12.0
'	QC Version							:					
'	Pre-requisites						:					NILL  
'	Created By							:					Balaji Veeravalli
'	Modification Date					:	
'******************************************************************************************************************************************************************************************************************************************
  Public Function fnConfirmShipGenericSales()
 	Wait(MIN_WAIT)
		strDeliveryNo=fnReadDeliveryNumber("Generic Sales Order")
		WAIT 3
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type strDeliveryNo
		Wait(MIN_WAIT)
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn 
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync
		WAIT 3
	strItemNo=fnReadItemNumber("Generic Sales Order")
	Wait(MIN_WAIT)
'	strItemNo=fnReadDeliveryNumber("DC Direct")
	'Item Number
	Wait(MIN_WAIT)
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type strItemNo
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn 
		Wait(MIN_WAIT)
		Call rptWriteReport("PASSWITHSCREENSHOT", "Check shipment status","Drop status is sucessful...")
	''''Find Lines
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn 
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync
		Wait(MIN_WAIT)
	'''Done
'	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn 
'	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync
'	.....Ship Confirm
		Wait(MIN_WAIT)
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type strItemNo 
		Wait(MIN_WAIT)
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn 
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync
		Wait(MIN_WAIT)
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn 
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync
		Wait 4
	'''''''''''''''''
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn 
		Wait(MIN_WAIT)
		Call rptWriteReport("PASSWITHSCREENSHOT", "Check shipment status","Drop status is sucessful...")
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn 
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync
		Wait(MID_WAIT)
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn 
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync
		Wait(MIN_WAIT)
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn 
		Wait(MIN_WAIT)
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn 
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync
	Wait(15)
	Set objFSO = createobject("Scripting.filesystemobject")
	set objFile = objFSO.OpenTextFile (StrFrameWorkFolder&"\Resources\Log.txt")
	strData = objFile.ReadAll		
	wait(MIN_WAIT)
		If Instr(strData, "Delivery") > 0  AND  Instr(strData,strDeliveryNo) > 0 Then
			Call rptWriteReport("PASSWITHSCREENSHOT", "Check shipment status","Shipment status is sucessful..."&strDeliveryNo)
			fnReportStepALM "Delivery success Messsage","Passed","Delivery shipped succesfully message","Delivery shipped succesfully message should be displayed","Delivery shipped succesfully message is displayed"&strDeliveryNo
		Else
			rptWriteReport "Fail", "Checking for delivery success message" , "Delivery shipped succesfully message is not displayed.."&strDeliveryNo
			fnReportStepALM "Delivery success Messsage","Failed","Delivery shipped succesfully message","Delivery shipped succesfully message should be displayed","Delivery shipped succesfully message is not displayed.."&strDeliveryNo
		End If			
End Function

'******************************************************************************************************************************************************************************************************************************************
'	Sub Name		 					:					fnPickConfirmMobileInterface
'	Objective							:					Pick Confirm from Mobile Interface - quick pick subinventory
'	Input Parameters					:					iOrganization_Number, iProduct_Number, iQuantity, iTransactionNumber, iToLOC, iToSub
'	Output Parameters					:					NIL
'	Date Created						:					07-Mar-2017
'	QTP Version							:					UFT 12.0
'	QC Version							:					
'	Pre-requisites						:					NILL  
'	Created By							:					Gallop
'	Modification Date					:	
'******************************************************************************************************************************************************************************************************************************************
Public Function fnPickConfirmMobileInterface(iOrganization_Number, iProduct_Number, iQuantity, iTransactionNumber, sSubInventory, sLocator)
			'Type 1 for ATDI Whse Ops Director 
			'TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn 
			'Verify ATDI Whse Ops Direc Screen
			If TeWindow("TeWindow").TeTextScreen("TeTextScreen").Exist(10) Then
				Call fnReportStepALM("ATDI Whse Ops Direc", "Passed", "ATDI Whse Ops Direc screen verification", "ATDI Whse Ops Direc screen should be displayed","ATDI Whse Ops Direc screen is displayed")
				Call rptWriteReport("PASSWITHSCREENSHOT", "ATDI Whse Ops Direc screen verification", "ATDI Whse Ops Direc screen is displayed")
			Else
				Call fnReportStepALM("ATDI Whse Ops Direc", "Failed", "ATDI Whse Ops Direc screen verification", "ATDI Whse Ops Direc Screen should be displayed","ATDI Whse Ops Direc screen is not displayed")
				Call rptWriteReport("Fail", "Receive screen verification", "Receive screen is not displayed")
			End If 	
			'Type 4 for Pick
			TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type 4
			TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn 
			Wait(MIN_WAIT)
			'Verify Organization screen
			If TeWindow("TeWindow").TeTextScreen("TeTextScreen").Exist(10) Then
				Call fnReportStepALM("Organization", "Passed", "Organization screen verification", "Should Display Organization screen","Organization screen is displayed")
				Call rptWriteReport("PASSWITHSCREENSHOT", "Organization screen verification", "Organization screen is displayed")
			Else
				Call fnReportStepALM("Organizationr", "Failed", "Organization screen verification", "Should Display Organization Screen","Organization screen is not displayed")
				Call rptWriteReport("Fail", "Organization screen verification", "Organization screen is not displayed")
			End If 
			'Enter Organization number
			TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type iOrganization_Number
			TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
			Wait(MIN_WAIT)			
			'Verify Eqp/Sub screen
			If TeWindow("TeWindow").TeTextScreen("TeTextScreen").Exist(10) Then
				Call fnReportStepALM("Eqp/Sub", "Passed", "Eqp/Sub screen verification", "Should Display Eqp/Sub screen","Eqp/Sub screen is displayed")
				Call rptWriteReport("PASSWITHSCREENSHOT", "Eqp/Sub screen verification", "Eqp/Sub screen is displayed")
			Else
				Call fnReportStepALM("Eqp/Sub", "Failed", "Eqp/Sub screen verification", "Should Display Eqp/Sub Screen","Eqp/Sub screen is not displayed")
				Call rptWriteReport("Fail", "Eqp/Sub screen verification", "Eqp/Sub screen is not displayed")
			End If 			
			TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micDwn
			TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
			Wait(MIN_WAIT)
			TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micDwn
			TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
			Wait(MIN_WAIT)
			'Type 3 Manual Pick
			TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type 3
			TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
			Wait(MIN_WAIT)	
			'Verify PICK Screen
			If TeWindow("TeWindow").TeTextScreen("TeTextScreen").Exist(10) Then
				Call fnReportStepALM("PICK", "Passed", "PICK screen verification", "Should Display PICK screen","PICK screen is displayed")
				Call rptWriteReport("PASSWITHSCREENSHOT", "PICK screen verification", "PICK screen is displayed")
			Else
				Call fnReportStepALM("PICK", "Failed", "PICK screen verification", "Should Display PICK Screen","PICK screen is not displayed")
				Call rptWriteReport("Fail", "PICK screen verification", "PICK screen is not displayed")
			End If
			
			'Enter Transaction Number 
			TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type iTransactionNumber
			TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
			Wait(MID_WAIT)
			'Verify Load Screen
			If TeWindow("TeWindow").TeTextScreen("TeTextScreen").Exist(10) Then
				Call fnReportStepALM("Load", "Passed", "Load screen verification", "Should Display Load screen","Load screen is displayed")
				Call rptWriteReport("PASSWITHSCREENSHOT", "Load screen verification", "Load screen is displayed")
			Else
				Call fnReportStepALM("Load", "Failed", "Load screen verification", "Should Display Load Screen","Load screen is not displayed")
				Call rptWriteReport("Fail", "Load screen verification", "Load screen is not displayed")
			End If
			Set objFSO = createobject("Scripting.filesystemobject")
			Set objFile = objFSO.OpenTextFile (StrFrameWorkFolder&"\Resources\Log.txt")
			strData = objFile.ReadAll
			strSub = Split(strData, "Sub                 :")
			strLoc = Split(strData, "Loc                 :")
			iArrQuantity= Split(strData, "Req Qty             :")
			arraySub= Split(strSub(1), "Confirm             :")
			arrayLoc= Split(strLoc(1), "Confirm             :")
			iReqQuantity= Split(iArrQuantity(1), "Confirm             :")
			Set re = New RegExp
			re.Pattern = "\s+"
			re.Global = True
			strSub = Trim(re.Replace(arraySub(0), " "))
			strLOC= Trim(re.Replace(arrayLoc(0), " "))
			iRequiredQty= Trim(re.Replace(iReqQuantity(0), " "))
			objFile.Close
			Set objFSO= nothing 
			'Enter SubInventory
			TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type strSub
			TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
			Wait(MIN_WAIT)
			'Enter LOC
			TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type strLOC
			TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
			Wait(MIN_WAIT)
			TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type iProduct_Number
			TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
			Wait(MIN_WAIT)
			TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micDwn
			TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
			Wait(MIN_WAIT)
			'Quantity
			TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type iRequiredQty
			TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
			Wait(MIN_WAIT)
			'Press Ctrl+G to confirm LPN
			TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micCtrlDwn+ "G" + micCtrlUp
			TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
			Wait(MIN_WAIT)
			'Load and Drop
			TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micDwn
			TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
			Wait(MID_WAIT)
			Set objFSO = createobject("Scripting.filesystemobject")
			Set objFile = objFSO.OpenTextFile (StrFrameWorkFolder&"\Resources\Log.txt")
			strData = objFile.ReadAll
			strToSub = Split(strData, "To Sub    :")
			strToLoc = Split(strData, "To Loc    :")
			arrayToSub= Split(strToSub(1), "Confirm   >[7m")
			arrayToLoc= Split(strToLoc(1), "Confirm   ][7m")
			Set re = New RegExp
			re.Pattern = "\s+"
			re.Global = True
			strToSub = Trim(re.Replace(arrayToSub(0), " "))
			strToLoc= Trim(re.Replace(arrayToLoc(0), " "))
			'Enter SubInventory
			TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type strToSub
			TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
			Wait(MIN_WAIT)
			'Enter LOC
			TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type strToLoc
			TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
			Wait(MIN_WAIT)
			TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
			Wait(MID_WAIT)
			'Verify Task Complete  Screen
			If TeWindow("TeWindow").TeTextScreen("TeTextScreen").Exist(10) Then
				Call fnReportStepALM("Task Complete", "Passed", "Task Complete screen verification", "Should Display Task Complete screen","Task Complete screen is displayed")
				Call rptWriteReport("PASSWITHSCREENSHOT", "Task Complete screen verification", "Task Complete screen is displayed")
			Else
				Call fnReportStepALM("Task Complete", "Failed", "Task Complete screen verification", "Should Display Task Complete Screen","Task Complete screen is not displayed")
				Call rptWriteReport("Fail", "Task Complete screen verification", "Task Complete screen is not displayed")
			End If
			Wait(MIN_WAIT)
			objFile.Close
			Set objFSO= nothing 
End Function
'************************************************************************************************************************************************
'	Function Name	 	 :		fnOpenPuttyfnl
'	Objective			 :		Used to open Putty utility and set the configuration
'	Input Parameters	 :		NIL
'	Output Parameters	 :		NIL
'	Date Created		 :		4-April-2017
'	QTP Version			 :		11.0
'	QC Version			 :		QC 11.53
'	Pre-requisites		 :		NIL  
'	Created By			 :								
'	Modification Date	 :		   
'************************************************************************************************************************************************
Public Function fnOpenPuttyfnlC(strApp)
	If Window("PuTTY Configuration").Exist(2) Then
		Window("PuTTY Configuration").Close
	ElseIf TeWindow("TeWindow").Exist(2) Then
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micAltDwn + micF4 + micAltUp
			If Dialog("PuTTY Exit Confirmation").Exist Then
				Dialog("PuTTY Exit Confirmation").WinButton("OK").Click
			End If
	End If
	Systemutil.Run (StrFrameWorkFolder&"\Resources\putty.exe")
	Wait(MID_WAIT)
		call fnSynUntilObjExists(Window("PuTTY Configuration").WinEdit("txt_HostName"),10)	
		If Ucase(strApp) = "SSH" Then
			Window("PuTTY Configuration").WinEdit("txt_HostName").Set "ZQA.test.icd"
			Window("PuTTY Configuration").WinRadioButton("rad_SSH").Set
		ElseIf Ucase(strApp) = "TELNET" Then
			Window("PuTTY Configuration").WinEdit("txt_HostName").Set "WMSQA.test.icd"
			Window("PuTTY Configuration").WinRadioButton("rad_Telnet").Set
		End If
	Wait(2)
	Window("PuTTY Configuration").WinTreeView("tvw_Category:").Select 1
	Window("PuTTY Configuration").WinRadioButton("rad_AllSessionOutput").Set
	Set objFSO = createobject("Scripting.filesystemobject")
	Wait(2)
	If objFSO.FileExists(StrFrameWorkFolder&"\Resources\Log.txt")Then
	   objFSO.DeleteFile(StrFrameWorkFolder&"\Resources\Log.txt")
	   objFSO.CreateTextFile(StrFrameWorkFolder&"\Resources\Log.txt")
	End If
	Wait(2)
	Window("PuTTY Configuration").WinEdit("txt_LogFileName:").Set StrFrameWorkFolder&"\Resources\Log.txt"
	Window("PuTTY Configuration").WinTreeView("tvw_Category:").Select 3
	Window("PuTTY Configuration").WinRadioButton("rad_VT100+").Set
	Window("PuTTY Configuration").WinButton("btn_Open").Click
	Wait(2)
	If Dialog("PuTTY Log to File").WinButton("btn_Yes").Exist(2) Then
		Dialog("PuTTY Log to File").WinButton("btn_Yes").Highlight
		Dialog("PuTTY Log to File").WinButton("btn_Yes").Click
	End If
	Wait(2)
	Call fnSynUntilObjExists(TeWindow("TeWindow"),10)
	If TeWindow("TeWindow").Exist(1) Then
		rptWriteReport "Pass", "Checking for emulator" , "Emulator window is displayed"
		fnReportStepALM "Emulator window","Passed","Emulator window display","Emulator window should be displayed","Emulator window is displayed"
	Else
		rptWriteReport "Fail", "Checking for SystemZ emulator" , "SystemZ window is not displayed"
		fnReportStepALM "Systemz window","Failed","SystemZ window display","Systemz window should be displayed","Systemz window is not displayed"
		ExitAction()
	End If			
End Function
'************************************************************************************************************************************************
'	Function Name	 	 :		fnTelnetLoginlstC
'	Objective			 :		Used to login telnet
'	Input Parameters	 :		NIL
'	Output Parameters	 :		NIL
'	Date Created		 :		04-April-2017
'	QTP Version			 :		11.0
'	QC Version			 :		QC 11.53
'	Pre-requisites		 :		NIL  
'	Created By			 :								
'	Modification Date	 :		   
'************************************************************************************************************************************************
Public Function fnTelnetLoginlstC(sUserName, sPassword)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type "2"
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
		Call fnSynUntilFieldExists("User Name",4)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type sUserName
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
		Wait(3)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type sPassword
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
		Call fnSynUntilFieldExists("Choose Responsibility",4)
End Function

'******************************************************************************************************************************************************************************************************************************************
'	Sub Name		 					:					fnShipConfirmThroughMobileInterface
'	Objective							:					Ship Confirm through Mobile Deliver interface delivery screen
'	Input Parameters					:					iOrganization_Number, iDelivery_Number, iProduct_Number
'	Output Parameters					:					NIL
'	Date Created						:					07-Mar-2017
'	QTP Version							:					UFT 12.0
'	QC Version							:					
'	Pre-requisites						:					NILL  
'	Created By							:					Gallop
'	Modification Date					:	
'******************************************************************************************************************************************************************************************************************************************

Public Function fnShipConfirmThroughMobileInterface(iOrganization_Number, iDelivery_Number, iProduct_Number)
	fnSynUntilFieldExists "5 <Ship", 10
	'Type 5 for Ship
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type 5
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn	
	fnSynUntilFieldExists "Select Organization", 10
	Set objFSO = createobject("Scripting.filesystemobject")
	set objFile = objFSO.OpenTextFile (StrFrameWorkFolder&"\Resources\Log.txt")
	strSession = objFile.ReadAll
	'Verify Organization screen
	If Instr(strSession, "Select Organization")>0 Then
		Call fnReportStepALM("Organization", "Passed", "Organization screen verification", "Should Display Organization screen","Organization screen is displayed")
		Call rptWriteReport("PASSWITHSCREENSHOT", "Organization screen verification", "Organization screen is displayed")
	Else
		Call fnReportStepALM("Organizationr", "Failed", "Organization screen verification", "Should Display Organization Screen","Organization screen is not displayed")
		Call rptWriteReport("Fail", "Organization screen verification", "Organization screen is not displayed")
	End If 
	objFile.Close
	'Enter Organization number
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type iOrganization_Number
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	fnSynUntilFieldExists "Ship Confirm", 20	
	set objFile = objFSO.OpenTextFile (StrFrameWorkFolder&"\Resources\Log.txt")
	strSession = objFile.ReadAll	
	'Verify Ship Confirm screen
	If Instr(strSession, "Ship Confirm")>0 Then
		Call fnReportStepALM("Ship Confirm", "Passed", "Ship Confirm screen verification", "Should Display Ship Confirm screen","Ship Confirm screen is displayed")
		Call rptWriteReport("PASSWITHSCREENSHOT", "Ship Confirm screen verification", "Ship Confirm screen is displayed")
	Else
		Call fnReportStepALM("Ship Confirm", "Failed", "Ship Confirm screen verification", "Should Display Ship Confirm Screen","Ship Confirm screen is not displayed")
		Call rptWriteReport("Fail", "Ship Confirm screen verification", "Ship Confirm screen is not displayed")
	End If 
	objFile.Close
	'Enter Delivery# 
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type iDelivery_Number
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	'Enter Item#
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type iProduct_Number
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	'Click Find Lines
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	fnSynUntilFieldExists "Deliv Num:", 20
	set objFile = objFSO.OpenTextFile (StrFrameWorkFolder&"\Resources\Log.txt")
	strSession = objFile.ReadAll	
	If Instr(strSession, "Deliv Num:")>0 Then
		Call fnReportStepALM("Find Lines", "Passed", "Find Lines screen verification", "Should display Find Lines screen","Find Lines screen is displayed")
		Call rptWriteReport("PASSWITHSCREENSHOT", "Find Lines screen verification" ,"Find Lines screen is displayed")
	Else 
		Call fnReportStepALM("Find Lines", "Failed", "Find Lines screen verification", "Should display Find Lines screen","Find Lines screen is not displayed")
		Call rptWriteReport("Fail", "Find Lines screen verification" ,"Find Lines screen is not displayed")
	End If
	objFile.Close
	'Confirm Item#
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type iProduct_Number
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	fnSynUntilFieldExists "Confirm", 20
	'Down to Qty
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micDwn
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	fnSynUntilFieldExists "Confirm", 20
	'Done
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	fnSynUntilFieldExists "Weight     :", 30
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micDwn
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	fnSynUntilFieldExists "Ship Method>", 30
	'Done Again
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	fnSynUntilFieldExists "Delivery Ship", 50
	set objFile = objFSO.OpenTextFile (StrFrameWorkFolder&"\Resources\Log.txt")
	strSession = objFile.ReadAll
	''Verify the Delivery# confirmation message 
	If Instr(strSession, "has been submitted")>0 Then
		Call fnReportStepALM("Delivery##", "Passed", "Delivery## confirmation screen verification", "Should display Delivery## confirmation message","Delivery: "&iDeliveryNumber&" has been submitted")
		Call rptWriteReport("PASSWITHSCREENSHOT", "Delivery## confirmation screen verification" , "Delivery: "&iDeliveryNumber&" has been submitted")
	Else 
		Call fnReportStepALM("Delivery##", "Failed", "Delivery## confirmation screen verification", "Should display Delivery## confirmation","Delivery: "&iDeliveryNumber&" has been submitted")
		Call rptWriteReport("PASSWITHSCREENSHOT", "Delivery## confirmation screen verification" , "Delivery: "&iDeliveryNumber&" has been submitted")
	End If	
	objFile.Close
	Set objFSO= Nothing
End Function



Public Function fnCreateGenericSalesOrder(iCustomer_Number, iProduct_Number, iQuantity)
	'Enter Customer Number
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type iCustomer_Number	
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	Wait(MIN_WAIT)
	'TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	If TeWindow("TeWindow").Exist(2) Then
		Call fnReportStepALM("Customer Number", "Passed", "Customer Number verification", "Customer Number should be entered","Customer Number is entered "&iCustomer_Number)
		Call rptWriteReport("PASSWITHSCREENSHOT", "Customer Number verification", "Customer Number is entered "&iCustomer_Number)
	Else 
		Call fnReportStepALM("Customer Number", "Failed", "Customer Number verification", "Customer Number should be entered","Customer Number is not entered "&iCustomer_Number)
		Call rptWriteReport("Fail", "Customer Number verification", "Customer Number is not entered "&iCustomer_Number)
	End If 	
	'Enter Product# 		
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type iProduct_Number
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn	
	Wait(MIN_WAIT)
	If TeWindow("TeWindow").Exist(2) Then
		Call fnReportStepALM("Product Number", "Passed", "Product Number verification", "Product Number should be entered","Product Number is entered "&iProduct_Number)
		Call rptWriteReport("PASSWITHSCREENSHOT", "Product Number verification", "Product Number is entered "&iProduct_Number)
	Else 
		Call fnReportStepALM("Product Number", "Failed", "Product Number verification", "Product Number should be entered","Product Number is not entered "&iProduct_Number)
		Call rptWriteReport("Fail", "Product Number verification", "Product Number is not entered "&iProduct_Number)
	End If 	
	'Enter Quantity 
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type iQuantity
	Wait(MIN_WAIT)
	If TeWindow("TeWindow").Exist(2) Then
		Call fnReportStepALM("Quantity", "Passed", "Quantity verification", "Quantity should be entered","Quantity is entered "&iQuantity)
		Call rptWriteReport("PASSWITHSCREENSHOT", "Quantity verification", "Quantity is entered "&iQuantity)
	Else 
		Call fnReportStepALM("Quantityr", "Failed", "Quantity verification", "Quantity should be entered","Quantity is not entered "&iQuantity)
		Call rptWriteReport("Fail", "Quantity verification", "Quantity is not entered "&iQuantity)
	End If 
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	Wait(MIN_WAIT)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type "N"
	Wait(MIN_WAIT)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type "Y"
	Wait(MIN_WAIT)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type "R"
	Wait(MIN_WAIT)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micUp
	Wait(MIN_WAIT)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micF1
	Wait(MIN_WAIT)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	Wait(MAX_WAIT)
  	Call fnSynUntilFieldExists(Trim("REGULAR"),90)
  	Wait(MAX_WAIT)
End Function

'************************************************************************************************************************************************
'	Function Name	 	 :		fnGetOrderNumberRMA
'	Objective			 :		Used to get RMA from log file
'	Input Parameters	 :		NIL
'	Output Parameters	 :		NIL
'	Date Created		 :		10-Mar-2017
'	QTP Version			 :		11.0
'	QC Version			 :		QC 11.53
'	Pre-requisites		 :		NIL  
'	Created By			 :		Balaji Veeravalli					
'	Modification Date	 :		   
'************************************************************************************************************************************************
Public Function fnGetOrderNumberRMA()
	TeWindow("TeWindow").Activate
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micEsc
	Wait(MIN_WAIT)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micAltDwn + micF4 + micAltUp
		If Dialog("PuTTY Exit Confirmation").Exist(2) Then
			Dialog("PuTTY Exit Confirmation").WinButton("OK").Click
		End If
			Set objFSO = createobject("Scripting.filesystemobject")
			set objFile = objFSO.OpenTextFile (StrFrameWorkFolder&"\Resources\Log.txt")
			strData = objFile.ReadAll
			Wait(MIN_WAIT)
			'	strOrderString = Split(strData, "RETURN")
			'	Wait(MIN_WAIT)
			'	strOrderNumString = Split(strOrderString(2), "BOOKED")
			'	strOrderNo=Split(strOrderNumString(1),"TOGGLE ORDER/RSVD[7;3H")
		strOrderString = Split(strData, "ORDER/RSVD")		
		strOrderStrings=Split(strOrderString(1), "H")
		strOrderNo = Mid(Trim(strOrderStrings(1)),1, 9)
			Wait(MIN_WAIT)
			fnGetOrderNumberRMA = trim(strOrderNo)
		If fnGetOrderNumberRMA <> "" Then
			Call rptWriteReport("PASSWITHSCREENSHOT", "Checking for order number creation" , "Order number "&fnGetOrderNumberRMA&" created")
			fnReportStepALM "Order Creation","Passed","Order number creation from SystemZ","Order Number should be created","Order Number "&fnGetOrderNumberRMA&" is created"
		Else
			rptWriteReport "Fail", "Checking for order number creation" , "Order number "&fnGetOrderNumberRMA&" not created"
			fnReportStepALM "Order Creation","Failed","Order number creation from SystemZ","Order Number should be created","Order Number is not created"		
		End If	
End Function

'******************************************************************************************************************************************************************************************************************************************
'	Sub Name		 					:					fnGetLPNForRMAOrderNumber
'	Objective							:					Receive against a manual ASN
'	Input Parameters					:					iOrganization_Number, iPO_Number, iProduct_Number
'	Output Parameters					:					NIL
'	Date Created						:					07-Mar-2017
'	QTP Version							:					UFT 12.0
'	QC Version							:					
'	Pre-requisites						:					NILL  
'	Created By							:					Gallop
'	Modification Date					:	
'******************************************************************************************************************************************************************************************************************************************
Public Function fnGetLPNForRMAOrderNumber(iOrganization_Number, iOrdernumber, iItemnumber, iQuantity)
	Wait(MIN_WAIT)
	If Ucase(Environment("CountryUS")) = "YES" and  Ucase(Environment("CountryCA")) = "NO" Then
		 Wait(MIN_WAIT)
		 TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type 1
		 TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
		 Wait(MIN_WAIT)
		 ''Ápply shot cut  F2+Y+ALT+ENTER
	     TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micF2 
	     Wait(1)
	     TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type "Y"
	     Wait(1)
	     TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micAltDwn+micReturn+micAltUp
		 Wait(MIN_WAIT)
		 TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micDwn	
		 Wait(MIN_WAIT)
		 TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn 
		 Wait(MIN_WAIT)
		 TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn 
	ElseIf Ucase(Environment("CountryUS")) = "NO" and  Ucase(Environment("CountryCA")) = "YES" Then
		 Wait(MIN_WAIT)
		 TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type 2
		 TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
		 Wait(MIN_WAIT)
		 ''Ápply shot cut  F2+Y+ALT+ENTER
	     TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micF2 
	     Wait(1)
	     TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type "Y"
	     Wait(1)
	     TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micAltDwn+micReturn+micAltUp
		 Wait(MIN_WAIT)
		 TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micDwn 
		 Wait(MIN_WAIT)
		 TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micUp
		 Wait(MIN_WAIT)
		 TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn 
		 Wait(MIN_WAIT)
		 TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micDwn
		 Wait(MIN_WAIT)
		 TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn  
		 Wait(MIN_WAIT)
		 TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micDwn
		 Wait(MIN_WAIT)
		 TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micDwn
		 Wait(MIN_WAIT)
		 TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn 		 
	End If 
'	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type "N"
'	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	'Press 2 For RMA  
'	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type 2	
'	Wait(MIN_WAIT)
'	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn 
	Wait(MIN_WAIT)
	If TeWindow("TeWindow").TeTextScreen("TeTextScreen").Exist(10) Then
		Call fnReportStepALM("Organization", "Passed", "Organization screen verification", "Should Display Organization screen","Organization screen is displayed")
		Call rptWriteReport("PASSWITHSCREENSHOT", "Organization screen verification", "Organization screen is displayed")
	Else
		Call fnReportStepALM("Organizationr", "Failed", "Organization screen verification", "Should Display Organization Screen","Organization screen is not displayed")
		Call rptWriteReport("Fail", "Organization screen verification", "Organization screen is not displayed")
	End If 
	'Enter Organization number
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type iOrganization_Number
	Wait(MIN_WAIT)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	Wait(MIN_WAIT)
	'Verify Receipt Screen
	If TeWindow("TeWindow").TeTextScreen("TeTextScreen").Exist(10) Then
		Call fnReportStepALM("Receipt", "Passed", "Receipt screen verification", "Should Display Receipt screen","Receipt screen is displayed")
		Call rptWriteReport("PASSWITHSCREENSHOT", "Receipt screen verification", "Receipt screen is displayed")
	Else
		Call fnReportStepALM("Receipt", "Failed", "Receipt screen verification", "Should Display Receipt Screen","Receipt screen is not displayed")
		Call rptWriteReport("Fail", "Receipt screen verification", "Receipt screen is not displayed")
	End If 
	'Enter ASN number
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type iOrdernumber
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	Wait(MAX_WAIT)
	'Enter Item# 
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type iItemnumber
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	Wait(MAX_WAIT)
'	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micDwn
'	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	'Verify Receipt Screen
	If TeWindow("TeWindow").TeTextScreen("TeTextScreen").Exist(10) Then
		Call fnReportStepALM("Receipt", "Passed", "Receipt screen verification", "Should Display Receipt screen","Receipt screen is displayed")
		Call rptWriteReport("PASSWITHSCREENSHOT", "Receipt screen verification", "Receipt screen is displayed")
	Else
		Call fnReportStepALM("Receipt", "Failed", "Receipt screen verification", "Should Display Receipt Screen","Receipt screen is not displayed")
		Call rptWriteReport("Fail", "Receipt screen verification", "Receipt screen is not displayed")
	End If
	'Press Ctrl+G to auto-generate LPN
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micCtrlDwn+ "G" + micCtrlUp
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	Wait(MIN_WAIT)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	Wait(MIN_WAIT)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micCtrlDwn+ "L" + micCtrlUp
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	Wait(MIN_WAIT)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micCtrlDwn+ "L" + micCtrlUp
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	Wait(MIN_WAIT)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type iQuantity
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	Wait(MIN_WAIT)
	'Verify LPN, SubInventory,Location& Quantity
	If TeWindow("TeWindow").TeTextScreen("TeTextScreen").Exist(10) Then
		Call fnReportStepALM("LPN, SubInventory, Location& Quantity", "Passed", "LPN, SubInventory,Location& Quantity verification", "Should be able to enter the Subinventory, Locator and Item Quantity", "Entered the Subinventory, Locator and Item Quantity fields")
		Call rptWriteReport("PASSWITHSCREENSHOT", "LPN, SubInventory,Location& Quantity verification", "Entered the Subinventory, Locator and Item Quantity fields")
	Else
		Call fnReportStepALM("LPN, SubInventory, Location& Quantity", "Failed", "LPN, SubInventory,Location& Quantity verification", "Should be able to enter the Subinventory, Locator and Item Quantity", "Not Entered the Subinventory, Locator and Item Quantity")
		Call rptWriteReport("Fail", "LPN, SubInventory,Location& Quantity verification", "Not Entered the Subinventory, Locator and Item Quantity")
	End If
	Wait(MIN_WAIT)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micDwn
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
'	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micCtrlDwn+ "L" + micCtrlUp
'	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
'	Wait(MIN_WAIT)
'	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micCtrlDwn+ "L" + micCtrlUp
'	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	Wait(MAX_WAIT)
	'Verify Receipt Information
	If TeWindow("TeWindow").TeTextScreen("TeTextScreen").Exist(10) Then
		Call fnReportStepALM("Receipt Information", "Passed", "Receipt Information verification", "Should display Receipt Information", "Receipt Information screen is displayed")
		Call rptWriteReport("PASSWITHSCREENSHOT", "Receipt Information verification", "Receipt Information screen is displayed")
	Else
		Call fnReportStepALM("Receipt Information", "Failed", "Receipt Information verification", "Should display Receipt Information", "Receipt Information screen is not displayed")
		Call rptWriteReport("Fail", "Receipt Information verification", "Receipt Information screen is not displayed")
	End If
	Wait(MIN_WAIT)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micDwn
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	Wait(MIN_WAIT)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micDwn
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	Wait(MIN_WAIT)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micDwn
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	
'	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
'	Wait(MIN_WAIT)
'	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
'	Wait(MIN_WAIT)
'	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
'	Wait(MIN_WAIT)
'	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
'	Wait(MIN_WAIT)
'	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
'	Wait(MIN_WAIT)
'	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	Wait(MID_WAIT)
	'Verify Txn Success
	If TeWindow("TeWindow").TeTextScreen("TeTextScreen").Exist(10) Then
		Call fnReportStepALM("Txn Success", "Passed", "Txn Success verification", "Should display Txn Success message", "Txn Success is displayed")
		Call rptWriteReport("PASSWITHSCREENSHOT", "Txn Success verification", "Txn Success is displayed")
	Else
		Call fnReportStepALM("Txn Success", "Failed", "Txn Success verification", "Should display Txn Success message", "Txn Success is not displayed")
		Call rptWriteReport("Fail", "Txn Success verification", "Txn Success is not displayed")
	End If
	
End Function

'******************************************************************************************************************************************************************************************************************************************
'	Sub Name		 					:					fnGetISOOrderNumber
'	Objective							:					Used to get the ISO Order Number
'	Input Parameters					:					NIL
'	Output Parameters					:					NIL
'	Date Created						:					16-Mar-2017
'	QTP Version							:					UFT 12.0
'	QC Version							:					
'	Pre-requisites						:					NILL  
'	Created By							:					Gallop
'	Modification Date					:	
'******************************************************************************************************************************************************************************************************************************************
Public Function fnGetISOOrderNumber()
	
	Set objFSO = createobject("Scripting.filesystemobject")
	Set objFile = objFSO.OpenTextFile (StrFrameWorkFolder&"\Resources\Log.txt")
	strData = objFile.ReadAll
	strOrderString = Split(strData, "BOOKED")
	
	''''condition to handle the ON Hold orders.Updated by Pradeep on 7th July 
	If Ubound(strOrderString)=0 Then strOrderString = Split(strData, "ON HOLD")
	
	'To get Transfer Order Number
	strOrderNumString = Split(strOrderString(1), "BRANCH TRANSFER")
'	iTransferOrderNo = Mid(Trim(strOrderNumString(0)), 8, 9)''''Commented by Pradeep on 10th July, since the length of string is keep changing
	iTransferOrderNo=Mid(Trim(strOrderNumString(0)),Len(Trim(strOrderNumString(0)))-16,9)''''Added by Pradeep
	Wait(MIN_WAIT)
	fnGetISOOrderNumber = iTransferOrderNo
	If iTransferOrderNo <> "" Then
		 Call rptWriteReport("PASSWITHSCREENSHOT", "Internal Sales Order Creation verification" , "Internal Sales Order is created: "&iTransferOrderNo)
		 Call fnReportStepALM("Order Creation","Passed","Order number creation from SystemZ","Order Number should be created","Order Number "&iTransferOrderNo&" is created")
	Else
		Call rptWriteReport("Fail", "Checking for order number creation" , "Order number is not created")
		Call fnReportStepALM("Order Creation","Failed","Order number creation from SystemZ","Order Number should be created","Order Number is not created")		
	End If
	
End Function
'******************************************************************************************************************************************************************************************************************************************
'	Sub Name		 					:					fnGetISOTransferOrderNumber
'	Objective							:					Used to get the ISO Transfer Order Number
'	Input Parameters					:					NIL
'	Output Parameters					:					NIL
'	Date Created						:					20-Mar-2017
'	QTP Version							:					UFT 12.0
'	QC Version							:					
'	Pre-requisites						:					NILL  
'	Created By							:					Gallop
'	Modification Date					:	
'******************************************************************************************************************************************************************************************************************************************
Public Function fnGetISOTransferOrderNumber()
	If TeWindow("TeWindow").Exist(2) Then
		TeWindow("TeWindow").Activate
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micEsc
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micAltDwn + micF4 + micAltUp
		If Dialog("PuTTY Exit Confirmation").Exist Then
			Dialog("PuTTY Exit Confirmation").WinButton("OK").Click
		End If
	End If	
	Set objFSO = createobject("Scripting.filesystemobject")
	Set objFile = objFSO.OpenTextFile (StrFrameWorkFolder&"\Resources\Log.txt")
	strData = objFile.ReadAll
	strOrderString = Split(strData, "REGULAR")
	'To get Transfer Order Number
	strOrderNumString = Split(strOrderString(1), "ON HOLD")
	strTransferOrderNo = Mid(Trim(strOrderNumString(1)), 59, 9)
	
	strOrderString2 = Split(strData, "BRANCH TRANSFER")
	'To get Transfer Order Number
	strOrderNumString2 = Split(strOrderString2(1), "ON HOLD")
	strTransferOrderNo = Mid(Trim(strOrderNumString2(2)), 59, 9)
	'To get Warehouse Number of Transfer Order 
	strWarehouseSplit   = Split(strOrderString(1), "OUR TRUCK")
	iWarehouseNumber= Mid(Trim(strWarehouseSplit(0)), 9, 3) 
	fnGetISOTransferOrderNumber = strTransferOrderNo&","&iWarehouseNumber
		If strTransferOrderNo <> "" AND iWarehouseNumber <> "" Then
			Call rptWriteReport("PASSWITHSCREENSHOT", "Checking for Transfer order number creation" ,"Transfer Order number "&strTransferOrderNo&" created")
			Call fnReportStepALM("Transfer Order Creation","Passed","Transfer Order number creation from SystemZ","Transafer Order Number should be created","Transfer Order Number "&strTransferOrderNo&" is created")
		Else
			Call rptWriteReport("Fail", "Checking for transfer order number creation" , "Transfer Order number "&strTransferOrderNo&" is not created")
			Call fnReportStepALM ("Transfer Order Creation","Failed","Transfer Order number creation from SystemZ","Transafer Order Number should be created","Order Number is not created")
		End If	
End Function 

Public Function fnCreatePOOrder(iCustomerNo, iProductNo, iQuantity)
'Enter Customer Number 
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type iCustomerNo	
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	Wait(05)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	If TeWindow("TeWindow").Exist(2) Then
		rptWriteReport "Pass", "Customer Number" , "Customer number is entered "&iCustomerNo
		fnReportStepALM "Customer number ","Passed","Enter Customer Number","Customer Number should be entered","Customer Number is entered "&iCustomerNo
	End If
	'Enter Product#
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type iProductNo	
	Wait(05)
	If TeWindow("TeWindow").Exist(2) Then
		rptWriteReport "Pass", "Product Number" , "Product number is entered "&iProductNo
		fnReportStepALM "Product number ","Passed","Enter Product Number","Product Number should be entered","Product Number is entered "&iProductNo
	End If
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	'Enter Quantity 
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type iQuantity
	Wait(05)
	If TeWindow("TeWindow").Exist(2) Then
		rptWriteReport "Pass", "Quantity Number" , "Quantity is entered "&iQuantity
		fnReportStepALM "Quantity ","Passed","Enter Quantity "," Quantity should be entered"," Quantity is entered "&iQuantity
	End If
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type "Y"
	Wait(05)
	Set objFSO = createobject("Scripting.filesystemobject")
	set objFile = objFSO.OpenTextFile (StrFrameWorkFolder&"\Resources\Log.txt")
	strDataMethod = objFile.ReadAll
	intShip = Instr(strDataMethod, "Shipping Method")
	If intShip > 0 Then
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	End If
	Wait(MIN_WAIT)
'	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	Wait(MIN_WAIT)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micF1	
		If TeWindow("TeWindow").Exist(2) Then
			rptWriteReport "Pass", "Press F1" , "Presses function key F1 "
			Call rptWriteReport("PASSWITHSCREENSHOT", "Press F1" , "Presses function key F1 ")
			fnReportStepALM "Press F1 ","Passed","Press function key F1 "," Function key F1 should be pressed"," Function key F1 is pressed"
		End If
	Wait(MAX_WAIT)	
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micDwn	
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type "TL"
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	Wait(MIN_WAIT)
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micDwn
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micDwn
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micDwn
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micDwn
'	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micDwn
'	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
	Wait(MAX_WAIT)
	Set objFSO = createobject("Scripting.filesystemobject")
	set objFile = objFSO.OpenTextFile (StrFrameWorkFolder&"\Resources\Log.txt")
	strData = objFile.ReadAll
	strSubmitLog = Instr(strData, "BOOKED")
		If strSubmitLog >= 0 then
			rptWriteReport "Pass", "Checking for order submission" , "Order Submitted"
			Call rptWriteReport("PASSWITHSCREENSHOT", "Checking for order submission" ,"Order Submitted")
			fnReportStepALM "Submit Order","Passed","Order submission from SystemZ","Order should be submitted","Order is submitted"
		Else		
			rptWriteReport "Fail", "Checking for order submission" , "Order is not Submitted"
			fnReportStepALM "Submit Order","Failed","Order submission from SystemZ","Order should be submitted","Order is submitted"
		End If
End Function
'******************************************************************************************************************************************************************************************************************************************
'	Sub Name		 					:					fnReadSubInventory
'	Objective							:					To get the SubInventory number from text file
'	Input Parameters					:					textFile name
'	Output Parameters					:					NIL
'	Date Created						:					24-Mar-2017
'	QTP Version							:					UFT 12.0
'	QC Version							:					
'	Pre-requisites						:					NILL  
'	Created By							:					Gallop
'	Modification Date					:	
'******************************************************************************************************************************************************************************************************************************************
Public Function fnReadSubInventory(sFilename)
Set objFSOs = createobject("Scripting.filesystemobject")
sFile=trim(sFileName)
Set objFiles = objFSOs.OpenTextFile(sResourcesPathForData&"\"&sFile&".txt")    
Do
	strData=objFiles.ReadLine
    Wait(05)
         If InStr(strData,"SubInventory")>0 Then
              arrItem=Split(strData,":")
                  If IsNumeric(arrItem(1)) Then
                      fnReadSubInventory= Trim(arrItem(1))
                  End If
         End If
     Loop Until objFiles.AtEndOfLine
    objFiles.Close
    set objFiles= Nothing
    Set objFSOs= Nothing
End Function 
	
'******************************************************************************************************************************************************************************************************************************************
'	Sub Name		 					:					fnReadLocator
'	Objective							:					To get the Locatory number from text file
'	Input Parameters					:					textFile name
'	Output Parameters					:					NIL
'	Date Created						:					24-Mar-2017
'	QTP Version							:					UFT 12.0
'	QC Version							:					
'	Pre-requisites						:					NILL  
'	Created By							:					Gallop
'	Modification Date					:	
'******************************************************************************************************************************************************************************************************************************************
  
Public Function fnReadLocator(sFilename)
Set objFSOs = createobject("Scripting.filesystemobject")
sFile=trim(sFileName)
Set objFiles = objFSOs.OpenTextFile(sResourcesPathForData&"\"&sFile&".txt")    
Do
	strData=objFiles.ReadLine
    Wait(05)
         If InStr(strData,"Locator")>0 Then
              arrItem=Split(strData,":")
                  If IsNumeric(arrItem(1)) Then
                       fnReadLocator= Trim(arrItem(1))
                  End If
         End If
     Loop Until objFiles.AtEndOfLine
    objFiles.Close
    set objFiles= Nothing
    Set objFSOs= Nothing
End Function 
'******************************************************************************************************************************************************************************************************************************************
'	Sub Name		 					:					fnReadPurchaseOrder
'	Objective							:					To get the Purchase Order number from text file
'	Input Parameters					:					textFile name
'	Output Parameters					:					NIL
'	Date Created						:					31-Mar-2017
'	QTP Version							:					UFT 12.0
'	QC Version							:					
'	Pre-requisites						:					NILL  
'	Created By							:					Gallop
'	Modification Date					:	
'******************************************************************************************************************************************************************************************************************************************
Public Function fnReadPurchaseOrder(sFileName)
On Error Resume Next
    Set objFSOs = createobject("Scripting.filesystemobject")
        sFile=trim(sFileName)
         set objFiles = objFSOs.OpenTextFile(sResourcesPathForData&"\"&sFile&".txt")    
         Do
             strData=objFiles.ReadLine
             wait 2
             If InStr(strData,"PurchaseOrder")>0 Then
                  arrItem=Split(strData,":")
                      If IsNumeric(arrItem(1)) Then
                         fnReadPurchaseOrder=Trim(arrItem(1))
                      End If
             End If
         Loop Until objFiles.AtEndOfLine
        objFiles.Close
        set objFiles= Nothing
        Set objFSOs= Nothing
End Function
'******************************************************************************************************************************************************************************************************************************************
'	Sub Name		 					:					fnReadSupplierName
'	Objective							:					To get the Supllier Name from text file
'	Input Parameters					:					textFile name
'	Output Parameters					:					NIL
'	Date Created						:					31-Mar-2017
'	QTP Version							:					UFT 12.0
'	QC Version							:					
'	Pre-requisites						:					NILL  
'	Created By							:					Gallop
'	Modification Date					:	
'******************************************************************************************************************************************************************************************************************************************
Public Function fnReadSupplierName(sFileName)
On Error Resume Next
    Set objFSOs = createobject("Scripting.filesystemobject")
        sFile=trim(sFileName)
         set objFiles = objFSOs.OpenTextFile(sResourcesPathForData&"\"&sFile&".txt")    
         Do
             strData=objFiles.ReadLine
             wait 2
             If InStr(strData,"SupplierName")>0 Then
                  arrItem=Split(strData,":")
                      'If not IsNumeric(arrItem(1)) Then
                         fnReadSupplierName=trim(arrItem(1))
                      'End If
             End If
         Loop Until objFiles.AtEndOfLine

        objFiles.Close
        set objFiles= Nothing
        Set objFSOs= Nothing
End Function

''******************************************************************************************************************************************************************************************************************************************
'	Sub Name		 					:					fnWriteSupplierName
'	Objective							:					Used to Write the Supplier From Pruchase Order Window
'	Input Parameters					:					sFileName
'	Output Parameters					:					NIL
'	Date Created						:					31-Mar-2017
'	QTP Version							:					UFT 12.53
'	QC Version							:					ALM 11.53
'	Module Name							:					Enterprise Validation (E2E)
'	Pre-requisites						:					NILL  
'	Created By							:					Gallop
'	Modification Date					:		   
'******************************************************************************************************************************************************************************************************************************************		
Public Function fnWriteSupplierName(sFileName)
		Wait(MID_WAIT)
		iPO_Number= fnReadPurchaseOrder(sFileName)
		If OracleFormWindow("PurchaseOrders").Exist(10) Then
			Call fnReportStepALM("PurchaseOrders", "Passed", "Purchase Orders window verification", "Purchase Orders Window should be display","Purchase Orders Window is displayed")
			Call rptWriteReport("PASSWITHSCREENSHOT", "PurchaseOrders Window verification" ,"PurchaseOrders Window is displayed")
		Else
			Call fnReportStepALM("PurchaseOrders", "Failed", "Purchase Orders window verification", "Purchase Orders Window should be display","Purchase Orders Window is not displayed")
			Call rptWriteReport("Fail", "PurchaseOrders Window verification" ,"PurchaseOrders Window is not displayed")	
		End If
		'Query the PO#
		fnSelectMenu "PurchaseOrders","View->Query By Example->Enter"
		Wait(MIN_WAIT)
		fnEnterText "txtPONumberRetrived", iPO_Number
		fnSelectMenu "PurchaseOrders","View->Query By Example->Run"
		Wait(MID_WAIT)
		sSupplier_Name= fnGetProperty("txtPOSupplierName", "value")
		Wait(MIN_WAIT)
		Set obj = CreateObject("Scripting.FileSystemObject")			
			sFile=trim(sFileName)
				If  obj.FileExists(sResourcesPathForData& "\"&sFile&".txt") Then
					Set oFile=obj.OpenTextFile(sResourcesPathForData& "\"&sFile&".txt", 8, TRUE)
					oFile.Write "SupplierName:"& sSupplier_Name&vbCrLf			
				Else		    
					Set oFile=obj.CreateTextFile(sResourcesPathForData& "\"&sFile&".txt",true)
					oFile.Write "SupplierName:"& sSupplier_Name&vbCrLf					
				End If
				wait 2
			oFile.Close			
			Set oFile= Nothing
			Set obj=Nothing	
End Function
	
'******************************************************************************************************************************************************************************************************************************************
'	Sub Name		 					:					fnWriteTransferOrderNumber
'	Objective							:					To write sale order number and Internal Sales Order Number into local test file
'	Input Parameters					:					textFile name
'	Output Parameters					:					NIL
'	Date Created						:					24-Apr-2017
'	QTP Version							:					UFT 12.0
'	QC Version							:					
'	Pre-requisites						:					NILL  
'	Created By							:					Gallop
'	Modification Date					:	
'******************************************************************************************************************************************************************************************************************************************
Public Function fnWriteTransferOrderNumber(sFileName,inpOrderNumber,inpInternalSalesOrderNumber)
		Set obj = CreateObject("Scripting.FileSystemObject")			
			sFile=trim(sFileName)
				If  obj.FileExists(sResourcesPathForData& "\"&sFile&".txt") Then
				    obj.DeleteFile(sResourcesPathForData& "\"&sFile&".txt")	
			   		Set oFile=obj.CreateTextFile(sResourcesPathForData& "\"&sFile&".txt",true)
				 	oFile.Write "Order Number:"& inpOrderNumber &VBNEWLine		
					oFile.Write "InternalSalesOrderNumber:"&inpInternalSalesOrderNumber&VBNEWLINE	
				Else		    
					Set oFile=obj.CreateTextFile(sResourcesPathForData& "\"&sFile&".txt",true)
					oFile.Write "Order Number:"& inpOrderNumber &VBNEWLine	
					oFile.Write "InternalSalesOrderNumber:"&inpInternalSalesOrderNumber&VBNEWLINE					
				End If
				wait 2
			oFile.Close			
			Set oFile= Nothing
			Set obj=Nothing	 
End Function
'************************************************************************************************************************************************
'	Function Name	 	 :		fnSubmitOrderISO
'	Objective			 :		Used to submit the order in Putty
'	Input Parameters	 :		NIL
'	Output Parameters	 :		NIL
'	Date Created		 :		24-Apr-2017
'	QTP Version			 :		11.0
'	QC Version			 :		QC 11.53
'	Pre-requisites		 :		NIL  
'	Created By			 :		Gallop						
'	Modification Date	 :		   
'************************************************************************************************************************************************
Public Function fnSubmitOrderISO()
	Set objFSO = createobject("Scripting.filesystemobject")
	set objFile = objFSO.OpenTextFile (StrFrameWorkFolder&"\Resources\Log.txt")
	strDataMethod = objFile.ReadAll
	intShip = Instr(strDataMethod, "Shipping Method")
	If intShip > 0 Then
'	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micDwn 
'	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micDwn 
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn 
'	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync
		Wait(MIN_WAIT)		
	End If
'''''Expedit
  	Set objFSO = createobject("Scripting.filesystemobject")
	set objFile = objFSO.OpenTextFile (StrFrameWorkFolder&"\Resources\Log.txt")
	strDataMethod = objFile.ReadAll
	intCustpicup= Instr(strDataMethod, "Are you sure the customer will PICKUP") 
	If intCustpicup > 0 Then
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type "Y"
		Wait(08)
	End If
	If TeWindow("TeWindow").Exist(2) Then
		rptWriteReport "Pass", "Press F1" , "Presses function key F1 "
		Call rptWriteReport("PASSWITHSCREENSHOT", "Press F1" , "Presses function key F1 ")
		fnReportStepALM "Press F1 ","Passed","Press function key F1 "," Function key F1 should be pressed"," Function key F1 is pressed"
	End If
'	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn:Wait(MIN_WAIT)
'	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micReturn:Wait(MIN_WAIT)	
	'''''F1   
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micF1 
'	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync
	Wait 5
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micDwn 
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micDwn 
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micDwn 
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micDwn 
	Wait 1
	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type  micDwn 
'	TeWindow("TeWindow").TeTextScreen("TeTextScreen").Sync
	Wait(35)
		Set objFSO = createobject("Scripting.filesystemobject")
		set objFile = objFSO.OpenTextFile (StrFrameWorkFolder&"\Resources\Log.txt")
		strData = objFile.ReadAll
		strSubmitLog = Instr(strData, "BOOKED")
		If strSubmitLog > 0 OR Instr(strData, "ON HOLD")>0 then''''updated the condition to handle the ON Hold orders.Updated by Pradeep on 7th July
			rptWriteReport "Pass", "Checking for order submission" , "Order Submitted"
			Call rptWriteReport("PASSWITHSCREENSHOT", "Checking for order submission" ,"Order Submitted")
			fnReportStepALM "Submit Order","Passed","Order submission from SystemZ","Order should be submitted","Order is submitted"
		Else		
			rptWriteReport "Fail", "Checking for order submission" , "Order is not Submitted"
			fnReportStepALM "Submit Order","Failed","Order submission from SystemZ","Order should be submitted","Order is submitted"
		End If
End Function

'******************************************************************************************************************************************************************************************************************************************
'	Sub Name		 					:					fnReadInternalSaleOrderNumber
'	Objective							:					To get sales order number from text file
'	Input Parameters					:					textFile name
'	Output Parameters					:					NIL
'	Date Created						:					24-Apr-2017
'	QTP Version							:					UFT 12.0
'	QC Version							:					
'	Pre-requisites						:					NILL  
'	Created By							:					Gallop
'	Modification Date					:	
'******************************************************************************************************************************************************************************************************************************************

Public Function fnReadInternalSaleOrderNumber(sFileName)
On Error Resume Next
    Set objFSOs = createobject("Scripting.filesystemobject")
        sFile=trim(sFileName)
         set objFiles = objFSOs.OpenTextFile(sResourcesPathForData&"\"&sFile&".txt")    
         Do
             strData=objFiles.ReadLine
             wait 2
             If InStr(strData,"InternalSalesOrderNumber")>0 Then
                  arrItem=Split(strData,":")
                      If IsNumeric(arrItem(1)) Then
                         fnReadInternalSaleOrderNumber=trim(arrItem(1))
                      End If
             End If
'             objFiles.SkipLine
         Loop Until objFiles.AtEndOfLine

        objFiles.Close
        set objFiles= Nothing
        Set objFSOs= Nothing
End Function
'******************************************************************************************************************************************************************************************************************************************
'	Sub Name		 					:					fnWriteISOWarehouseNumber
'	Objective							:					To write Internal sale order Warehouse number into local test file
'	Input Parameters					:					textFile name
'	Output Parameters					:					NIL
'	Date Created						:					24-Apr-2017
'	QTP Version							:					UFT 12.0
'	QC Version							:					
'	Pre-requisites						:					NILL  
'	Created By							:					Gallop
'	Modification Date					:	
'******************************************************************************************************************************************************************************************************************************************
Public Function fnWriteISOWarehouseNumber(sFileName,inpOrg)
		Set obj = CreateObject("Scripting.FileSystemObject")
			sFile=trim(sFileName)
'			iWarehouseNo=inpOrg
		If  obj.FileExists(sResourcesPathForData& "\"&sFile&".txt") Then
		  	Set oFile=obj.OpenTextFile(sResourcesPathForData& "\"&sFile&".txt", 8,TRUE)  
			oFile.Write "Warehouse Number:"& inpOrg &VBNEWLine	
			wait 2			
			oFile.Close
			Set oFile= Nothing
			Set obj=Nothing	 
		End If
End Function

Public Function fnToGetWarehouseANDItemNumberForISO()

'		If Ucase(Environment("CountryUS")) = "YES" and  Ucase(Environment("CountryCA")) = "NO" Then
'			fnNavigateToPage("Order Management Super User|Order Organizer")
'		ElseIf Ucase(Environment("CountryUS")) = "NO" and  Ucase(Environment("CountryCA")) = "YES" Then
			fnNavigateToPage("NTD-CA Order Management Super User|Order Organizer")			
'		End If		
		Wait(15)				
				If OracleFormWindow("FindOrders/Quotes").OracleTabbedRegion("Quote/Order Information").Exist(1) Then
					Call fnReportStepALM("Order organizer", "Passed", "Order organizer window verification", "Order organizer should be display","Order organizer is displayed")
					Call rptWriteReport("PASSWITHSCREENSHOT", "Order organizer window verification" ,"Order organizer is displayed")
				Else
					Call fnReportStepALM("Order organizer", "Failed", "Order organizer window verification","Order organizer should be display","Order organizer not displayed")
					Call rptWriteReport("Fail", "Order organizer window verification" , "Order organizer not displayed")
					fnUploadReport strProjectResultPath&"\"&Environment("FolderName"), strProjectResultPath&"\"&Environment("FolderName")
					ExitAction()
				End If	
		iTransferOrderNo=fnReadInternalSaleOrderNumber("NTD_Generic Sales Order Which Triggers ISO")
		wait 2
		fnEnterText "txtOrderNumberQuote",iTransferOrderNo
		fnClick "btnFindORderQuotes"
		wait 2
		fnClick "btnOpenOrganizer"
		fnSelect "LineItems","Line Items"
		fnSelect "ShippingWindow","Shipping"
		iOrderItemNumber=fnGetCellData("SalesOrderLineItems",1,2)		
		Call fnWriteItemNumber("NTD_Generic Sales Order Which Triggers ISO",iOrderItemNumber)
		intWarehouseNo=fnGetCellData("SalesOrderLineItems",1,3)
		Call fnWriteISOWarehouseNumber("NTD_Generic Sales Order Which Triggers ISO",intWarehouseNo)	
		wait 2		
		If OracleFormWindow("SalesOrders").Exist(1) Then
				OracleFormWindow("SalesOrders").CloseWindow
			End If
		If OracleFormWindow("Order Organizer").Exist(1) Then
			OracleFormWindow("Order Organizer").CloseWindow
		End If				
	End Function 	
	'******************************************************************************************************************************************************************************************************************************************
'	Sub Name		 					:					fnReadInternalSalesOrderWarehouseNumber
'	Objective							:					To get Warehouse Number from text file
'	Input Parameters					:					textFile name
'	Output Parameters					:					NIL
'	Date Created						:					05-Mar-2017
'	QTP Version							:					UFT 12.0
'	QC Version							:					
'	Pre-requisites						:					NILL  
'	Created By							:					Balaji Veeravalli
'	Modification Date					:	
'******************************************************************************************************************************************************************************************************************************************
Public Function fnReadInternalSalesOrderWarehouseNumber(sFileName)
On Error Resume Next
    Set objFSOs = createobject("Scripting.filesystemobject")
        sFile=trim(sFileName)
         set objFiles = objFSOs.OpenTextFile(sResourcesPathForData&"\"&sFile&".txt")    
         Do
             strData=objFiles.ReadLine
             wait 2
             If InStr(strData,"Warehouse Number")>0 Then
                  arrItem=Split(strData,":")
                      If IsNumeric(arrItem(1)) Then
                         fnReadInternalSalesOrderWarehouseNumber=Trim(arrItem(1))
                      End If
             End If
'             objFiles.SkipLine
         Loop Until objFiles.AtEndOfLine
        objFiles.Close
        set objFiles= Nothing
        Set objFSOs= Nothing
End Function
'******************************************************************************************************************************************************************************************************************************************
'	Sub Name		 					:					fnWriteInternalSalesOrderTransactionNumber
'	Objective							:					To write Transaction Number into local test file
'	Input Parameters					:					textFile name
'	Output Parameters					:					NIL
'	Date Created						:					24-Apr-2017
'	QTP Version							:					UFT 12.0
'	QC Version							:					
'	Pre-requisites						:					NILL  
'	Created By							:					Rajasekhar
'	Modification Date					:	
'******************************************************************************************************************************************************************************************************************************************
Public Function fnWriteInternalSalesOrderTransactionNumber(sFileName,inpTransactionNo)
		Set obj = CreateObject("Scripting.FileSystemObject")
			sFile=trim(sFileName)
		If  obj.FileExists(sResourcesPathForData& "\"&sFile&".txt") Then
		  	Set oFile=obj.OpenTextFile(sResourcesPathForData& "\"&sFile&".txt", 8,TRUE)  
			oFile.Write "Internal Sales Order Transacton Number:"&inpTransactionNo &VBNEWLine
			wait 2
		oFile.Close
		Set oFile= Nothing
		Set obj=Nothing	 
		End If
End Function

'******************************************************************************************************************************************************************************************************************************************
'	Sub Name		 					:					fnWriteInternalSalesOrderDeliveryNumber
'	Objective							:					To write Delivery number into local test file
'	Input Parameters					:					textFile name
'	Output Parameters					:					NIL
'	Date Created						:					05-Mar-2017
'	QTP Version							:					UFT 12.0
'	QC Version							:					
'	Pre-requisites						:					NILL  
'	Created By							:					Rajasekhar
'	Modification Date					:	
'******************************************************************************************************************************************************************************************************************************************
Public Function fnWriteInternalSalesOrderDeliveryNumber(sFileName,inpDeliveryNo)
		Set obj = CreateObject("Scripting.FileSystemObject")
			sFile=trim(sFileName)
		If  obj.FileExists(sResourcesPathForData& "\"&sFile&".txt") Then
		  	Set oFile=obj.OpenTextFile(sResourcesPathForData& "\"&sFile&".txt", 8,TRUE)  
			oFile.Write "Internal Sales Order Delivery Number:"& inpDeliveryNo &VBNEWLine
			wait 2
		oFile.Close
		Set oFile= Nothing
		Set obj=Nothing	 
		End If
End Function
'******************************************************************************************************************************************************************************************************************************************
'	Sub Name		 					:					fnGetInternalSalesOrderDeliveryNumber
'	Objective							:					To get delivery number from order organizer
'	Input Parameters					:					textFile name
'	Output Parameters					:					NIL
'	Date Created						:					24-Apr-2017
'	QTP Version							:					UFT 12.0
'	QC Version							:					
'	Pre-requisites						:					NILL  
'	Created By							:					Gallop
'	Modification Date					:	
'****************************************************************************************************************************************************************************************************************************************** 
Public Function fnGetInternalSalesOrderDeliveryNumber()	
		If Ucase(Environment("CountryUS")) = "YES" and  Ucase(Environment("CountryCA")) = "NO" Then
			fnNavigateToPage("Order Management Super User|Order Organizer")
		ElseIf Ucase(Environment("CountryUS")) = "NO" and  Ucase(Environment("CountryCA")) = "YES" Then
			fnNavigateToPage("NTD-CA Order Management Super User|Order Organizer")			
		End If	
		fnSynUntilObjExists "FindOrders/Quotes", 40
 		If OracleFormWindow("FindOrders/Quotes").Exist(1) Then
			Call fnReportStepALM("Order organizer", "Passed", "Order organizer window verification", "Order organizer should be display","Order organizer is displayed")
			Call rptWriteReport("PASSWITHSCREENSHOT", "Order organizer window verification" ,"Order organizer is displayed")
		Else
			Call fnReportStepALM("Order organizer", "Failed", "Order organizer window verification","Order organizer should be display","Order organizer not displayed")
			Call rptWriteReport("Fail", "Order organizer window verification" , "Order organizer not displayed")
			fnUploadReport strProjectResultPath&"\"&Environment("FolderName"), strProjectResultPath&"\"&Environment("FolderName")
			ExitAction()
		End If		
		strSaleOrderNumber= fnReadInternalSaleOrderNumber("NTD_Generic Sales Order Which Triggers ISO")
		fnEnterText "txtOrderNumberQuote",trim(strSaleOrderNumber)
		fnClick "btnFindORderQuotes"
		wait(MID_WAIT)
		fnClick "btnActionsOrganizer"
'		fnValueSelectFromOrganizationSales trim("Additional Order Information")
		OracleListOfValues("olvActionsOrderOrganizer").Select trim("Additional Order Information")
'		wait(MID_WAIT)
		fnSelect "DeliveriesAddl","Deliveries"
		wait(MIN_WAIT)
		iDeliveryNumber=fnGetCellData("otDeliveriesInfo",1,2)
		wait(1)		
	    Call fnWriteInternalSalesOrderDeliveryNumber("NTD_Generic Sales Order Which Triggers ISO",iDeliveryNumber) 
'	    OracleFormWindow("SalesOrders").CloseForm	
		Call fnCloseAllOpenBrowsers()			
End Function 


'******************************************************************************************************************************************************************************************************************************************
'	Sub Name		 					:					fnReadLPNnumber
'	Objective							:					To get LPN number from text file
'	Input Parameters					:					textFile name
'	Output Parameters					:					LPN Number
'	Date Created						:					16-May-2017
'	QTP Version							:					UFT 12.0
'	QC Version							:					
'	Pre-requisites						:					NILL  
'	Created By							:					Rajasekhar 
'	Modification Date					:	
'******************************************************************************************************************************************************************************************************************************************

Public Function fnReadLPNnumber(sFileName)
On Error Resume Next
    Set objFSOs = createobject("Scripting.filesystemobject")
        sFile=trim(sFileName)
         set objFiles = objFSOs.OpenTextFile(sResourcesPathForData&"\"&sFile&".txt")    
         Do
             strData=objFiles.ReadLine
             wait 2
             If InStr(strData,"LPN Number")>0 Then
                  arrItem=Split(strData,":")
                      If IsNumeric(arrItem(1)) Then
                         fnReadLPNnumber=trim(arrItem(1))
                      End If
             End If
         Loop Until objFiles.AtEndOfLine

        objFiles.Close
        set objFiles= Nothing
        Set objFSOs= Nothing
End Function


'******************************************************************************************************************************************************************************************************************************************
'	Sub Name		 					:					fnWriteOrderQuantity
'	Objective							:					To write Delivery number into local test file
'	Input Parameters					:					textFile name
'	Output Parameters					:					NIL
'	Date Created						:					05-Mar-2017
'	QTP Version							:					UFT 12.0
'	QC Version							:					
'	Pre-requisites						:					NILL  
'	Created By							:					Rajasekhar
'	Modification Date					:	
'******************************************************************************************************************************************************************************************************************************************
Public Function fnWriteOrderQuantity (sFileName,inpQuantityNo)
		Set obj = CreateObject("Scripting.FileSystemObject")
			sFile=trim(sFileName)
'			iDeliveryNum=inpDeliveryNo
		If  obj.FileExists(sResourcesPathForData& "\"&sFile&".txt") Then
		  	Set oFile=obj.OpenTextFile(sResourcesPathForData& "\"&sFile&".txt", 8,TRUE)  
			oFile.Write "Quantity:"& inpQuantityNo &VBNEWLine
			wait 2
		oFile.Close
		Set oFile= Nothing
		Set obj=Nothing	 
		End If
End Function

'******************************************************************************************************************************************************************************************************************************************
'	Sub Name		 					:					fnReadOrderQuantity
'	Objective							:					To get Delivery Number from text file
'	Input Parameters					:					textFile name
'	Output Parameters					:					NIL
'	Date Created						:					05-Mar-2017
'	QTP Version							:					UFT 12.0
'	QC Version							:					
'	Pre-requisites						:					NILL  
'	Created By							:					Rajasekhar
'	Modification Date					:	
'******************************************************************************************************************************************************************************************************************************************
Public Function fnReadOrderQuantity(sFileName)
On Error Resume Next
    Set objFSOs = createobject("Scripting.filesystemobject")
        sFile=trim(sFileName)
         set objFiles = objFSOs.OpenTextFile(sResourcesPathForData&"\"&sFile&".txt")    
         Do
             strData=objFiles.ReadLine
             wait 2
             If InStr(strData,"Quantity:")>0 Then
                  arrItem=Split(strData,":")
                      If IsNumeric(arrItem(1)) Then
                         fnReadOrderQuantity=Trim(arrItem(1))
                      End If
             End If
         Loop Until objFiles.AtEndOfLine
        objFiles.Close
        set objFiles= Nothing
        Set objFSOs= Nothing
End Function

'******************************************************************************************************************************************************************************************************************************************
'	Sub Name		 					:					fnReadInternalSalesOrderTransactionNumber
'	Objective							:					To Read Transaction Number from test file
'	Input Parameters					:					textFile name
'	Output Parameters					:					NIL
'	Date Created						:					27-June-2017
'	QTP Version							:					UFT 12.0
'	QC Version							:					
'	Pre-requisites						:					NILL  
'	Created By							:					Rajasekhar
'	Modification Date					:	
'******************************************************************************************************************************************************************************************************************************************
Public Function fnReadInternalSalesOrderTransactionNumber(sFileName)
		Set objFSOs = createobject("Scripting.filesystemobject")
        sFile=trim(sFileName)
         set objFiles = objFSOs.OpenTextFile(sResourcesPathForData&"\"&sFile&".txt")    
         Do
             strData=objFiles.ReadLine
             wait 2
             If InStr(strData,"Internal Sales Order Transacton Number:")>0 Then
                  arrItem=Split(strData,":")
                      If IsNumeric(arrItem(1)) Then
                         fnReadInternalSalesOrderTransactionNumber=Trim(arrItem(1))
                      End If
             End If
         Loop Until objFiles.AtEndOfLine
        objFiles.Close
        set objFiles= Nothing
        Set objFSOs= Nothing
End Function
'******************************************************************************************************************************************************************************************************************************************
'	Sub Name		 					:					fnCheckPuttySession
'	Objective							:					Used To check the old/new session of Putty  
'	Input Parameters					:					NIL
'	Output Parameters					:					NIL
'	Date Created						:					27-June-2017
'	QTP Version							:					UFT 12.0
'	QC Version							:					
'	Pre-requisites						:					NILL  
'	Created By							:					Rajasekhar
'	Modification Date					:	
'******************************************************************************************************************************************************************************************************************************************
Public Function fnCheckPuttySession()
		Set objFSO = createobject("Scripting.filesystemobject")
		set objFile = objFSO.OpenTextFile (StrFrameWorkFolder&"\Resources\Log.txt")
		strSession = objFile.ReadAll	
		If Instr(strSession, "old session") > 0 Then
			TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type "N"
			TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
			rptWriteReport "Pass", "New Session" , "Navigated to new session"
			fnReportStepALM "Navigate Session","Passed","Session Navigate","Should navigate to new session","Navigated to new session"	
		ElseIf Instr(strSession, "ATDI Whse Ops Director")>0 Then 
			Call fnReportStepALM("ATDI Whse Ops Direc", "Passed", "ATDI Whse Ops Direc screen verification", "ATDI Whse Ops Direc screen should be displayed","ATDI Whse Ops Direc screen is displayed")
			Call rptWriteReport("PASSWITHSCREENSHOT", "ATDI Whse Ops Direc screen verification", "ATDI Whse Ops Direc screen is displayed")
			TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
		Else
			Call fnReportStepALM("ATDI Whse Ops Direc", "Failed", "ATDI Whse Ops Direc screen verification", "ATDI Whse Ops Direc Screen should be displayed","ATDI Whse Ops Direc screen is not displayed")
			Call rptWriteReport("Fail", "Receive screen verification", "Receive screen is not displayed")
		End If	
		objFile.Close
		Set objFSO= Nothing
End Function

'******************************************************************************************************************************************************************************************************************************************
'	Sub Name		 					:					fnPickConfirmFromMobileInterfaceForISO
'	Objective							:					Used To Pick Confirm From Mobile Interface for ISO order 
'	Input Parameters					:					Warehouse Number, Transaction Number and Item Number
'	Output Parameters					:					NIL
'	Date Created						:					27-June-2017
'	QTP Version							:					UFT 12.0
'	QC Version							:					
'	Pre-requisites						:					NILL  
'	Created By							:					Rajasekhar
'	Modification Date					:	
'******************************************************************************************************************************************************************************************************************************************

Public Function fnPickConfirmFromMobileInterfaceForISO(iWarehouseNumber, iTransactionNumber, iProduct_Number)

		fnSynUntilFieldExists "4 <Pick", 10
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type 4
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn 
		fnSynUntilFieldExists "Select Organization", 10
		Set objFSO = createobject("Scripting.filesystemobject")
		set objFile = objFSO.OpenTextFile (StrFrameWorkFolder&"\Resources\Log.txt")
		strSession = objFile.ReadAll
		'Verify Organization screen
		If Instr(strSession, "Select Organization")>0 Then
			Call fnReportStepALM("Organization", "Passed", "Organization screen verification", "Should Display Organization screen","Organization screen is displayed")
			Call rptWriteReport("PASSWITHSCREENSHOT", "Organization screen verification", "Organization screen is displayed")
		Else
			Call fnReportStepALM("Organizationr", "Failed", "Organization screen verification", "Should Display Organization Screen","Organization screen is not displayed")
			Call rptWriteReport("Fail", "Organization screen verification", "Organization screen is not displayed")
		End If 
		objFile.Close
		'Enter Organization number
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type iWarehouseNumber
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
		fnSynUntilFieldExists "Choose Eqp/Sub", 10	
		set objFile = objFSO.OpenTextFile (StrFrameWorkFolder&"\Resources\Log.txt")
		strSession = objFile.ReadAll
		'Verify Eqp/Sub screen
		If Instr(strSession, "Choose Eqp/Sub")>0 Then
			Call fnReportStepALM("Eqp/Sub", "Passed", "Eqp/Sub screen verification", "Should Display Eqp/Sub screen","Eqp/Sub screen is displayed")
			Call rptWriteReport("PASSWITHSCREENSHOT", "Eqp/Sub screen verification", "Eqp/Sub screen is displayed")
		Else
			Call fnReportStepALM("Eqp/Sub", "Failed", "Eqp/Sub screen verification", "Should Display Eqp/Sub Screen","Eqp/Sub screen is not displayed")
			Call rptWriteReport("Fail", "Eqp/Sub screen verification", "Eqp/Sub screen is not displayed")
		End If 	
		objFile.Close	
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micDwn
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
		Wait(02)
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micDwn
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
		fnSynUntilFieldExists "Pick", 10
		'Type 3 Manual Pick
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type 3
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
		fnSynUntilFieldExists "Paper Pick", 10
		set objFile = objFSO.OpenTextFile (StrFrameWorkFolder&"\Resources\Log.txt")
		strSession = objFile.ReadAll		
		'Verify PICK Screen
		If Instr(strSession, "Paper Pick")>0 Then
			Call fnReportStepALM("Paper Pick", "Passed", "Paper Pick screen verification", "Paper Pick screen should be displayed","Paper Pick screen is displayed")
			Call rptWriteReport("PASSWITHSCREENSHOT", "Paper Pick screen verification", "Paper Pick screen is displayed")
		Else
			Call fnReportStepALM("Paper Pick", "Failed", "Paper Pick screen verification", "Should Display Paper Pick Screen","Paper Pick screen is not displayed")
			Call rptWriteReport("Fail", "Paper Pick screen verification", "Paper Pick screen is not displayed")
		End If
		objFile.Close 
		'Enter Transaction Number 
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type iTransactionNumber
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
		fnSynUntilFieldExists "Load", 20
		set objFile = objFSO.OpenTextFile (StrFrameWorkFolder&"\Resources\Log.txt")
		strSession = objFile.ReadAll
		If Instr(strSession, "Load")>0 Then
			Call fnReportStepALM("Load", "Passed", "Load screen verification", "Should Display Load screen","Load screen is displayed")
			Call rptWriteReport("PASSWITHSCREENSHOT", "Load screen verification", "Load screen is displayed")
		Else
			Call fnReportStepALM("Load", "Failed", "Load screen verification", "Should Display Load Screen","Load screen is not displayed")
			Call rptWriteReport("Fail", "Load screen verification", "Load screen is not displayed")
		End If
		set objFile = objFSO.OpenTextFile (StrFrameWorkFolder&"\Resources\Log.txt")
		strData = objFile.ReadAll
		strSub = Split(strData, "Sub                 :")
		strLoc = Split(strData, "Loc                 :")
		iArrQuantity= Split(strData, "Req Qty             :")
		arraySub= Split(strSub(1), "Confirm             :")
		arrayLoc= Split(strLoc(1), "Confirm             :")
		iReqQuantity= Split(iArrQuantity(1), "Confirm             :")
		Set re = New RegExp
		re.Pattern = "\s+"
		re.Global = True
		strSub = Trim(re.Replace(arraySub(0), " "))
		strLOC= Trim(re.Replace(arrayLoc(0), " "))
		iRequiredQty= Trim(re.Replace(iReqQuantity(0), " "))
		objFile.Close	
		'Enter SubInventory
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type strSub
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
		Wait(03)
		'Enter LOC
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type strLoc
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
		Wait(03)
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type iProduct_Number
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
		Wait(03)
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micDwn
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
		Wait(03)
		'Quantity
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type iReqQuantity
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
		Wait(03)
		'Press Ctrl+G to confirm LPN
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micCtrlDwn+ "G" + micCtrlUp
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
		Wait(03)
		'Click on Load and Drop
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micDwn
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
		fnSynUntilFieldExists "Drop", 20
		set objFile = objFSO.OpenTextFile (StrFrameWorkFolder&"\Resources\Log.txt")
		strData = objFile.ReadAll
		strToSub = Split(strData, "To Sub    :")
		strToLoc = Split(strData, "To Loc    :")
		arrayToSub= Split(strToSub(1), "Confirm   >[7m")
		arrayToLoc= Split(strToLoc(1), "Confirm   ][7m")
		strToSub = Trim(re.Replace(arrayToSub(0), " "))
		strToLOC= Trim(re.Replace(arrayToLoc(0), " "))
		'Enter To SubInventory
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type strToSub
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
		Wait(03)
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type strToLOC
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
		Wait(03)
		TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micReturn
		objFile.Close
		fnSynUntilFieldExists "Task Complete", 30
		set objFile = objFSO.OpenTextFile (StrFrameWorkFolder&"\Resources\Log.txt")
		strData = objFile.ReadAll
		'Verify Task Complete  Screen
		If Instr(strData, "Task Complete")>0 Then 
			Call fnReportStepALM("Task Complete", "Passed", "Task Complete screen verification", "Should Display Task Complete screen","Task Complete screen is displayed")
			Call rptWriteReport("PASSWITHSCREENSHOT", "Task Complete screen verification", "Task Complete screen is displayed")
		Else
			Call fnReportStepALM("Task Complete", "Failed", "Task Complete screen verification", "Should Display Task Complete Screen","Task Complete screen is not displayed")
			Call rptWriteReport("Fail", "Task Complete screen verification", "Task Complete screen is not displayed")
		End If
		objFile.Close
		Set objFSO= Nothing 
		Set objFSO = createobject("Scripting.filesystemobject")
		If  obj.FileExists(sResourcesPathForData& "\"&"EE_GenericSalesOrderThatTriggersISO"&".txt") Then
		  	Set oFile=obj.OpenTextFile(sResourcesPathForData& "\"&sFile&".txt", 8,TRUE)  
			oFile.Write "ISO Quantity:"& iReqQuantity &VBNEWLine	
			wait 2			
			oFile.Close
			Set oFile= Nothing
			Set obj=Nothing	 
		End If 
End Function

'******************************************************************************************************************************************************************************************************************************************
'	Sub Name		 					:					fnWriteISOLPNNumber
'	Objective							:					Used To write LPN number into local test file
'	Input Parameters					:					textFile name
'	Output Parameters					:					NIL
'	Date Created						:					27-Apr-2017
'	QTP Version							:					UFT 12.0
'	QC Version							:					
'	Pre-requisites						:					NILL  
'	Created By							:					Rajasekhar
'	Modification Date					:	
'******************************************************************************************************************************************************************************************************************************************
Public Function fnWriteISOLPNNumber(sFileName)
		Set obj = CreateObject("Scripting.FileSystemObject")
		sFile=trim(sFileName)
		Set objFile = objFSO.OpenTextFile(sResourcesPathForData&"\log.txt")
        strData = objFile.ReadAll      
		strXfterLPN= Split(strData, "Xfer LPN            :[7m")
		strSplitLPN= Split(strXfterLPN(8), "                            [0m")
		iLPN_Number= strSplitLPN(0)
		objFile.Close
		If  obj.FileExists(sResourcesPathForData& "\"&sFile&".txt") Then
		  	Set oFile=obj.OpenTextFile(sResourcesPathForData& "\"&sFile&".txt", 8,TRUE)  
			oFile.Write "ISO Order LPN Number:"& iLPN_Number &VBNEWLine	
			wait 2			
			oFile.Close
			Set oFile= Nothing
			Set obj=Nothing	 
		End If
End Function
'******************************************************************************************************************************************************************************************************************************************
'	Sub Name		 					:					fnReadInternalSalesOrderLPNnumber
'	Objective							:					To Read LPN Number from test file
'	Input Parameters					:					textFile name
'	Output Parameters					:					NIL
'	Date Created						:					27-June-2017
'	QTP Version							:					UFT 12.0
'	QC Version							:					
'	Pre-requisites						:					NILL  
'	Created By							:					Rajasekhar
'	Modification Date					:	
'******************************************************************************************************************************************************************************************************************************************
Public Function fnReadInternalSalesOrderLPNnumber(sFileName)
		Set objFSOs = createobject("Scripting.filesystemobject")
        sFile=trim(sFileName)
        set objFiles = objFSOs.OpenTextFile(sResourcesPathForData&"\"&sFile&".txt")    
        Do
             strData=objFiles.ReadLine
             wait 2
             If InStr(strData,"ISO Order LPN Number:")>0 Then
                  arrItem=Split(strData,":")
                      If IsNumeric(arrItem(1)) Then
                         fnReadInternalSalesOrderLPNnumber=Trim(arrItem(1))
                      End If
             End If
         Loop Until objFiles.AtEndOfLine
        objFiles.Close
        set objFiles= Nothing
        Set objFSOs= Nothing
End Function

'******************************************************************************************************************************************************************************************************************************************
'	Sub Name		 					:					fnReadInternalSalesOrderDeliveryNumber
'	Objective							:					To Read Delivery Number from test file
'	Input Parameters					:					textFile name
'	Output Parameters					:					NIL
'	Date Created						:					27-June-2017
'	QTP Version							:					UFT 12.0
'	QC Version							:					
'	Pre-requisites						:					NILL  
'	Created By							:					Rajasekhar
'	Modification Date					:	
'******************************************************************************************************************************************************************************************************************************************
Public Function fnReadInternalSalesOrderDeliveryNumber(sFileName)
		Set objFSOs = createobject("Scripting.filesystemobject")
        sFile=trim(sFileName)
        set objFiles = objFSOs.OpenTextFile(sResourcesPathForData&"\"&sFile&".txt")    
        Do
             strData=objFiles.ReadLine
             wait 2
             If InStr(strData,"Internal Sales Order Delivery Number:")>0 Then
                  arrItem=Split(strData,":")
                      If IsNumeric(arrItem(1)) Then
                         fnReadInternalSalesOrderDeliveryNumber=Trim(arrItem(1))
                      End If
             End If
         Loop Until objFiles.AtEndOfLine
        objFiles.Close
        set objFiles= Nothing
        Set objFSOs= Nothing
End Function

'******************************************************************************************************************************************************************************************************************************************
'	Sub Name		 					:					fnWriteLPNnumber
'	Objective							:					Used To write LPN number into local test file
'	Input Parameters					:					textFile name
'	Output Parameters					:					NIL
'	Date Created						:					28-Apr-2017
'	QTP Version							:					UFT 12.0
'	QC Version							:					
'	Pre-requisites						:					NILL  
'	Created By							:					Rajasekhar
'	Modification Date					:	
'******************************************************************************************************************************************************************************************************************************************
Public Function fnWriteLPNnumber(sFileName)
Set obj = CreateObject("Scripting.FileSystemObject")
	sFile=trim(sFileName)
	Set objFSO = createobject("Scripting.filesystemobject")
	Set objFile = objFSO.OpenTextFile (StrFrameWorkFolder&"\Resources\Log.txt")
	strData = objFile.ReadAll
	Wait(02)
	strOrderString = Split(strData, "LPN            >[7m")
	strLPNSalesOrder= Split(strOrderString(8), "                                 [0m")
	iSalesOrderLPN= strLPNSalesOrder(0)
		If  obj.FileExists(sResourcesPathForData& "\"&sFile&".txt") Then
		  	Set oFile=obj.OpenTextFile(sResourcesPathForData& "\"&sFile&".txt", 8,TRUE)  
			oFile.Write "Sales Order LPN Number:"& iSalesOrderLPN &VBNEWLine	
			wait 2			
			oFile.Close
			Set oFile= Nothing
			Set obj=Nothing	 
	   End If
End Function

'******************************************************************************************************************************************************************************************************************************************
'	Sub Name		 					:					fnReadLPNnumber
'	Objective							:					To Read LPN Number from test file
'	Input Parameters					:					textFile name
'	Output Parameters					:					NIL
'	Date Created						:					28-June-2017
'	QTP Version							:					UFT 12.0
'	QC Version							:					
'	Pre-requisites						:					NILL  
'	Created By							:					Rajasekhar
'	Modification Date					:	
'******************************************************************************************************************************************************************************************************************************************
Public Function fnReadLPNnumber(sFileName)
		Set objFSOs = createobject("Scripting.filesystemobject")
        sFile=trim(sFileName)
        set objFiles = objFSOs.OpenTextFile(sResourcesPathForData&"\"&sFile&".txt")    
        Do
             strData=objFiles.ReadLine
             wait 2
             If InStr(strData,"Sales Order LPN Number:")>0 Then
                  arrItem=Split(strData,":")
                      If IsNumeric(arrItem(1)) Then
                         fnReadLPNnumber=Trim(arrItem(1))
                      End If
             End If
         Loop Until objFiles.AtEndOfLine
        objFiles.Close
        set objFiles= Nothing
        Set objFSOs= Nothing
End Function

'******************************************************************************************************************************************************************************************************************************************
'	Sub Name		 					:					fnReadISOQuantity
'	Objective							:					To Read Quantity Number from test file
'	Input Parameters					:					textFile name
'	Output Parameters					:					NIL
'	Date Created						:					28-June-2017
'	QTP Version							:					UFT 12.0
'	QC Version							:					
'	Pre-requisites						:					NILL  
'	Created By							:					Rajasekhar
'	Modification Date					:	
'******************************************************************************************************************************************************************************************************************************************
Public Function fnReadISOQuantity(sFileName)
		Set objFSOs = createobject("Scripting.filesystemobject")
        sFile=trim(sFileName)
        set objFiles = objFSOs.OpenTextFile(sResourcesPathForData&"\"&sFile&".txt")    
        Do
             strData=objFiles.ReadLine
             wait 2
             If InStr(strData,"ISO Quantity:")>0 Then
                  arrItem=Split(strData,":")
                      If IsNumeric(arrItem(1)) Then
                         fnReadISOQuantity=Trim(arrItem(1))
                      End If
             End If
         Loop Until objFiles.AtEndOfLine
        objFiles.Close
        set objFiles= Nothing
        Set objFSOs= Nothing
End Function
