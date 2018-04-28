
'******************************************************************************************************************************************************************************************************
' Business Functions
''******************************************************************************************************************************************************************************************************
'Desciption of Library :  functions specific to the ATD applications
'******************************************************************************************************************************************************************************************************
'Total No. of  Functions:46
'******************************************************************************************************************************************************************************************************
Call fnSelectRegion()
Environment("QAEnv1") = ""
'******************************************************************************************************************************************************************************************************************************************
'	Function Name						:					fnSelectRegion
'	Objective							:					Used to select the region of Oracle EBS Application
'	Input Parameters					:					NIL
'	Output Parameters					:					NIL
'	Date Created						:					26-July-2015
'	QTP Version							:					UFT 12.0
'	QC Version							:					
'	Pre-requisites						:					NIL  
'	Created By							:					Gallop Solutions
'	Modification Date					:		   
'*****************************************************************************************************************************************************************************************************************************************		
Public Function fnSelectRegion()
	Environment("CountryUS") = ""
	Environment("CountryCA") = ""
	If Setting("IsInTestDirectorTest") = True Then
		Set ts = QCUTIL.CurrentTestSet
		strCountry = ts.Field("CY_USER_04")
		If Ucase(strCountry) = "EBSQA-US" Then
			Environment("CountryUS") = "YES"
			Environment("CountryCA") = "NO"
		ElseIf Ucase(strCountry) = "EBSQA-CANADA" Then
			Environment("CountryCA") = "YES"
			Environment("CountryUS") = "NO"
		End If
		'print Environment("CountryCA")
		Set TestSetFilter = Nothing
		Set myTestSet = Nothing
		Set TSetFact = Nothing
		Set TestSetFilter = Nothing
	Else
		Environment("CountryUS") = "YES"
		Environment("CountryCA") = "NO"
	End If
End Function
'******************************************************************************************************************************************************************************************************************************************
'	Function Name						:					fnRequestPhase
'	Objective							:					Used to Request phase and status for requests
'	Input Parameters					:					NIL
'	Output Parameters					:					NIL
'	Date Created						:					26-Apr-2017
'	QTP Version							:					UFT 12.0
'	QC Version							:					
'	Pre-requisites						:					NIL  
'	Created By							:					Gallop Solutions
'	Modification Date					:		   
'*****************************************************************************************************************************************************************************************************************************************		
Public Function fnRequestPhase(RequestName)
	bflag=false
	iCounter=1
	Visiblerows = OracleFormWindow("Requests").OracleTable("otRequestTable").GetROProperty("visible rows")
	For i = 1 To Visiblerows
		ApplicationRequestName = fnGetCelldata("otRequestTable",i,2)	
		If Trim(ApplicationRequestName)=Trim(RequestName) Then
			PhaseValue=fnGetCelldata("otRequestTable",i,4)
			StatusValue=fnGetCelldata("otRequestTable",i,5)
			Do
				If PhaseValue="Completed" Then
					If StatusValue="Normal" or StatusValue="Warning" Then
						bflag=True
						Exit For
					Elseif StatusValue="Error"then
			    		bflag=True
			    		Exit For
	  				End If
			   else
			      fnClick "btnReqRefreshData"
			       wait 4
			       PhaseValue=fnGetCelldata("otRequestTable",i,4)
					StatusValue=fnGetCelldata("otRequestTable",i,5)					  
   			   End If
   			   iCounter=iCounter+1
			Loop Until (bflag=True OR iCounter=100)   '''' Attended by Balaji Veeravalli
		End If
	Next		
End Function


'******************************************************************************************************************************************************************************************************************************************
'	Function Name						:					fnOracleEBSLogin
'	Objective							:					Used to launch / login into the Oracle EBS Application
'	Input Parameters					:					NIL
'	Output Parameters					:					NIL
'	Date Created						:					26-July-2015
'	QTP Version							:					UFT 12.0
'	QC Version							:					
'	Pre-requisites						:					NIL  
'	Created By							:					Gallop Solutions
'	Modification Date					:		   
'*****************************************************************************************************************************************************************************************************************************************		
Public Function fnOracleEBSLogin()
	SystemUtil.CloseProcessByName("iexplore.exe")
	If Environment("QAEnv1") = "YES" Then
		strURL = Environment("OracleQAURL")
		strUID = Environment("OracleQAUserID")
		strPWD = Environment("OracleQAPassword")
	ElseIf Environment("UATEnv") = "NO" Then
		strURL = Environment("OracleUATURL")
		strUID = Environment("OracleUATUserID")
		strPWD = Environment("OracleUATPassword")	
	ElseIf Environment("DXEnv") = "YES" Then
		strURL = Environment("OracleDXURL")
		strUID = Environment("OracleDXUserID")
		strPWD = Environment("OracleDXPassword")
	Else
		strURL = Environment("OracleQAURL")
		strUID = Environment("OracleQAUserID")
		strPWD = Environment("OracleQAPassword")
	End If
	If Environment("IEBrowser") = "YES" Then
		SystemUtil.Run "iexplore.exe",strURL	
	ElseIf Environment("ChromeBrowser") = "YES" Then
		SystemUtil.Run "Chrome.exe",strURL	
	ElseIf Environment("FireFoxBrowser") = "YES" Then
		SystemUtil.Run "firefox.exe",strURL	
	End If
	Wait(MID_WAIT)
	
    If oOracleLogin.WebEdit("txtUsernameField").Exist(MID_WAIT) Then
      	Call rptWriteReport("Pass", "Launch Oracle Application","Succesfully launched the application")
'		fneditset oOracleLogin.WebEdit("txtUsernameField"),Environment("OracleUserID")
		fneditset oOracleLogin.WebEdit("txtUsernameField"),strUID
'		fneditset oOracleLogin.WebEdit("txtPasswordField"),Environment("OraclePassword")
		fneditset oOracleLogin.WebEdit("txtPasswordField"),strPWD
		fnpress oOracleLogin.WebButton("btnLogin")
		Wait(MID_WAIT)
		If not oOracleLogin.WebElement("OracleApplicationsHome").Exist(MID_WAIT) Then
			Call rptWriteReport("Fail", "Oracle EBS Login" , "Unable to login into Oracle EBS with UserName "&strUID)
'			Call fnReportStepALM("Oracle EBS Application Login", "Failed", "Oracle EBS Application login verification","UserName must be displayed","Oracle EBS login username is not displayed")
			Environment("ERRORFLAG") = False
			Exit Function			
		Else
			Call rptWriteReport("Pass", "Oracle EBS Login","Logged into Oracle EBS successfully with UserName "&strUID)
'			Call fnReportStepALM("Oracle EBS Application Login", "Passed", "Oracle EBS Application login verification","UserName must be displayed","Oracle EBS login username is displayed")
		End If					
	Else
		Call rptWriteReport("Fail", "Launch Oracle EBS Application","Failed to launch the Oracle EBS application")		
	End If
End Function
'******************************************************************************************************************************************************************************************************************************************
'	Function Name						:					fnOracleEBSLogin_Chrome
'	Objective							:					Used to launch / login into the Oracle EBS Application
'	Input Parameters					:					NIL
'	Output Parameters					:					NIL
'	Date Created						:					26-July-2015
'	QTP Version							:					UFT 12.0
'	QC Version							:					
'	Pre-requisites						:					NIL  
'	Created By							:					Gallop Solutions
'	Modification Date					:		   
'*****************************************************************************************************************************************************************************************************************************************		
Public Function fnOracleEBSLogin_Chrome()
	SystemUtil.CloseProcessByName("chrome.exe")
	If Environment("QAEnv1") = "YES" Then
		strURL = Environment("OracleQAURL")
		strUID = Environment("OracleQAUserID")
		strPWD = Environment("OracleQAPassword")
	ElseIf Environment("UATEnv") = "NO" Then
		strURL = Environment("OracleUATURL")
		strUID = Environment("OracleUATUserID")
		strPWD = Environment("OracleUATPassword")	
	ElseIf Environment("DXEnv") = "YES" Then
		strURL = Environment("OracleDXURL")
		strUID = Environment("OracleDXUserID")
		strPWD = Environment("OracleDXPassword")
	Else
		strURL = Environment("OracleQAURL")
		strUID = Environment("OracleQAUserID")
		strPWD = Environment("OracleQAPassword")
	End If
	SystemUtil.Run "Chrome.exe",strURL:Wait(MIN_WAIT)
	
    If oOracleLogin.WebEdit("txtUsernameField").Exist(MID_WAIT) Then
      	Call rptWriteReport("Pass", "Launch Oracle Application","Succesfully launched the application")
'		fneditset oOracleLogin.WebEdit("txtUsernameField"),Environment("OracleUserID")
		fneditset oOracleLogin.WebEdit("txtUsernameField"),strUID
'		fneditset oOracleLogin.WebEdit("txtPasswordField"),Environment("OraclePassword")
		fneditset oOracleLogin.WebEdit("txtPasswordField"),strPWD
		fnpress oOracleLogin.WebButton("btnLogin")
		Wait(MID_WAIT)
		If not oOracleLogin.WebElement("OracleApplicationsHome").Exist(MID_WAIT) Then
			Call rptWriteReport("Fail", "Oracle EBS Login" , "Unable to login into Oracle EBS with UserName "&strUID)
'			Call fnReportStepALM("Oracle EBS Application Login", "Failed", "Oracle EBS Application login verification","UserName must be displayed","Oracle EBS login username is not displayed")
			Environment("ERRORFLAG") = False
			Exit Function			
		Else
			Call rptWriteReport("Pass", "Oracle EBS Login","Logged into Oracle EBS successfully with UserName "&strUID)
'			Call fnReportStepALM("Oracle EBS Application Login", "Passed", "Oracle EBS Application login verification","UserName must be displayed","Oracle EBS login username is displayed")
		End If					
	Else
		Call rptWriteReport("Fail", "Launch Oracle EBS Application","Failed to launch the Oracle EBS application")		
	End If
End Function
'******************************************************************************************************************************************************************************************************************************************
'	Function Name						:					fnOracleEBSLoginUAT
'	Objective							:					Used to launch / login into the Oracle EBS Application with UAT Environment
'	Input Parameters					:					NIL
'	Output Parameters					:					NIL
'	Date Created						:					12-Apr-2017
'	QTP Version							:					UFT 12.0
'	QC Version							:					
'	Pre-requisites						:					NIL  
'	Created By							:					Balaji Veeravall
'	Modification Date					:		   
'*****************************************************************************************************************************************************************************************************************************************		
Public Function fnOracleEBSLoginUAT()
	SystemUtil.CloseProcessByName("iexplore.exe")
	If 	Environment("UATEnv") = "YES" Then
		strURL = Environment("OracleUATURL")
		strUID = Environment("OracleUATUserID")
		strPWD = Environment("OracleUATPassword")
	Else
		strURL = Environment("OracleQAURL")
		strUID = Environment("OracleQAUserID")
		strPWD = Environment("OracleQAPassword")
	End If
	If Environment("IEBrowser") = "YES" Then
		SystemUtil.Run "iexplore.exe",strURL	
	ElseIf Environment("ChromeBrowser") = "YES" Then
		SystemUtil.Run "Chrome.exe",strURL	
	ElseIf Environment("FireFoxBrowser") = "YES" Then
		SystemUtil.Run "firefox.exe",strURL	
	End If
	Wait(MID_WAIT)
    If oOracleLogin.WebEdit("txtUsernameField").Exist(MID_WAIT) Then
   		Call rptWriteReport("Pass", "Launch Oracle Application","Succesfully launched the application")
'		fneditset oOracleLogin.WebEdit("txtUsernameField"),Environment("OracleUserID")
		fneditset oOracleLogin.WebEdit("txtUsernameField"),strUID
'		fneditset oOracleLogin.WebEdit("txtPasswordField"),Environment("OraclePassword")
		fneditset oOracleLogin.WebEdit("txtPasswordField"),strPWD
		fnpress oOracleLogin.WebButton("btnLogin")
		If not oOracleLogin.WebElement("OracleApplicationsHome").Exist(MID_WAIT) Then
			Call rptWriteReport("Fail", "Oracle EBS Login" , "Unable to login into Oracle EBS with UserName "&strUID)
'			Call fnReportStepALM("Oracle EBS Application Login", "Failed", "Oracle EBS Application login verification","UserName must be displayed","Oracle EBS login username is not displayed")
			Environment("ERRORFLAG") = False
			Exit Function			
		Else
			Call rptWriteReport("Pass", "Oracle EBS Login","Logged into Oracle EBS successfully with UserName "&strUID)
'			Call fnReportStepALM("Oracle EBS Application Login", "Passed", "Oracle EBS Application login verification","UserName must be displayed","Oracle EBS login username is displayed")
		End If					
	Else
		Call rptWriteReport("Fail", "Launch Oracle EBS Application","Failed to launch the Oracle EBS application")		
	End If
End Function


'******************************************************************************************************************************************************************************************************************************************
'	Function Name						:					fnCMRLogin
'	Objective							:					Used to launch / login into the CMR Application
'	Input Parameters					:					NIL
'	Output Parameters					:					NIL
'	Date Created						:					18-Oct-2016
'	QTP Version							:					UFT 12.0
'	QC Version							:					ALM 11.5
'	Pre-requisites						:					NIL  
'	Created By							:					Balaji Veeravalli
'	Modification Date					:		   
'*****************************************************************************************************************************************************************************************************************************************		
Public Function fnCMRLogin()
	SystemUtil.CloseProcessByName("iexplore.exe")
		strURL = Environment("CMRURL")
		strUID = Environment("CMRUserID")
		strPWD = Environment("CMRPassword")
	    SystemUtil.Run "iexplore.exe",strURL	    
    If Browser("OracleApplicationsHome").Page("CMR").WebEdit("txtCMRUserName").Exist(MAX_WAIT) Then
    	Call rptWriteReport("Pass", "Launch CMR Application","Succesfully launched the application")
		fneditset "txtCMRUserName",strUID
		fneditset "txtCMRPassword",strPWD
		fnClick("btnLogIn")
		If not oOracleLogin.WebElement("OracleApplicationsHome").Exist(MID_WAIT) Then
			Call rptWriteReport("Fail", "CMR Login" , "Unable to login into CMR with UserName "&strUID)
			Environment("ERRORFLAG") = False
			Exit Function			
		Else
			Call rptWriteReport("Pass", "CMR Login","Logged into CMR successfully with UserName "&strUID)
		End If					
	Else
		Call rptWriteReport("Fail", "CMR Application","Failed to launch the CMR application")		
	End If
End Function
'******************************************************************************************************************************************************************************************************************************************
'	Function Name						:					fnATDOnlineLogin
'	Objective							:					Used to launch / login into the Oracle EBS Application
'	Input Parameters					:					NIL
'	Output Parameters					:					NIL
'	Date Created						:					26-July-2015
'	QTP Version							:					UFT 12.0
'	QC Version							:					
'	Pre-requisites						:					NIL  
'	Created By							:					Gallop Solutions
'	Modification Date					:		   
'*****************************************************************************************************************************************************************************************************************************************		
Public Function fnATDOnlineLogin()
	SystemUtil.CloseProcessByName("iexplore.exe")
	strURL = Environment("ATDOnlineURL")
	strUID = Environment("ATDOnlineUserID")
	strPWD = Environment("ATDOnlinePassword")	
    SystemUtil.Run "iexplore.exe",strURL
    If Browser("ATDONLINE").Page("ATDOnlineLogin").WebEdit("edtUsername").Exist(MAX_WAIT) Then
    	Call rptWriteReport("Pass", "Launch ATD Online Application","Succesfully launched the application")
		Browser("ATDONLINE").Page("ATDOnlineLogin").WebEdit("edtUsername").Set strUID
		Browser("ATDONLINE").Page("ATDOnlineLogin").WebEdit("edtPassword").Set strPWD
		Browser("ATDONLINE").Page("ATDOnlineLogin").Link("btnLogin").Click
		If not Browser("ATDONLINE").Page("ATDOnlineHomePage").Exist(MID_WAIT) Then
			Call rptWriteReport("Fail", "ATD Online Login" , "Unable to login into ATD Online with UserName "&strUID)
'			Call fnReportStepALM("Oracle EBS Application Login", "Failed", "Oracle EBS Application login verification","UserName must be displayed","Oracle EBS login username is not displayed")
			Environment("ERRORFLAG") = False
			Exit Function			
		Else
			Call rptWriteReport("Pass", "ATD Online Login","Logged into ATD Online successfully with UserName "&strUID)
'			Call fnReportStepALM("Oracle EBS Application Login", "Passed", "Oracle EBS Application login verification","UserName must be displayed","Oracle EBS login username is displayed")
		End If					
	Else
		Call rptWriteReport("Fail", "Launch ATD Online Application","Failed to launch the ATD Online application")		
	End If
End Function

'******************************************************************************************************************************************************************************************************************************************
'	Function Name						:					fnLegacyOnlineLogin
'	Objective							:					Used to launch / login into the Oracle EBS Application
'	Input Parameters					:					NIL
'	Output Parameters					:					NIL
'	Date Created						:					4-Oct-2015
'	QTP Version							:					UFT 12.0
'	QC Version							:					
'	Pre-requisites						:					NIL  
'	Created By							:					Gallop Solutions
'	Modification Date					:		   
'*****************************************************************************************************************************************************************************************************************************************		
Public Function fnLegacyOnlineLogin()
	SystemUtil.CloseProcessByName("iexplore.exe")
	strURL = Environment("LegacyURL")
	strUID = Environment("LegacyUserID")
	strPWD = Environment("LegacyPassword")	
    SystemUtil.Run "iexplore.exe",strURL
    If Browser("OracleApplicationsHome").Page("Legacy").WebEdit("edtlegacyUserid").Exist(MAX_WAIT) Then
    	Call rptWriteReport("Pass", "Launch ATD Online Application","Succesfully launched the application")
    	Browser("OracleApplicationsHome").Page("Legacy").WebEdit("edtlegacyUserid").Set strUID
		Browser("OracleApplicationsHome").Page("Legacy").WebEdit("edtLegacyPassword").Set strPWD
		Browser("OracleApplicationsHome").Page("Legacy").WebButton("btnLegacyLogin").Click
		If Browser("LegacyHome").Page("LegacyHome").WebElement("eltNoNotAtThisTime").Exist(2) Then
			Browser("LegacyHome").Page("LegacyHome").WebElement("eltNoNotAtThisTime").Click
		End If
		If not Browser("OracleApplicationsHome").Page("LegacyHome").Exist(MID_WAIT) Then
			Call rptWriteReport("Fail", "Legacy Login" , "Unable to login into Legacy with UserName "&strUID)
'			Call fnReportStepALM("Oracle EBS Application Login", "Failed", "Oracle EBS Application login verification","UserName must be displayed","Oracle EBS login username is not displayed")
			Environment("ERRORFLAG") = False
'			Exit Function			
		Else
			Call rptWriteReport("Pass", "Legacy Login","Logged into Legacy successfully with UserName "&strUID)
'			Call fnReportStepALM("Oracle EBS Application Login", "Passed", "Oracle EBS Application login verification","UserName must be displayed","Oracle EBS login username is displayed")
		End If					
	Else
		Call rptWriteReport("Fail", "Launch Legacy Application","Failed to launch the Legacy application")		
	End If
End Function


'******************************************************************************************************************************************************************************************************************************************
'	Function Name						:					fnInfoSemanticsOracleEBSLogin
'	Objective							:					Used to launch / login into the Oracle EBS Application
'	Input Parameters					:					NIL
'	Output Parameters					:					NIL
'	Date Created						:					26-July-2015
'	QTP Version							:					UFT 12.0
'	QC Version							:					
'	Pre-requisites						:					NIL  
'	Created By							:					Gallop Solutions
'	Modification Date					:		   
'******************************************************************************************************************************************************************************************************************************************		
Public Function fnInfoSemanticsOracleEBSLogin()
	SystemUtil.CloseProcessByName("iexplore.exe")
    SystemUtil.Run "iexplore.exe",Environment("InfoSemanticsOracleURL")
    If oOracleLogin.WebEdit("UsernameField").Exist(MAX_WAIT) Then
    	Call rptWriteReport("Pass", "Launch Oracle Application","Succesfully launched the application")
		fneditset oOracleLogin.WebEdit("UsernameField"),Environment("InfoSemanticsOracleUserID")
		fneditset oOracleLogin.WebEdit("PasswordField"),Environment("InfoSemanticsOraclePassword")
		fnpress oOracleLogin.WebButton("Login")
		wait(MID_WAIT)
		If not oOracleLogin.WebElement("OracleApplicationsHome").Exist(MID_WAIT) Then
			Call rptWriteReport("Fail", "Oracle EBS Login" , "Unable to login into Oracle EBS with UserName "&Environment("OracleUserID"))
			Environment("ERRORFLAG") = False
			Exit Function			
		Else
			Call rptWriteReport("Pass", "Oracle EBS Login","Logged into Oracle EBS successfully with UserName "&Environment("OracleUserID"))
		End If					
	Else
		Call rptWriteReport("Fail", "Launch Oracle EBS Application","Failed to launch the Oracle EBS application")		
	End If
End Function

''******************************************************************************************************************************************************************************************************************************************
''	Function Name							:						 		 fnNavigateToPage
''	Objective								:								 Used to Navigate To Page
''	Input Parameters						:								 sLinkName													 
''	Date Created							:								 26-jULY-2015
''	QTP Version								:								 12.0
''	QC Version								:								 QC 11 
''	Pre-requisites							:								 NIL  
''	Created By								:		   						 Gallop Solutions
''	Modification Date						:		   
''******************************************************************************************************************************************************************************************************************************************
Public Function fnNavigateToPage(sLinkName)
	wait(3)
	On error resume next
	sLinkNameArr = Split(sLinkName,"|")
	Browser("OracleApplicationsHome").Sync
	For sLinkCount = 0 To UBound(sLinkNameArr)
	    Set oDesc = Description.Create()
	    oDesc("micclass").Value = "Link"
	    oDesc("visible").Value = True
	    oDesc("html tag").Value = "A"
	    If instr(1, sLinkNameArr(sLinkCount) ,"$") > 0 Then 
	        arrProperties=Split(sLinkNameArr(sLinkCount),"$")    
	        oDesc("text").Value = arrProperties(0)                
	        oDesc("html id").Value = arrProperties(1)
	    else
	         oDesc("text").Value = sLinkNameArr(sLinkCount)
	    End if
'	    Set oPage = Browser("OracleApplicationsHome").Page("OracleApplicationsHome").ChildObjects(oDesc)
		
		Set oPage = Browser("OracleApplicationsHome").Page("Oracle Applications Home").ChildObjects(oDesc)
	    iCount = oPage.Count
	 	If iCount > 0 Then
	 		oPage(0).Highlight
	 		sName = oPage(0).Click:Wait 10
'	 		Wait 2
'			oPage(0).Click
'			Wait 2
'	 		Call fnSecurityMessage()
	 		If sLinkCount>0 Then ''Ádded by Pradeep to handle Browser Tabs
	 			Call fnSecurityMessage()
	 			Browser("CreationTime:=1").Highlight
	 		End If
	'                Wait 1
	        '*********************************Code to Handle Java update in UAT Environment by click on the "Run this Time" option      " Commented by Balaji on 20-Apr-2017
		'                If Browser("OracleApplicationsHome").WinObject("Notification").WinButton("btnRunthistime").Exist(4) Then
		'                	Browser("OracleApplicationsHome").WinObject("Notification").WinButton("btnRunthistime").Highlight
		'                	Browser("OracleApplicationsHome").WinObject("Notification").WinButton("btnRunthistime").Click
		'                	Wait 5
		'                	If Browser("OracleApplicationsHome").Page("OracleApplicationsHome").Exist(10) Then
		'                		Set oPage = Browser("OracleApplicationsHome").Page("OracleApplicationsHome").ChildObjects(oDesc)
		'                	    oPage(0).Highlight
		'                	    sName = oPage(0).Click
		'                	End If
		'                	
		'                End If
	        '*********************************Code to Handle Java update in UAT Environment by click on the "Run this Time" option 
	        
'	        Wait(MIN_WAIT)
	'				wait(10)
			
	        Call rptWriteReport("Pass", "Able to Click Link","Successfully Clicked on "&sLinkNameArr(sLinkCount))
	    Else
	        Call rptWriteReport("Fail", "Unable to Click Link","Link not avilable "&sLinkNameArr(sLinkCount)) 
	        Environment("ERRORFLAG") = False
	        Exit For
	    End If
	'            wait(4)
	Next

        ''To Sync the Form after the navigation 
'        wait(10)
       call fnWindowSync("NavigatorForm")
'       wait(MIN_WAIT)
		
End Function

''******************************************************************************************************************************************************************************************************************************************
''	Function Name							:						 		 fnNavigateToPageC
''	Objective								:								 Used to Navigate To Page
''	Input Parameters						:								 sLinkName													 
''	Date Created							:								 02-Aprl-2017
''	QTP Version								:								 12.0
''	QC Version								:								 QC 11 
''	Pre-requisites							:								 NIL  
''	Created By								:		   						 Balaji Veeravalli
''	Modification Date						:		   
''******************************************************************************************************************************************************************************************************************************************
Public Function fnNavigateToPageC(sLinkName)
wait(1)
On error resume next
     sLinkNameArr = Split(sLinkName,"|")
        For sLinkCount = 0 To UBound(sLinkNameArr)
            Set oDesc = Description.Create()
            oDesc("micclass").Value = "Link"
            oDesc("visible").Value = True
            oDesc("html tag").Value = "A"
	            If instr(1, sLinkNameArr(sLinkCount) ,"$") > 0 Then 
	                arrProperties=Split(sLinkNameArr(sLinkCount),"$")    
	                oDesc("text").Value = arrProperties(0)                
	                oDesc("html id").Value = arrProperties(1)
	            Else
	                 oDesc("text").Value = sLinkNameArr(sLinkCount)
	            End if
'		            Set oPage = Browser("OracleApplicationsHome").Page("OracleApplicationsHome").ChildObjects(oDesc)
				Set oPage = Browser("OracleApplicationsHome").Page("Oracle Applications Home").ChildObjects(oDesc)
		            iCount = oPage.Count
         	If iCount > 0 Then
         		oPage(0).Highlight
         		sName = oPage(0).Click
'         		oPage(0).Click
	                '*********************************Code to Handle Java update in UAT Environment by click on the "Run this Time" option  
			'	                If Browser("OracleApplicationsHome").WinObject("Notification").WinButton("btnRunthistime").Exist(1) Then                	
			'	                	Browser("OracleApplicationsHome").WinObject("Notification").WinButton("btnRunthistime").Click
			'	                	Wait 1
			'	                	If Browser("OracleApplicationsHome").Page("OracleApplicationsHome").Exist(10) Then
			'	                		Set oPage = Browser("OracleApplicationsHome").Page("OracleApplicationsHome").ChildObjects(oDesc)
			'	                	    oPage(0).Highlight
			'	                	    sName = oPage(0).Click
			'	                	End If                	
			'	                End If
                '*********************************Code to Handle Java update in UAT Environment by click on the "Run this Time" option 
	                wait(MIN_WAIT)
	                Call rptWriteReport("Pass", "Able to Click Link","Successfully Clicked on "&sLinkNameArr(sLinkCount))
	            Else
	                Call rptWriteReport("Fail", "Unable to Click Link","Link not avilable "&sLinkNameArr(sLinkCount)) 
	                Environment("ERRORFLAG") = False
	                Exit For
	            End If
            wait(9)
        Next
        Call fnSecurityMessage()   
		If Browser("CreationTime:=1").Exist(MIN_WAIT) Then ''Ádded by Pradeep to handle Browser Tabs
	 		Browser("CreationTime:=1").Highlight
	 	End If        
'       wait(MIN_WAIT)
End Function

''******************************************************************************************************************************************************************************************************************************************
''	Function Name							:						 		 fnNavigateToPage
''	Objective								:								 Used to Navigate To Page
''	Input Parameters						:								 sLinkName													 
''	Date Created							:								 26-jULY-2015
''	QTP Version								:								 12.0
''	QC Version								:								 QC 11 
''	Pre-requisites							:								 NIL  
''	Created By								:		   						 Gallop Solutions
''	Modification Date						:		   
''******************************************************************************************************************************************************************************************************************************************
Public Function fnNavigateToPageWithoutForm(sLinkName)
wait(3)
        sLinkNameArr = Split(sLinkName,"|")
        For sLinkCount = 0 To UBound(sLinkNameArr)
            Set oDesc = Description.Create()
            oDesc("micclass").Value = "Link"
            oDesc("visible").Value = True
            oDesc("html tag").Value = "A"
            If instr(1, sLinkNameArr(sLinkCount) ,"$") > 0 Then 
                arrProperties=Split(sLinkNameArr(sLinkCount),"$")    
                oDesc("text").Value = arrProperties(0)                
                oDesc("html id").Value = arrProperties(1)
            else
                 oDesc("text").Value = sLinkNameArr(sLinkCount)
            End if
'            Set oPage = Browser("OracleApplicationsHome").Page("OracleApplicationsHome").ChildObjects(oDesc)
            Set oPage = Browser("OracleApplicationsHome").Page("OracleApplicationsHome").ChildObjects(oDesc)
            iCount = oPage.Count
            If iCount > 0 Then
                sName = oPage(0).Click
                 '*********************************Code to Handle Java update in UAT Environment by click on the "Run this Time" option 
'                If Browser("OracleApplicationsHome").WinObject("Notification").WinButton("btnRunthistime").Exist(4) Then
'                	Browser("OracleApplicationsHome").WinObject("Notification").WinButton("btnRunthistime").Click
'                	Wait 3
'                	sName = oPage(0).Click
'                End If
                '*********************************Code to Handle Java update in UAT Environment by click on the "Run this Time" option 
                Wait(MIN_WAIT)
'				wait(10)
                Call rptWriteReport("Pass", "Able to Click Link","Successfully Clicked on "&sLinkNameArr(sLinkCount))
            Else
                Call rptWriteReport("Fail", "Unable to Click Link","Link not avilable "&sLinkNameArr(sLinkCount)) 
                Environment("ERRORFLAG") = False
                Exit For
            End If
        Next
'        Call fnSecurityMessage()

        ''To Sync the Form after the navigation 
'       wait(MIN_WAIT)
End Function

''******************************************************************************************************************************************************************************************************************************************
''	Function Name							:						 		 fnNavigateToPage
''	Objective								:								 Used to Navigate To Page
''	Input Parameters						:								 sLinkName													 
''	Date Created							:								 26-jULY-2015
''	QTP Version								:								 12.0
''	QC Version								:								 QC 11 
''	Pre-requisites							:								 NIL  
''	Created By								:		   						 Gallop Solutions
''	Modification Date						:		   
''******************************************************************************************************************************************************************************************************************************************
Public Function fnInfoSemanticsNavigateToPage(sLinkName)
        sLinkNameArr = Split(sLinkName,"|")
        For sLinkCount = 0 To UBound(sLinkNameArr)
            Set oDesc = Description.Create()
            oDesc("micclass").Value = "Link"
            oDesc("visible").Value = True
            oDesc("html tag").Value = "A"
            If instr(1, sLinkNameArr(sLinkCount) ,"$") > 0 Then 
                arrProperties=Split(sLinkNameArr(sLinkCount),"$")    
                oDesc("text").Value = arrProperties(0)            
                oDesc("width").Value = cint(arrProperties(1))
            else
                 oDesc("text").Value = sLinkNameArr(sLinkCount)
            End if
            Set oPage = Browser("OracleApplicationsHome").Page("OracleApplicationsHome").ChildObjects(oDesc)
            iCount = oPage.Count
            If iCount > 0 Then
                sName = oPage(0).Click
                Wait(MID_WAIT)
                Call rptWriteReport("Pass", "Able to Click Link","Successfully Clicked on "&sLinkNameArr(sLinkCount))
            Else
                Call rptWriteReport("Fail", "Unable to Click Link","Link not avilable "&sLinkNameArr(sLinkCount)) 
                Environment("ERRORFLAG") = False
                Exit For
            End If
        Next
        ''To Sync the Form after the navigation 
'        call fnWindowSync("NavigatorForm")
End Function
'******************************************************************************************************************************************************************************************************************************************
'	Function Name							:						  		fnWindowSync
'	Objective								:							 	Used to Wait for the Window Process to complete
'	Input Parameters						:							  	ObjControl
'	Output Parameters						:							   	NIL
'	Date Created							:								26-Aug-2015
'	QTP Version								:								12.0
'	QC Version								:								
'	Pre-requisites							:								NIL  
'	Created By								:								Gallop Solutions
'	Modification Date						:		   
'******************************************************************************************************************************************************************************************************************************************
Public Function fnWindowSync(sObjectName)
flag=0
		
		iWait = 0
		If Not IsObject(sObjectName) Then
			Set RefObject=Eval(fnGetObjectHierarchy(sObjectName)) 
		Else
			Set RefObject = sObjectName			 
		End If
		Do While(iWait<15)
			Do
				If RefObject.Exist(MIN_WAIT) Then
					Call rptWriteReport("Pass", sObjectName, sObjectName&" is displayed successfully")
					flag=1
					Exit do
					 
				else
'					If oOracleLogin.Link("Home").Exist(MIN_WAIT) Then
'						flag=1
'						Wait(MIN_WAIT)
'						Exit do
'					Else
						iWait =iWait + 1		
'					End If						
				End If	
			Loop Until  RefObject.Exist(MIN_WAIT)
			If flag=1 Then
				Exit do
			End If
		Loop
End Function

'***************************************************************************************************************************
'	Function Name					:				fnGetRowCount
'	Objective						:				Used to get the rowcount with Run ' 'Y' from Excel sheet
'	Input Parameters				:				sFileName
'	Output Parameters				:				RowCount
'	Date Created					:				26-July-2015
'	QTP Version						:				12.0
'	QC Version						:				QC 11 
'	Pre-requisites					:				NIL  
'	Created By						:				Gallop Solutions
'	Modification Date				:		   
'*****************************************************************************************************************************
Public Function fnGetRowCount(sSheetName)  
call fn_DownloadResourcesFromALM
		sFileName = Environment("TestName")&"_Testdata.xls"
		''sFile = fnGetFolderAttachmentPath(Environment("QCProjectPath"),sFileName)  'Commented by Narendra
		sFile = fnDownloadDataFile()		
		sItemName = sSheetName
			
		'sFile = "C:\Temp\FS_ProcureToPay_Testdata.xls"
		Set DB_CONNECTION=CreateObject("ADODB.Connection")
		DB_CONNECTION.Open "DBQ="&sFile&";DefaultDir=C:\;Driver={Driver do Microsoft Excel(*.xls)};DriverId=790;FIL=excel 8.0;FILEDSN=C:\Program Files\Common Files\ODBC\Data Sources\matdsn2.dsn;MaxScanRows=8;PageTimeout=5;ReadOnly=0;SafeTransactions=0;Threads=3;UID=admin;UserCommitSync=Yes;"
		iCheck = Instr(1,sItemName,"$")
		If iCheck = 0 Then
			sItemName = sItemName&"$"
		End If
		sQuery =  "SELECT Count(*) FROM ["&sItemName&"] WHERE Run = 'Y'"
		set Record_Set1=DB_CONNECTION.Execute(sQuery)
		iRowCountValue = 0

		Do While Not Record_Set1.EOF
				For Each Element In Record_Set1.Fields
						iRowCount = Record_Set1(iRowCountValue)
				Next
				Record_Set1.MoveNext
		Loop
		Record_Set1.Close
		Set Record_Set1=Nothing
		DB_CONNECTION.Close
		Set DB_CONNECTION=Nothing
        fnGetRowCount = iRowCount

End Function
'**************************Code for using single data sheet for different scripts. Need to add extra parameter 'sFileName' *************************************
'''''Public Function fnGetRowCount(sFileName,sSheetName)  
'''''call fn_DownloadResourcesFromALM
'''''		sFileName = "ProcureToPay.xls"
'''''		sFile = fnGetFolderAttachmentPath(Environment("QCProjectPath"),sFileName)  'Commented by Narendra
'''''		sItemName = sSheetName
'''''			
'''''		'sFile = "C:\Temp\FS_ProcureToPay_Testdata.xls"
'''''		Set DB_CONNECTION=CreateObject("ADODB.Connection")
'''''		DB_CONNECTION.Open "DBQ="&sFile&";DefaultDir=C:\;Driver={Driver do Microsoft Excel(*.xls)};DriverId=790;FIL=excel 8.0;FILEDSN=C:\Program Files\Common Files\ODBC\Data Sources\matdsn2.dsn;MaxScanRows=8;PageTimeout=5;ReadOnly=0;SafeTransactions=0;Threads=3;UID=admin;UserCommitSync=Yes;"
'''''		iCheck = Instr(1,sItemName,"$")
'''''		If iCheck = 0 Then
'''''			sItemName = sItemName&"$"
'''''		End If
'''''		sQuery =  "SELECT Count(*) FROM ["&sItemName&"] WHERE Run = 'Y'"
'''''		set Record_Set1=DB_CONNECTION.Execute(sQuery)
'''''		iRowCountValue = 0
'''''
'''''		Do While Not Record_Set1.EOF
'''''				For Each Element In Record_Set1.Fields
'''''						iRowCount = Record_Set1(iRowCountValue)
'''''				Next
'''''				Record_Set1.MoveNext
'''''		Loop
'''''		Record_Set1.Close
'''''		Set Record_Set1=Nothing
'''''		DB_CONNECTION.Close
'''''		Set DB_CONNECTION=Nothing
'''''        fnGetRowCount = iRowCount
'''''
'''''End Function
'******************************************************************************************************************************************************************************************************************************************
'	Function Name						:						 fnGetTestData
'	Objective							:						 Used to get the testdata with Run ' 'Y' from Excel or MS Access into Dictonary Object
'	Input Parameters					:						 sItemName
'	Output Parameters					:						 Enter test data in the file into Dictonary Object
'	Date Created						:						 26-July-2015
'	QTP Version							:						 12.0
'	QC Version							:						 QC 11
'	Pre-requisites						:						 NIL  
'	Created By							:						 Gallop Solutions
'	Modification Date					:		   
'******************************************************************************************************************************************************************************************************************************************

Public Function fnGetTestData(sItemName)
'''''	sFile = fnGetFolderAttachmentPath(Environment("QCProjectPath"),sFileName)  ' Commented by Narendra
'	sFile = strProjectTestdataPath&Environment("TestName")&"_Testdata.xls"
'	sFile = "C:\Temp\FS_ProcureToPay_Testdata.xls"
		
	Set Data = CreateObject("Scripting.Dictionary")
	Data.RemoveAll
		
	iCheck = Instr(1,sItemName,"$")
	If iCheck = 0 Then
			sItemName = sItemName&"$"
	End If

	sQuery =  "SELECT * FROM ["&sItemName&"] Where Run = 'Y'"
	Set DB_CONNECTION=CreateObject("ADODB.Connection")
	
	DB_CONNECTION.Open "DBQ="&sFile&";DefaultDir=C:\;Driver={Driver do Microsoft Excel(*.xls)};DriverId=790;FIL=excel 8.0;FILEDSN=C:\Program Files\Common Files\ODBC\Data Sources\matdsn2.dsn;MaxScanRows=8;PageTimeout=5;ReadOnly=0;SafeTransactions=0;Threads=3;UID=admin;UserCommitSync=Yes;"

	Set Record_Set1=DB_CONNECTION.Execute(sQuery)
	Set Record_Set2=DB_CONNECTION.Execute(sQuery)

	iRowCount = 0

	Do While Not Record_Set2.EOF
		iColumnCount = 0
		For Each Field In Record_Set1.Fields
			sColumnName = Field.Name& (iRowCount + 1)
			iRowValue = Record_Set2(iColumnCount)
			If IsNull(iRowValue) Then
				iRowValue = ""
			End If
			Data.Add sColumnName,iRowValue
		iColumnCount = iColumnCount + 1
		Next
		Record_Set2.MoveNext
		iRowCount = iRowCount + 1
	Loop

	Record_Set1.Close
	Set Record_Set1=Nothing
	Record_Set2.Close
	Set Record_Set2=Nothing
	DB_CONNECTION.Close
	Set DB_CONNECTION=Nothing
	Set fnGetTestData = Data	

End Function

'******************************************************************************************************************************************************************************************************************************************
'	Sub Name		 					:					fnSynUntilFieldExists
'	Objective							:					Function wait until field exists from SystemZ & Telnet
'	Input Parameters					:					gfString, intWait
'	Output Parameters					:					NIL
'	Date Created						:					04-April-2017
'	QTP Version							:					UFT 12.0
'	QC Version							:					
'	Pre-requisites						:					NILL  
'	Created By							:					Balaji Veeravalli
'	Modification Date					:	
'****************************************************************************************************************************************************************************************************************************************** 
'Public Function fnSynUntilFieldExists(gfString,intWait)
'On error resume next
'Set objFSO = createobject("Scripting.filesystemobject")
'	set objFile = objFSO.OpenTextFile(StrFrameWorkFolder&"\Resources\Log.txt")
'	strData = objFile.ReadAll	
'	gWait=0
'	Do Until(Instr(strData,gfString)>0 or gWait=intWait)
'		gWait=gWait+1
'	Loop
'	wait 2
'On error goto 0
'set objFile =Nothing
'Set objFSO= Nothing
'End Function

Public Function fnSynUntilFieldExists(gfString,intWait)
On error resume next
Set objFSO = createobject("Scripting.filesystemobject")
	set objFile = objFSO.OpenTextFile(StrFrameWorkFolder&"\Resources\Log.txt")
	strData = objFile.ReadAll	
	gWait=0
	Do 
	wait 1
		gWait=gWait+1
	Loop Until(Instr(strData,gfString)>0 or gWait=intWait)
	wait 2
On error goto 0
set objFile =Nothing
Set objFSO= Nothing
End Function

'******************************************************************************************************************************************************************************************************************************************
'	Sub Name		 					:					fnSynUntilObjExists
'	Objective							:					Function wait until object exists from SystemZ & Telnet
'	Input Parameters					:					gfString, intWait
'	Output Parameters					:					NIL
'	Date Created						:					04-April-2017
'	QTP Version							:					UFT 12.0
'	QC Version							:					
'	Pre-requisites						:					NILL  
'	Created By							:					Balaji Veeravalli
'	Modification Date					:	
'****************************************************************************************************************************************************************************************************************************************** 
Public Function fnSynUntilObjExists(objControl,intWait)
	Dim blnFound,RefObject,gWait
	On error resume next
	blnFound=False
	gWait=0	
	If Not IsObject(objControl) Then''''Condition for Object Reference. Added by Pradeep on 19-Apr-2017
		Set RefObject=Eval(fnGetObjectHierarchy(objControl)) 
	Else
		Set RefObject = objControl	
	End If	
	Do 
		wait 1
		gWait=gWait+1
		If RefObject.Exist Then blnFound=True''''Condition to object exist. Added by Pradeep on 19-Apr-2017	
	Loop Until(RefObject.Exist or gWait=intWait)	
		If blnFound=False Then''''Condition to report, if object not found. Added by Pradeep on 19-Apr-2017
			rptWriteReport "WARNING", "Dynamic Wait-fnSynUntilObjExists" , RefObject.toString&" --object not found"
		End If	
	fnSynUntilObjExists=blnFound
	Set RefObject=Nothing
	On error goto 0
	
End Function

'******************************************************************************************************************************************************************************************************************************************
''	Function Name					:				fnEnterText
''	Objective						:				Used to Enter a Text/Value into Edit Box 
''	Input Parameters				:				Object Name,strValue
''	Output Parameters			    :				Nil
''	Date Created					:				30/07/2015
''	QTP Version						:				12.0
''	Pre-requisites					:				NIL  
''	Created By						:				Gallop Solutions
''	Modification Date		        :		   		30/07/2015
'******************************************************************************************************************************************************************************************************************************************
Public Function fnEnterText(sObjectName,strValue)
On Error Resume Next
fnEnterText=False
If Len(Trim(strValue))<>0 Then	
    ''Return boolean Value Flase to the Called block
    
	If Not IsObject(sObjectName) Then
		Set RefObject=Eval(fnGetObjectHierarchy(sObjectName)) 
	Else
		Set RefObject = sObjectName	
	End If
	If IsObject(strValue) Then
		Set strValue=Nothing
		strValue=""
	End If
	RefObject.RefreshObject
	If RefObject.Exist(MID_WAIT) Then
        If RefObject.GetRoProperty("enabled") = True OR RefObject.GetRoProperty("disabled") = 0 Then
        	RefObject.highlight
			Select Case RefObject.GetRoProperty("micclass")
				
				Case "OracleTextField"
				    RefObject.Enter strValue
					fnEnterText = True
					Call rptWriteReport("Pass", sObjectName,strValue&" is enterd into " &sObjectName)
'						Call fnReportStepALM(sObjectName, "Passed", "Enter "&strValue&" into "&sObjectName, strValue&" value should be entered",strValue&" value is entered in "&sObjectName)
				Case "WinEdit"
					RefObject.Set strValue
					fnEnterText = True
					Call rptWriteReport("Pass", sObjectName,strValue&" is enterd into " &sObjectName)
					
				Case "WebEdit"
					RefObject.Set strValue
					fnEnterText = True
					Call rptWriteReport("Pass", sObjectName,strValue&" is enterd into " &sObjectName)	
             End Select
		Else 
			Call rptWriteReport("Fail", sObjectName,strValue&" not entered as the field " &sObjectName &" is Exist but not enabled")
		    Exit Function
	    End If
	Else
		Call rptWriteReport("Fail", sObjectName,strValue&" not entered as the field " &sObjectName &" does not exit")
		Exit Function
	End If
End If
fnEnterText=True
On Error GOTO 0
End Function   

''******************************************************************************************************************************************************************************************************************************************
''	Function Name				    :				    fnSelect
''	Objective						:					This function is used to select an item from either a List, Navigation bar, Radio button or Tab
''	Input Parameters				:					sObjectName,strItem
''	Output Parameters			    :					Nil
''	Date Created					:					20/04/2015
''	QTP Version						:					12.0
''	QC Version						:					NIL
''	Pre-requisites					:					NIL  
''	Created By						:					Gallop Solutions
''	Modification Date		        :		   			20/04/2015
''******************************************************************************************************************************************************************************************************************************************
Function fnSelect(sObjectName,strItem)
On Error Resume Next
   ''Initially Assigning block to False
	fnSelect=False
	If Len(strItem)<>0 Then
		If Not IsObject(sObjectName) Then
			Set RefObject=Eval(fnGetObjectHierarchy(sObjectName)) 
			
		Else
			Set RefObject = sObjectName
				 
		End If
        RefObject.RefreshObject
		If RefObject.Exist(MID_WAIT) Then
            If RefObject.GetRoProperty("visible") = True OR RefObject.GetRoProperty("disabled") = 1 OR RefObject.GetRoProperty("enabled") = True Then
				Select Case RefObject.GetRoProperty("micclass")          
					Case "OracleList"
						RefObject.Select strItem
						Wait(MIN_WAIT)
						Call rptWriteReport("Pass", sObjectName,strItem&" Item is selected in "&sObjectName)   
'						Call fnReportStepALM(sObjectName, "Passed", "Select "&strValue&" from "&sObjectName, strValue&" value should be selected",strValue&" value is selected from "&sObjectName)
					Case "OracleListOfValues"
						RefObject.Select strItem
						Wait(MIN_WAIT)
						Call rptWriteReport("Pass", sObjectName,strItem&" Item is selected in "&sObjectName)  
'						Call fnReportStepALM(sObjectName, "Passed", "Select "&strValue&" from "&sObjectName, strValue&" value should be selected",strValue&" value is selected from "&sObjectName)
					Case "OracleTabbedRegion"
						RefObject.Select
						Wait(MIN_WAIT)
						Call rptWriteReport("Pass", sObjectName,strItem&" Item is selected in "&sObjectName)  
'						Call fnReportStepALM(sObjectName, "Passed", "Select "&strValue&" from "&sObjectName, strValue&" value should be selected",strValue&" value is selected from "&sObjectName)
					Case "OracleCheckbox"
						RefObject.Select
						Wait(MIN_WAIT)
						Call rptWriteReport("Pass", sObjectName,sObjectName&" "&strItem&"  is selected")
'						Call fnReportStepALM(sObjectName, "Passed", "Select "&strValue&" from "&sObjectName, strValue&" value should be selected",strValue&" value is selected from "&sObjectName)
						
						
					Case "OracleRadioGroup"
						RefObject.Select strItem
						Wait(MIN_WAIT)
						Call rptWriteReport("Pass", sObjectName,sObjectName&" "&strItem&"  Radio Button is selected")
'						Call fnReportStepALM(sObjectName, "Passed", "Select "&strValue&" from "&sObjectName, strValue&" value should be selected",strValue&" value is selected from "&sObjectName)
		
					Case "WebList"
						RefObject.Select strItem
						Wait(MIN_WAIT)
						Call rptWriteReport("Pass", sObjectName,strItem&" Item is selected in "&sObjectName)
					
					
					Case "WebRadioGroup"
					    Wait(MIN_WAIT)
						RefObject.Select strItem
						Wait(MIN_WAIT)
						Call rptWriteReport("Pass", sObjectName,sObjectName&" "&strItem&"  Radio Button is selected")
										                    
                  End Select 
                ''Return boolean Value True to the Called block
				fnSelect = True
			Else
				Call rptWriteReport("Fail", sObjectName &" : " &strItem,sObjectName &" is disabled")
				Environment("ERRORFLAG")=False
                
			   Exit Function
			End If
		Else
			Call rptWriteReport("Fail", sObjectName &" : " &strItem,sObjectName &" does not exit")
			Environment("ERRORFLAG")=False
			Exit Function
		End If	
	Else
    ''Return boolean Value True to the Called block
	fnSelect = True
	End If
	On Error GOTO 0
End Function  

''******************************************************************************************************************************************************************************************************************************************
''	Function Name					:				fnClick
''	Objective						:				Used to Click an object in form
''	Input Parameters				:				Object Name
''	Output Parameters			    :				Nil
''	Date Created					:				29/07/2015
''	QTP Version						:				12.0
''	Pre-requisites					:				NIL  
''	Created By						:				Gallop Solutions
''	Modification Date		        :		   		29/07/2015
''******************************************************************************************************************************************************************************************************************************************
Public Function fnClick(sObjectName)
'Initially Assigning to False
   Reporter.Filter=3
   On Error Resume Next
	fnClick=False
	If Not IsObject(sObjectName) Then
		Set RefObject=Eval(fnGetObjectHierarchy(sObjectName)) 
		'ExitTestIteration
	Else
		Set RefObject = sObjectName
	End If
	RefObject.RefreshObject 
	If RefObject.Exist(MID_WAIT) Then
		If RefObject.GetRoProperty("enabled") = True OR RefObject.GetRoProperty("disabled") = 0 Then	
			RefObject.Click
			fnClick = True
			Call rptWriteReport("Pass", sObjectName, "Click operation is performed on " &sObjectName)
'			Call fnReportStepALM(sObjectName, "Passed", "Click "&sObjectName, sObjectName&" should be clicked", sObjectName&" is clicked")
			Exit Function
	    End If
	    Reporter.Filter=0
   Else
   	   Call rptWriteReport("Fail", sObjectName, "Click operation is not performed on" &sObjectName &" object is disabled")
'   	   Call fnReportStepALM(sObjectName, "Failed", "Click "&sObjectName, sObjectName&" should be clicked", sObjectName&" is not clicked")
       Environment("ERRORFLAG") = False
       Exit Function
   End If
   On Error Goto 0
End Function

''******************************************************************************************************************************************************************************************************************************************
''	Function Name					:				    fnEnterTextInCell
''	Objective						:					Used to Enter a Text/Value into Edit Box in AUT
''	Input Parameters				:					sObjectName,strRow,strCol,strText
''	Output Parameters			    :					Nil
''	Date Created					:					20/04/2015
''	QTP Version						:				    12.0
''	QC Version						:				    QC 11.5
''	Pre-requisites					:					NIL  
''	Created By						:					Gallop Solutions
''	Modification Date		        :		   			20/04/2015
''******************************************************************************************************************************************************************************************************************************************
Function fnEnterTextInCell(sObjectName,strRow,strCol,strText)
On Error Resume Next
	If Len(Trim(strText))<>0 Then
		If Not IsObject(sObjectName) Then
			Set RefObject=Eval(fnGetObjectHierarchy(sObjectName)) 
			
		Else
			Set RefObject = sObjectName	
			 
		End If
        RefObject.RefreshObject
		If RefObject.Exist(MID_WAIT) Then
            If RefObject.GetRoProperty("enabled") = True or GetRoProperty("visible") = True Then
				Select Case RefObject.GetRoProperty("micclass")
						Case "OracleTable"							
							RefObject.EnterField Cint(strRow),strCol, Cstr(strText)
							Call rptWriteReport("Pass", sObjectName,strText&" is enterd into " &sObjectName)
						Case "WebTable"							
							RefObject.Set Cint(strRow),strCol, Cstr(strText)
							Call rptWriteReport("Pass", sObjectName,strText&" is enterd into " &sObjectName)	
				End Select                 ''Return boolean Value True to the Called block
				fnEnterTextInCell= True
			Else
				Call rptWriteReport("Fail", sObjectName,strValue &" not entered as the field " &sObjectName &" is Exist but not enabled")
'				Call fnReportStepALMgg()
               
			   Exit Function
			End If
		Else
			Call rptWriteReport("Fail", sObjectName,strValue &" not entered as the field " &sObjectName &" does not exit")
			Call fnReportStepALMgg()
			Exit Function
		End If
	Else
    ''Return boolean Value True to the Called block
		fnEnterTextInCell=True
End If
On Error GOTO 0
End Function

''******************************************************************************************************************************************************************************************************************************************
''	Function Name					:				  fnSelectinTable
''	Objective						:				  Used to Enter a Text/Value into Edit Box in AUT
''	Input Parameters				:				  Object Name,,strRow,strCol
''	Output Parameters			    :				  Nil
''	Date Created					:				  20/04/2015
''	QTP Version						:				  12.0
''	QC Version						:				  QC 11.5
''	Pre-requisites					:				  NIL  
''	Created By						:				  Gallop Solutions
''	Modification Date		        :		   		  20/04/2015
''******************************************************************************************************************************************************************************************************************************************
Function fnSelectinTable(sObjectName,strRow,strCol)
		If Not IsObject(sObjectName) Then
			Set RefObject=Eval(fnGetObjectHierarchy(sObjectName)) 
			
		Else
			Set RefObject = sObjectName	
			 
		End If
		If RefObject.Exist(MID_WAIT) Then
            If RefObject.GetRoProperty("enabled") = True Then
				Select Case RefObject.GetRoProperty("micclass")
     				Case "OracleTable"
						If Len(strCol) = 0 Then
							RefObject.SetFocus  Cint(strRow)	
                            fnSelectaRow= True
						End If
						If Len(strRow) = 0 Then
							RefObject.SetFocus  strCol	
                             fnSelectaRow= True
						End If
						If Len(strCol) > 0 AND Len(strRow) > 0 Then
							RefObject.SetFocus Cint(strRow), strCol
                            fnSelectaRow= True
                            Call rptWriteReport("Pass", sObjectName,sObjectName&" "&strRow&" row "&strCol&" column is selected") 
						End If
				  End Select 
			Else
				  Call rptWriteReport("Fail", sObjectName,sObjectName&" "&strRow&" row "&strCol&" column could not be Selected as the object exit but not enabled") 
             
				  Exit Function
		    End If
			Else
				Call rptWriteReport("Fail", sObjectName,sObjectName&" "&strRow&" row "&strCol&" column could not be Selected as the object does not exit") 
			
			Exit Function
		End If
End Function

''******************************************************************************************************************************************************************************************************************************************
''	Function Name					:				    fnGetCelldata
''	Objective						:					Used to Enter a Text/Value into Edit Box in AUT
''	Input Parameters				:					Object Name,InputValue
''	Output Parameters			    :					Nil
''	Date Created					:					21/04/2015
''	QTP Version						:					12.0
''	QC Version						:					QC 11.5
''	Pre-requisites					:					NIL  
''	Created By						:					Gallop Solutions
''	Modification Date		        :		   			21/04/2015
''******************************************************************************************************************************************************************************************************************************************
Function fnGetCelldata(sObjectName,iRow,iCol)
	If Not IsObject(sObjectName) Then
		Set RefObject=Eval(fnGetObjectHierarchy(sObjectName)) 
		
	Else
		Set RefObject = sObjectName	
		 
	End If
    ''Initially Assigning block to False
	fnGetCelldata=False
    RefObject.RefreshObject
	If RefObject.Exist(MID_WAIT) Then
        If RefObject.GetRoProperty("enabled") = True OR RefObject.GetRoProperty("visible") = True Then
			Select Case RefObject.GetRoProperty("micclass")			
				Case "OracleTable"
					fnGetCelldata = RefObject.GetFieldValue(Cint(iRow),Cint(iCol))
					Call rptWriteReport("PASSWITHSCREENSHOT", sObjectName,sObjectName&" retrieved value is "&fnGetCelldata)
				Case "WebTable"
					fnGetCelldata = RefObject.GetCellData(Cint(iRow),Cint(iCol))
					Call rptWriteReport("PASSWITHSCREENSHOT", sObjectName,sObjectName&" retrieved value is "&fnGetCelldata)
			End select
		Else
            Call  rptWriteReport("Fail", sObjectName,sObjectName&" retrieved value is "&fnGetCelldata&"The value could not be Fetched as the object exit but not enabled")
		    Exit Function
		End If
		Else
		    Call  rptWriteReport("Fail", sObjectName,sObjectName&" retrieved value is "&fnGetCelldata&"The value could not be Fetched as the object does not exit")
		    Exit Function
	End If
End Function
''###############################################################################################
''Function Name							:			fnGetProperty
''Objective								:		 	Used to retrive the property value of the given object
''Input Parameters						:			sObjectName,sPropertyName
''Output Parameters					    :			Nil
''Date Created							:			21/04/2015
''QTP Version							:			11.0
''QC Version							:		  	QC 11.5
''Pre-requisites						:			NIL  
''Created By							:			Gallop Solutions
''	Modification Date		            :		   	21/04/2015	   
''###############################################################################################
Function fnGetProperty(sObjectName,sPropertyName)
   If Not IsObject(sObjectName) Then
	   Set RefObject=Eval(fnGetObjectHierarchy(sObjectName)) 
	   
   Else
		Set RefObject = sObjectName		 
   End If
   ''Return boolean Value Flase to the Called block
	fnGetProperty=False
	If RefObject.Exist(MID_WAIT) Then
		fnGetProperty=RefObject.GetRoProperty(sPropertyName)
		sValue = RefObject.GetRoProperty(sPropertyName) '' Retrvied for report PASSWITHSCREENSHOT
		Call rptWriteReport("PASSWITHSCREENSHOT", sObjectName,sObjectName&" retrieved value is "&sValue)
		
	else
		Call rptWriteReport("Fail", sObjectName,sObjectName&" retrieved value is "&sValue) 
	End If
End Function

''###############################################################################################
''Function Name							:			fnVerifyProperty
''Objective								:		 	Used to verify the property value of the given object
''Input Parameters						:			sObjectName,sPropertyName
''Output Parameters					    :			Nil
''Date Created							:			11-07-2016
''QTP Version							:			11.0
''QC Version							:		  	QC 11.5
''Pre-requisites						:			NIL  
''Created By							:			Gallop Solutions
''	Modification Date		            :		   		   
''###############################################################################################
Function fnVerifyProperty(sObjectName,sPropertyName,sValue)
   If Not IsObject(sObjectName) Then
	   Set RefObject=Eval(fnGetObjectHierarchy(sObjectName)) 
	   
   Else
		Set RefObject = sObjectName		 
   End If
   
	If RefObject.Exist(MID_WAIT) Then
		text=RefObject.GetRoProperty(sPropertyName)
	End If
		
	If Trim(sValue)=Trim(text) Then
         Call rptWriteReport("PASSWITHSCREENSHOT",sObjectName,"Value is Retrieved and the Value is " &sValue)
         Call fnReportStepALM("Check value","Passed","Verify property","Property value should be"&sValue,"Verified Property value is"&sValue)
   	Else
   	  	 Call fnReportStepALM("Check value","Failed","Verify property","Property value should be"&sValue,"Verified Property value is not "&sValue)
         Call rptWriteReport("Fail",sObjectName,"Value is Retrieved and the Value is " &sValue)	
    End If
End Function


Function sthe(strg)
  Dim a : a = sgar(strg)
  Dim i
  For i = 0 To UBound(a)
      a(i) = Right(00 & Hex(Asc(a(i))), 2)
  Next
  sthe = Join(a)
End Function


''******************************************************************************************************************************************************************************************************************************************
''	Function Name					:				    fnGetObjectHierarchy
''	Objective						:					Used to get the Object Hierarchy
''	Input Parameters				:					sObjectName
''	Output Parameters			    :					Nil
''	Date Created					:					21/04/2015
''	QTP Version						:					12.0
''	QC Version						:					QC 11.5
''	Pre-requisites					:					NIL  
''	Created By						:					Gallop Solutions
''	Modification Date		        :		   			
''**********************************************************************************************************
Function fnGetObjectHierarchy(sObjectName)
   On Error Resume Next
   ''Declaring all Used Variables
	Dim strObjHigherarchy
	Set oXML=CreateObject("Microsoft.XMLDOM")
	oXML.async = False
    val=Environment.Value("ActionName")
    If left(val,2)="HR" Then
    oXML.load str_ORHRXMLPath
    ElseIf Left(val,3) = "SCN" then
	oXML.load str_ORFSXMLPath
     ElseIf Left(val,2) = "PO" then
	oXML.load str_ORHRXMLPath
	ElseIf Left(val,3) = "SCM" then
	oXML.load str_ORFSXMLPath
	ElseIf left(val,2)="FS" Or left(val,2)="EE" or left(val,2)="CP" Then
    oXML.load str_ORFSXMLPath
    ElseIf left(val,3)="ATD" Then
    oXML.load str_ORQAPerfXMLPath
    End if
        
    Set oItems=oXML.selectnodes("//qtpRep:Object[@Name="& "'"&sObjectName &"']")
	strObjHigherarchy=oItems(0).attributes(0).Value & "(" &             Chr(34) & oItems(0).attributes(1).Value & Chr(34) & ")"
	If Err.Number<>0 Then
		Print "------------------"
		Print "Function= fnGetObjectHierarchy (Global.vbs)"
		Print "Scenario="&Environment("TestName")
		Print "Component="&strTestCaseNames
		Print "Object not found in the OR xml = "&sObjectName
		Print "------------------"
	End If
	Set oParent=oItems(0).parentNode.parentNode
	Do 
		strObjHigherarchy=oParent.attributes(0).Value & "(" & Chr(34) & oParent.attributes(1).Value & Chr(34) & ")." & strObjHigherarchy
		Set oParent=oParent.parentNode.parentNode
	Loop Until oParent.nodename="qtpRep:ObjectRepository"

	fnGetObjectHierarchy=strObjHigherarchy
	Set oXML = Nothing
	On Error Goto 0
End Function

''******************************************************************************************************************************************************************************************************************************************
''	Function Name					:				    fnFindJournalsfieldsValidation
''	Objective						:					Validating each field in the Find Journal window
''	Input Parameters				:					sObjectName
''	Output Parameters			    :					Nil
''	Date Created					:					29/06/2017
''	QTP Version						:					12.0
''	QC Version						:					QC 11.5
''	Pre-requisites					:					NIL  
''	Created By						:					Gallop Solutions
''	Modification Date		        :		   			
''**********************************************************************************************************

Public Function fnFindJournalsfieldsValidation()
If OracleFormWindow("FindJournals").OracleTextField("JournalRetBatch").Exist(2) Then
	OracleFormWindow("FindJournals").OracleTextField("JournalRetBatch").Highlight
	Call fnReportStepALM("Journal Batch", "Passed", "Journal Batch Object verification", "Journal Batch should be display","Journal Batch is displayed")
	Call rptWriteReport("PASSWITHSCREENSHOT", "Journal Batch Object verification" , "Journal Batch is displayed")
Else
	Call fnReportStepALM("Journal Batch", "Failed", "Journal Batch Object verification", "Journal Batch should be display","Journal Batch is NOT displayed")
	Call rptWriteReport("Fail", "Journal Batch Object verification" , "JJournal Batch is not displayed")
	ExitRun
End If

If OracleFormWindow("FindJournals").OracleTextField("JournalNameEntry").Exist(2) Then
	OracleFormWindow("FindJournals").OracleTextField("JournalNameEntry").Highlight
	Call fnReportStepALM("Journal Name Entry", "Passed", "Journal Name Entry Object verification", "Journal Name Entry should be display","Journal Name Entry is displayed")
Else
	Call fnReportStepALM("Journal Name Entry", "Failed", "Journal Name Entry Object verification", "Journal Name Entry should be display","Journal Name Entry is NOT displayed")
	ExitRun
End If

If OracleFormWindow("FindJournals").OracleTextField("JouLedger").Exist(2) Then
	OracleFormWindow("FindJournals").OracleTextField("JouLedger").Highlight
	Call fnReportStepALM("Ledger", "Passed", "Ledger Object verification", "Ledger should be display","Ledger is displayed")
Else
	Call fnReportStepALM("Ledger", "Failed", "Ledger Object verification", "Ledger should be display","Ledger is NOT displayed")
	ExitRun
End If

If OracleFormWindow("FindJournals").OracleTextField("txtJournalSource").Exist(2) Then
	OracleFormWindow("FindJournals").OracleTextField("txtJournalSource").Highlight
	Call fnReportStepALM("Source", "Passed", "Source Object verification", "Source should be display","Source is displayed")
Else
	Call fnReportStepALM("Source", "Failed", "Source Object verification", "Source should be display","Source is NOT displayed")
	ExitRun
End If

If OracleFormWindow("FindJournals").OracleTextField("JouCategory").Exist(2) Then
	OracleFormWindow("FindJournals").OracleTextField("JouCategory").Highlight
	Call fnReportStepALM("Category", "Passed", "Category Object verification", "Category should be display","Category is displayed")
Else
	Call fnReportStepALM("Category", "Failed", "Category Object verification", "Category should be display","Category is NOT displayed")
	ExitRun
End If

If OracleFormWindow("FindJournals").OracleTextField("PeriodEntry").Exist(2) Then
	OracleFormWindow("FindJournals").OracleTextField("PeriodEntry").Highlight
	Call fnReportStepALM("Period Entry", "Passed", "Period Entry Object verification", "Period Entry should be display","Period Entry is displayed")
Else
	Call fnReportStepALM("Period Entry", "Failed", "Period Entry Object verification", "Period Entry should be display","Period Entry is NOT displayed")
	ExitRun
End If

If OracleFormWindow("FindJournals").OracleTextField("txtCurrency").Exist(2) Then
	OracleFormWindow("FindJournals").OracleTextField("txtCurrency").Highlight
	Call fnReportStepALM("Currency", "Passed", "Currency Object verification", "Currency should be display","Currency is displayed")
Else
	Call fnReportStepALM("Currency", "Failed", "Currency Object verification", "Currency should be display","Currency is NOT displayed")
	ExitRun
End If

If OracleFormWindow("FindJournals").OracleTextField("JouStatusPosting").Exist(2) Then
	OracleFormWindow("FindJournals").OracleTextField("JouStatusPosting").Highlight
	Call fnReportStepALM("Status Posting", "Passed", "Status Posting Object verification", "Status Posting should be display","JStatus Posting is displayed")
Else
	Call fnReportStepALM("Status Posting", "Failed", "Status Posting Object verification", "Status Posting should be display","Status Posting is NOT displayed")
	ExitRun
End If

If OracleFormWindow("FindJournals").OracleTextField("Reference").Exist(2) Then
	OracleFormWindow("FindJournals").OracleTextField("Reference").Highlight
	Call fnReportStepALM("Reference", "Passed", "Reference Object verification", "Reference should be display","Reference is displayed")
Else
	Call fnReportStepALM("Reference", "Failed", "Reference Object verification", "Reference should be display","Reference is NOT displayed")
	ExitRun
End If

If OracleFormWindow("FindJournals").OracleTextField("DocumentNumbersFrom").Exist(2) Then
	OracleFormWindow("FindJournals").OracleTextField("DocumentNumbersFrom").Highlight
	Call fnReportStepALM("Document Numbers Form", "Passed", "Document Numbers Form Object verification", "Document Numbers Form should be display","Document Numbers Form is displayed")
Else
	Call fnReportStepALM("Document Numbers Form", "Failed", "Document Numbers Form Object verification", "Document Numbers Form should be display","Document Numbers Form is NOT displayed")
	ExitRun
End If

If OracleFormWindow("FindJournals").OracleTextField("DocumentNumbersTo").Exist(2) Then
	OracleFormWindow("FindJournals").OracleTextField("DocumentNumbersTo").Highlight
	Call fnReportStepALM("Document Numbers TO", "Passed", "Document Numbers TO Object verification", "Document Numbers TO should be display","Document Numbers TO is displayed")
Else
	Call fnReportStepALM("Document Numbers TO", "Failed", "Document Numbers TO Object verification", "Document Numbers TO should be display","Document Numbers TO is NOT displayed")
	ExitRun
End If

If OracleFormWindow("FindJournals").OracleTextField("DatesCreatedFrom").Exist(2) Then
	OracleFormWindow("FindJournals").OracleTextField("DatesCreatedFrom").Highlight
	Call fnReportStepALM("Dates Created From", "Passed", "Dates Created From Object verification", "Dates Created From should be display","Dates Created From is displayed")
Else
	Call fnReportStepALM("Dates Created From", "Failed", "Dates Created From Object verification", "Dates Created From should be display","Dates Created From is NOT displayed")
	ExitRun
End If

If OracleFormWindow("FindJournals").OracleTextField("DatesCreatedTo").Exist(2) Then
	OracleFormWindow("FindJournals").OracleTextField("DatesCreatedTo").Highlight
	Call fnReportStepALM("Dates Created To", "Passed", "Dates Created To Object verification", "Dates Created To should be display","Dates Created To is displayed")
Else
	Call fnReportStepALM("Dates Created To", "Failed", "Dates Created To Object verification", "Dates Created To should be display","Dates Created To is NOT displayed")
	ExitRun
End If
	
End Function

'******************************************************************************************************************************************************************************************************************************************
'	Function Name							:						  		fnKillProcess
'	Objective								:							 	Used to Kill the Process based on the Process Name that is Passed as parameter
'	Input Parameters						:							  	sProcessName
'	Output Parameters						:							   	NIL
'	Date Created							:								26-Aug-2013
'	QTP Version								:								12.0
'	QC Version								:								QC 11 
'	Pre-requisites							:								NIL  
'	Created By								:								Gallop Solutions
'	Modification Date						:		   
'******************************************************************************************************************************************************************************************************************************************

Public Function fnKillProcess(sProcessName)
    Dim iTerminationCode
        iTerminationCode = 0
    Dim OService,OInstance,sProcess
    Dim sProPath,iStatus
    
    'Set Function to False
    fnKillProcess = True
    Set OService = GetObject("winmgmts:")
    For Each sProcess In OService.InstancesOf("Win32_process")
        If UCase(sProcess.Name) = UCase(sProcessName) Then
            sProPath = "Win32_Process.Handle=" & sProcess.ProcessID
            Set OInstance = OService.Get(sProPath)
            iStatus = OInstance.Terminate(iTerminationCode)
            If iStatus = 0 Then
                Finc_KillProcess = False
            End If
        End If
    Next
End Function

'******************************************************************************************************************************************************************************************************************************************
'	Function Name							:						  	fnGetTestDataFilePath
'	Objective								:							Used to Get the Full Path with TestData file Name based on the Testdata Type (Excel or Access)
'	Input Parameters						:							NIL
'	Output Parameters						:							Full Path of the File
'	Date Created							:							26-Aug-2013
'	QTP Version								:							12.0
'	QC Version								:							QC 11 
'	Pre-requisites							:							NIL  
'	Created By								:							Gallop Solutions
'	Modification Date						:		   
'******************************************************************************************************************************************************************************************************************************************

Public Function fnGetTestDataFilePath()

   				If Environment("QC") = "Yes" Then
						sTestDataFileName = Environment("SCENARIOID") & "_TestData" & ".xls"	
						sTestDataFile = Environment("QCTESTDATAPATH")
						sTestDataFilePath = fnGetFolderAttachmentPath(sTestDataFile,sTestDataFileName)
				Else
                		sTestDataFilePath = Environment("TESTDATAPATH") & "\" & Environment("SCENARIOID") & "_TestData" & ".xls"
				End If

				fnGetTestDataFilePath = sTestDataFilePath

End Function

'******************************************************************************************************************************************************************************************************************************************
'	Function Name							:						  		fnGetEnvFilePath
'	Objective								:							 	Get the Path of the Enviromental File based on path that is passed (From QC or Local Path)
'	Input Parameters						:							  	sProjectPath
'	Output Parameters						:							   	Temp Path  where the file is downloaded
'	Date Created							:								26-Aug2013
'	QTP Version								:								12.0
'	QC Version								:								QC 11 
'	Pre-requisites							:								NIL  
'	Created By								:								Gallop Solutions
'	Modification Date						:		   
'******************************************************************************************************************************************************************************************************************************************

Public Function fnGetEnvFilePath(sProjectPath)
				If Instr(1,sProjectPath,"Subject") <> 0 Then
						Environment("QCENVPATH") = sProjectPath & "\" & "EnvironmentalVariables"
						sFile = fnGetFolderAttachmentPath(Environment("QCENVPATH"),"Environment.xls")
				Else
						sFile = sProjectPath & "\" & "EnvironmentalVariables\Environment.xls"
				End If
				' Return the values to the function
				fnGetEnvFilePath = sFile
End Function

'******************************************************************************************************************************************************************************************************************************************
'	Function Name							:						  		fnCreateQuery
'	Objective								:							 	Used to Create a Condition based on the Value used in the Transaction Range
'	Input Parameters						:							  	sString1 and sString2
'	Output Parameters						:							   	NIL
'	Date Created							:								26-Aug2013
'	QTP Version								:								12.0
'	QC Version								:								QC 11 
'	Pre-requisites							:								NIL  
'	Created By								:								Gallop Solutions
'	Modification Date						:		   
'******************************************************************************************************************************************************************************************************************************************

Public Function fnCreateQuery(sTransactionRange)
	If fnDoesExist(sTransactionRange,",") Then 
		MsgBox "Please use semi colon as delimiter NOT comma. Please correct the problem. Execution will be terminated for now"
		ExitRun
	End If
'	sQuery = "SELECT  *  FROM TEST where Run='Y'  and " 
	'sQuery = "SELECT * FROM [Test Data$] WHERE Run = 'Y' and "
    If IsNull(sTransactionRange) or Len(Trim(sTransactionRange))=0 Then
		MsgBox "No transactions were allocated for this machine"	
		fnCreateQuery=-1
		ExitRun
	End If
	sTransactionRange = UCase(sTransactionRange)
	sTransactionRange =Trim(sTransactionRange)
	If fnDoesExist (sTransactionRange,";")Then
		arr1=Split(sTransactionRange,";")
		sIndividualTIDs=""
		sRangeTIDs=""
		RangesExist=False
		For i=0 to UBound(arr1)
			If fnDoesExist(arr1(i),"-")Then
			RangesExist=True
			sRangeTIDs=sRangeTIDs&";"&Trim(arr1(i))
			Else
			sIndividualTIDs=sIndividualTIDs&";"&Trim(arr1(i))
			End If
			If i=UBound(arr1) Then 
			If Trim(Len(sRangeTIDs))>0 then sRangeTIDs=Right(sRangeTIDs,Len(sRangeTIDs)-1)
			If Trim(Len(sIndividualTIDs))>0 then sIndividualTIDs=Right(sIndividualTIDs,Len(sIndividualTIDs)-1)
			End If
		Next
		arrRanges=Split(sRangeTIDs,";")
		For j=0 to UBound(arrRanges)
			CurrentRange=Trim(arrRanges(j))
			nStart=fnSplitFor(1,"-",CurrentRange)
			nEnd=fnSplitFor(2,"-",CurrentRange)
			If IsNumeric(nStart) and IsNumeric(nEnd) Then
				nStart=CDbl(fnSplitFor(1,"-",CurrentRange))
				nEnd=CDbl(fnSplitFor(2,"-",CurrentRange))
				If nStart>=nEnd Then
					MsgBox "The starting TCID in a range must be less than the end TCID. Please correct the problem in Master.XLS File. Execution will be terminated for now"
					ExitRun
				Else
					If j=0 Then
						sSubQuery=" TCID between "&nStart&" and "&nEnd
					Else
						sSubQuery=" or TCID between "&nStart&" and "&nEnd
					End If
					sQuery=sQuery&sSubQuery
				End If
			Else
				MsgBox "Test IDs must be numbers only. Please correct the problem in Master.XLS File. Execution will be terminated for now"
				ExitRun  
			End If
		Next
		bIndividualTIDsExist=False
		arrIndividualTIDs=Split(sIndividualTIDs,";")
		If  UBound(arrIndividualTIDs)<>-1 Then bIndividualTIDsExist=True
		If RangesExist and bIndividualTIDsExist Then
			sQuery=sQuery&" or TCID in("
		ElseIf RangesExist=False and bIndividualTIDsExist=True Then
			sQuery=sQuery&" TCID in("
		End If
		For k=0 to UBound(arrIndividualTIDs)
			If IsNumeric(arrIndividualTIDs(k)) Then
				If k=0 and k<>UBound(arrIndividualTIDs)Then
					sQuery=sQuery&Trim(arrIndividualTIDs(k))&","
				ElseIf k=0 and k=UBound(arrIndividualTIDs) Then
					sQuery=sQuery&Trim(arrIndividualTIDs(k))&")"
				ElseIf k<>0 and k=UBound(arrIndividualTIDs) Then
					sQuery=sQuery&Trim(arrIndividualTIDs(k))&")"
				ElseIf k<>0 and k<>UBound(arrIndividualTIDs)Then
					sQuery=sQuery&Trim(arrIndividualTIDs(k))&","         
				End If
			Else
				MsgBox "Test IDs must be numbers only. Please correct the problem in Master.XLS File. Execution will be terminated for now"
				ExitRun
			End If
		Next
		sQuery=sQuery&" order by TCID"
		fnCreateQuery=sQuery
	ElseIf fnDoesExist(sTransactionRange,"-") Then
		CurrentRange=Trim(sTransactionRange)
		nStart=fnSplitFor(1,"-",CurrentRange)
		nEnd=fnSplitFor(2,"-",CurrentRange) 
		If IsNumeric(nStart) and IsNumeric(nEnd) Then
			nStart=CDbl(fnSplitFor(1,"-",CurrentRange))
			nEnd=CDbl(fnSplitFor(2,"-",CurrentRange))
			If nStart>=nEnd Then
				MsgBox "The starting TCID in a range must be less than the end TCID. Please correct the problem in Master.XLS File. Execution will be terminated for now"
				ExitRun
			Else
				sSubQuery=" TCID between "&nStart&" and "&nEnd
				sQuery=sQuery&sSubQuery
			End If
			sQuery=sQuery&" order by TCID"
			fnCreateQuery=sQuery
		Else
			MsgBox "Test IDs must be numbers only. Please correct the problem in Master.XLS File. Execution will be terminated for now"
			ExitRun  
		End If    
	ElseIf UCase(Trim(sTransactionRange))="ALL" Then
		arrsQuery=Split(sQuery,"and")
		sQuery=Join(arrsQuery)
		sQuery=sQuery&" order by TCID"
		fnCreateQuery=sQuery
	ElseIf IsNumeric(sTransactionRange) Then
		sQuery=sQuery&" TCID="&sTransactionRange
		sQuery=sQuery&" order by TCID"
		fnCreateQuery=sQuery
	Else
		MsgBox "No valid Test IDs were specified for this machines in Master.XLS File file. Execution will be terminated for now"
		ExitRun
	End If
End Function

'******************************************************************************************************************************************************************************************************************************************
'	Function Name							:						  		fnSplitFor
'	Objective								:							 	Used to split two values in the String using a delimetet
'	Input Parameters						:							  	nItemNumber,sSplitChar,sString
'	Output Parameters						:							   	NIL
'	Date Created							:								26-Aug2013
'	QTP Version								:							    12.0
'	QC Version								:								QC 11 
'	Pre-requisites							:								NIL  
'	Created By								:								Gallop Solutions
'	Modification Date		:		   
'******************************************************************************************************************************************************************************************************************************************

Public Function fnSplitFor(nItemNumber,sSplitChar,sString)
	If Len(Trim(sString))=0 Then
		fnSplitFor=""
		Exit Function
	End If
	arrValue = Split(sString,sSplitChar)
	If IsNumeric(nItemNumber) Then nItemNumber=nItemNumber-1

	If nItemNumber>UBound(arrValue) Then
		fnSplitFor=arrValue(UBound(arrValue))
	ElseIf nItemNumber<LBound(arrValue) Then
		fnSplitFor=arrValue(LBound(arrValue))
	Else
			fnSplitFor = arrValue( nItemNumber)
	End If

End Function

'******************************************************************************************************************************************************************************************************************************************
'	Function Name							:						  		fnGetRowCountFromTestData
'	Objective								:							 	Used to retrive the RowCount from the Test Data File
'	Input Parameters						:							  	sFile,sItemName
'	Output Parameters						:							   	NIL
'	Date Created							:								26-Aug2013
'	QTP Version								:								12.0
'	QC Version								:								QC 11 
'	Pre-requisites							:								NIL  
'	Created By								:								Gallop Solutions
'	Modification Date						:		   
'******************************************************************************************************************************************************************************************************************************************

Public Function fnGetRowCountFromTestData(sFile,sItemName)

	sQuery =  "SELECT * FROM["&sItemName&"] WHERE Run = 'Y'"
	Set DB_CONNECTION=CreateObject("ADODB.Connection")

	iCheck = Instr(1,sItemName,"$")
	If iCheck = 0 Then
		sItemName = sItemName&"$"
	End If
	
	If Environment("TRANSACTIONRANGE") = "" Then
			sQuery =  "SELECT * FROM ["&sItemName&"] WHERE Run = 'Y'"
	Else 
			sQueryCondition= fnCreateQuery(Environment("TRANSACTIONRANGE"))
			sQuery =  "SELECT * FROM ["&sItemName&"] WHERE Run = 'Y' and "&sQueryCondition
	End If

	DB_CONNECTION.Open "DBQ="&sFile&";DefaultDir=C:\;Driver={Driver do Microsoft Excel(*.xls)};DriverId=790;FIL=excel 8.0;FILEDSN=C:\Program Files\Common Files\ODBC\Data Sources\matdsn2.dsn;MaxScanRows=8;PageTimeout=5;ReadOnly=0;SafeTransactions=0;Threads=3;UID=admin;UserCommitSync=Yes;"
                
	Set Record_Set1=DB_CONNECTION.Execute(sQuery)
	Set Record_Set2=DB_CONNECTION.Execute(sQuery)
	iRowCount = 0

	Do While Not Record_Set2.EOF
		For Each Field In Record_Set1.Fields
			If IsNull(iRowValue) Then
				iRowValue = ""
			End If
		Next
		Record_Set2.MoveNext
		iRowCount = iRowCount + 1
	Loop

	Record_Set1.Close
	Set Record_Set1=Nothing
	Record_Set2.Close
	Set Record_Set2=Nothing
	DB_CONNECTION.Close
	Set DB_CONNECTION=Nothing
	fnGetRowCountFromTestData = iRowCount
End Function

''******************************************************************************************************************************************************************************************************************************************
''	Function Name						:					fnVerifyObjectExist
''	Objective						    :					Used to Verify the Object Exist in the AUT
''	Input Parameters					:					Object Name,InputValue
''	Output Parameters				    :					Nil
''	Date Created						:					21/04/2015
''	QTP Version							:					12.0
''	QC Version							:					QC 11.5
''	Pre-requisites					    :					NIL  
''	Created By						    :					Gallop Solutions
''	Modification Date			        :		            21/04/2015
''******************************************************************************************************************************************************************************************************************************************
Function fnVerifyObjectExist(sObjectName)
   ''Initially Assigning block to False
	fnVerifyObjectExist=False
	If Not IsObject(sObjectName) Then
		Set RefObject=Eval(fnGetObjectHierarchy(sObjectName))
	Else
		Set RefObject = sObjectName		 
	End If
	If  RefObject.Exist(MAX_WAIT)Then
        ''Return boolean Value True to the Called block
		fnVerifyObjectExist = True
	End If
	Set RefObject=Nothing
End Function


'******************************************************************************************************************************************************************************************************************************************
'	Function Name							:								fnObjectCheck
'	Objective								:							 	Used to check for the Object Existece, Enable/Disable
'	Input Parameters						:							 	ObjControl
'	Output Parameters						:							   	NIL
'	Date Created							:								26-Aug-2013
'	QTP Version								:								12.0
'	QC Version								:								QC 11 
'	Pre-requisites							:								NIL  
'	Created By								:								Gallop Solutions
'	Modification Date						:		   
'******************************************************************************************************************************************************************************************************************************************
Public Function fnObjectCheck(objControl)
   On Error Resume Next
	sFlag = True
	If(IsEmpty(objControl)) Then
		sFlag = False
		Exit Function 
	ElseIf objControl Is Nothing Then
		sFlag = False
		Exit Function 
	ElseIf(Not(IsObject(objControl)))Then
		sFlag = False
		Exit Function
	ElseIf(objControl.GetROProperty("disabled")) Then
		sFlag = False
		Exit Function
	End If
fnObjectCheck = sFlag
End Function


'******************************************************************************************************************************************************************************************************************************************
'	Function Name							:						  		fnCtrl
'	Objective								:								Used to Click CTRL + Any Key
'	Input Parameters						:							 	NIL
'	Output Parameters						:							   	NIL
'	Date Created							:								26-Aug2013
'	QTP Version								:								12.0
'	QC Version								:								QC 11
'	Pre-requisites							:								NIL  
'	Created By								:								Gallop Solutions
'	Modification Date						:		   
'******************************************************************************************************************************************************************************************************************************************
Public Function fnCtrl(ObjControl,strValue)
		ObjControl.Type micCtrlDwn + strValue + micCtrlUp
End Function

'******************************************************************************************************************************************************************************************************************************************
'	Function Name							:						  		fnRetriveValue
'	Objective								:							 	Used to Retrvie Values from the Application
'	Input Parameters						:							 	sObjObject
'	Output Parameters						:							   	NIL
'	Date Created							:								26-Aug-2013
'	QTP Version								:								12.0
'	QC Version								:								QC 11 
'	Pre-requisites							:								NIL  
'	Created By								:								Gallop Solutions
'	Modification Date						:		   
'******************************************************************************************************************************************************************************************************************************************

Public Function fnRetriveValue(sObjObject,sProperty)

   Select Case sObjObject.GetROProperty("micClass")
	
					Case "SwfLabel","SwfEditor","SwfEdit","SwfComboBox"
								strRetrivedValue = sObjObject.GetROProperty(sProperty)
					Case "SwfListView"
								If sProperty = "" Then
											strRetrivedValue = sObjObject.GetItemsCount
								Else
											strRetrivedValue = sObjObject.GetROProperty(sProperty)
								End If
					Case "SwfList"
								strRetrivedValue = sObjObject.GetContent
					End select

fnRetriveValue = strRetrivedValue

End Function

''******************************************************************************************************************************************************************************************************************************************
''	Function Name							:						  		fnGetFolderName
''	Objective								:							 	Used to get the folder name from the TreeView
''	Input Parameters						:							 	sTestCaseName
''	Output Parameters						:							   	NIL
''	Date Created							:								26-Aug-2013
''	QTP Version								:								12.0
''	QC Version								:								QC 11 
''	Pre-requisites							:								NIL  
''	Created By								:								Gallop Solutions
''	Modification Date						:		   
''******************************************************************************************************************************************************************************************************************************************
Public Function fnGetFolderName(sTestCaseName)
strCount = SwfWindow("Stroz Review").SwfTreeView("Document Set Tree").GetItemsCount
	For i = 1 to strCount-1
		sValue = SwfWindow("Stroz Review").SwfTreeView("Document Set Tree").GetItem(i)
		sValueArray = Split(sValue,"(")	
		If Trim(sValueArray(0)) = Trim(sTestCaseName) Then
					fnGetFolderName = sValue
					Exit For
		End If
Next
End Function

''******************************************************************************************************************************************************************************************************************************************
''	Function Name							:						 		 fnDateConversion
''	Objective								:								 Used to Convert Date to DD-Mon-YYYY Format
''	Input Parameters						:								 sDate
''	Output Parameters						:								 sDate
''	Date Created							:								 26-jULY-2015
''	QTP Version								:								 12.0
''	QC Version								:								 QC 11 
''	Pre-requisites							:								 NIL  
''	Created By								:		   						 Gallop Solutions
''	Modification Date						:		   
''******************************************************************************************************************************************************************************************************************************************
Public Function fnDateConversion(sDate)
			sDateFormat  = FormatDateTime(sDate, 1)
			sDateFormat1  = Split (Trim(sDateFormat),",",-1,1)
			sDt  = Right(Trim(sDateFormat1(1)),2)
			sMonth  = Left(Trim(sDateFormat1(1)),3)
			sDateformat  = sDt&"-"&sMonth&"-"&Trim(sDateFormat1(2))
			fnDateConversion = sDateFormat
End Function

''******************************************************************************************************************************************************************************************************************************************
''	Function Name							:						 		 fnWriteOutputValueInExcel
''	Objective								:								 Used tO Write Output Value In Excel SHEET
''	Input Parameters						:								 ScritName,intRow,StrValue,sSheetName,strColumnName
''	Date Created							:								 26-jULY-2015
''	QTP Version								:								 12.0
''	QC Version								:								 QC 11 
''	Pre-requisites							:								 NIL  
''	Created By								:		   						 Gallop Solutions
''	Modification Date						:		   
''******************************************************************************************************************************************************************************************************************************************

Public Function fnWriteOutputValueInExcel(ScritName,intRow,StrValue,sSheetName,strColumnName)
					Set fso = CreateObject("Scripting.FileSystemObject")
	
'					sFile = strProjectTestdataPath&ScritName&"_Testdata.xls"
					If (fso.FileExists(sFile)) Then								
									Set  objExcel = CreateObject("Excel.Application")
									objExcel.UserControl = True
									objExcel.Application.DisplayAlerts = False
									objExcel.visible =   False
									objExcel.Workbooks.Open(sFile)
									objExcel.Sheets(sSheetName).Select
									intLastCol = objExcel.ActiveWorkbook.ActiveSheet.UsedRange.Columns.Count
									For iValue = 1 to intLastCol
											sColumnName = objExcel.ActiveWorkbook.ActiveSheet.Cells(1,iValue)
											If Trim(sColumnName) = strColumnName Then
													objExcel.ActiveWorkbook.ActiveSheet.Cells(intRow+1,iValue) = StrValue
													Call rptWriteReport("Pass", "Output value",StrValue&" is enterd into " &ScritName&" test data sheet")
												Exit For
											End If
									Next
									objExcel.Selection.Columns.Autofit
									objExcel.Range("A1:J200").Select
									objExcel.Selection.Columns.Autofit
									objExcel.Range("A1").Select
									objExcel.ActiveWorkbook.Save
									objExcel.ActiveWorkbook.Close
									objExcel.Quit
									Set objExcel=Nothing
					else
						Call rptWriteReport("Fail", StrValue,"Output value"&" is not enterd into " &ScritName&" test data sheet")
					End If ' End If for Check for the existience of the File	
End Function

''******************************************************************************************************************************************************************************************************************************************
''	Function Name							:						 		 fnRandomNumber
''	Objective								:								 Used to generate Random Number
''	Input Parameters						:								 intLowBound,intUpperBound,strText
''	Output Parameters						:								 
''	Date Created							:								 26-jULY-2015
''	QTP Version								:								 12.0
''	QC Version								:								 QC 11 
''	Pre-requisites							:								 NIL  
''	Created By								:		   						 Gallop Solutions
''	Modification Date						:		   
''******************************************************************************************************************************************************************************************************************************************
Function fnRandomNumber(intLowBound,intUpperBound,strText)
	Dim intRand
	Randomize
	intRand = Int((intUpperBound - Cint(intLowBound) + 1) * Rnd + Cint(intLowBound))
	If strText<>"" Then
		intRand=strText&intRand
	End If
	'Return value
	fnRandomNumber=intRand
End Function




''******************************************************************************************************************************************************************************************************************************************
'	Function Name						:		  			fnCheckBox
'	Objective							:				   	Used to Check and uncheck checkboxes in any environment 
'	Input Parameters					:				  	objCheckBoxName  (Name of the checkbox object during object spy)
'	Output Parameters					:					NIL
'	Date Created						:					NIL
'	QTP Version							:					NIL
'	QC Version							:					NIL
'	Pre-requisites						:					NIL
'	Created By							:					NIL
'	Modification Date					:		      		NIL
'******************************************************************************************************************************************************************************************************************************************

Public Function fnWebCheckBox(objCheckBoxName)
	Set objDesc = Description.Create()	
		objDesc("micclass").Value = "WebCheckBox"
		objDesc("html tag").Value= "INPUT"
		objDesc("type").value = "checkbox"
	Set ChkBoxCount = oFSObj.ChildObjects(objDesc)	
	For i = 0 to ChkBoxCount.Count -1
		appVal = Trim(ChkBoxCount(i).GetROProperty("name"))
		if instr(appVal,objCheckBoxName) then
			ChkBoxCount(i).set "ON"
		End If
	Next
End Function

''******************************************************************************************************************************************************************************************************************************************
'	Function Name						:		  			fnCheckBoxOff
'	Objective							:				   	Used to uncheck checkboxes in any environment 
'	Input Parameters					:				  	objCheckBoxName  (Name of the checkbox object during object spy)
'	Output Parameters					:					NIL
'	Date Created						:					NIL
'	QTP Version							:					NIL
'	QC Version							:					NIL
'	Pre-requisites						:					NIL
'	Created By							:					Sreedhar Metukuru
'	Modification Date					:		      		NIL
'******************************************************************************************************************************************************************************************************************************************

Public Function fnWebCheckBoxoff(objCheckBoxName)
	Set objDesc = Description.Create()	
		objDesc("micclass").Value = "WebCheckBox"
		objDesc("html tag").Value= "INPUT"
		objDesc("type").value = "checkbox"
	Set ChkBoxCount = oFSObj.ChildObjects(objDesc)	
	For i = 0 to ChkBoxCount.Count -1
		appVal = Trim(ChkBoxCount(i).GetROProperty("name"))
		if instr(appVal,objCheckBoxName) then
			ChkBoxCount(i).set "OFF"
		End If
	Next
End Function

'******************************************************************************************************************************************************************************************************************************************
''	Function Name					:				fnHighlight
''	Objective						:				Used to highlight the mentioned object 
''	Input Parameters				:				Object Name
''	Output Parameters			    :				Nil
''	Date Created					:				31/08/2015
''	QTP Version						:				12.0
''	Pre-requisites					:				NIL  
''	Created By						:				Gallop Solutions
''	Modification Date		        :		   		
'******************************************************************************************************************************************************************************************************************************************
Public Function fnHighlight(sObjectName)
'Initially Assigning to False
   On Error Resume Next
	fnHighlight=False
	If Not IsObject(sObjectName) Then
		Set RefObject=Eval(fnGetObjectHierarchy(sObjectName)) 
		 
	Else
		Set RefObject = sObjectName
	End If
	RefObject.RefreshObject 
	If RefObject.Exist(MID_WAIT) Then
		If RefObject.GetRoProperty("enabled") = True OR RefObject.GetRoProperty("disabled") = 0 Then	
			RefObject.highlight
			fnHighlight = True
			Exit Function
	    End If
   Else
   	   Call rptWriteReport("Fail", sObjectName, "Highlight operation is not performed on" &sObjectName &" object is disabled")
        Exit Function
   End If
   On Error Goto 0
End Function

'******************************************************************************************************************************************************************************************************************************************
''	Function Name					:				fnRefreshRequest(sObjectName,sObjectTable)
''	Objective						:				Used to Refresh data in request window
''	Input Parameters				:				Object Name
''	Output Parameters			    :				Nil
''	Date Created					:				02/09/2015
''	QTP Version						:				12.0
''	Pre-requisites					:				NIL  
''	Created By						:				Gallop Solutions
''	Modification Date		        :		   		
'******************************************************************************************************************************************************************************************************************************************
Public Function fnRefreshRequest(sObjectName,sObjectTable)
'Initially Assigning to False
   On Error Resume Next
	fnRefreshRequest=False
	If Not IsObject(sObjectName) Then
		Set RefObject=Eval(fnGetObjectHierarchy(sObjectName)) 
	Else
		Set RefObject = sObjectName
	End If
	If Not IsObject(sObjectTable) Then
		Set RefObjectTable=Eval(fnGetObjectHierarchy(sObjectTable)) 
	Else
		Set RefObjectTable = sObjectTable
	End If
	RefObject.RefreshObject 
	irowcount = RefObjectTable.GetROProperty("visible rows")
'	For i = 1 To irowcount
'iCounter=1
		If RefObject.Exist(MID_WAIT) Then
			If RefObject.GetRoProperty("enabled") = True OR RefObject.GetRoProperty("disabled") = 0 Then	
				Do
					PhaseValue = RefObjectTable.GetFieldValue(1,"4")
					If Trim(Lcase(PhaseValue)) <> "completed" Then
'						If iCounter=7000  Then
'							Exit Function
'						End If
					else
						RefObject.click
'						fnRefreshRequest = True
					End If
'					iCounter=iCounter+1
					Loop Until Trim(Lcase(PhaseValue)) <> "completed"
				
				fnRefreshRequest = True
	   		 End If
		Else
			Call rptWriteReport("Fail", sObjectName, "click operation is not performed on" &sObjectName &" object is disabled")
        	Exit Function
   		End If	
'	Next
	
   On Error Goto 0
End Function


'******************************************************************************************************************************************************************************************************************************************
'	Sub Name		 					:					fnCloseForm
'	Objective							:					Used to close form
'	Input Parameters					:					sFormName
'	Output Parameters					:					NIL
'	Date Created						:					31-August-2015
'	QTP Version							:					UFT 12.0
'	QC Version							:					
'	Pre-requisites						:					NILL  
'	Created By							:					Gallap
'	Modification Date					:		   
'******************************************************************************************************************************************************************************************************************************************		

Public Sub  fnCloseForm(sFormName)
	If sFormName = "NavigatorForm" Then
		fnSelectMenu sFormName,"File->Exit Oracle Applications"
		If Environment("ERRORFLAG")=False Then
			ExitAction()
		End If
		fnPopUpHandle "onCaution","btnCautionOK" 
		Wait(MIN_WAIT)
	else
		fnSelectMenu sFormName,"File->Close Form"
		If Environment("ERRORFLAG")=False Then
			Exit sub
		End If
	End If
End Sub


'******************************************************************************************************************************************************************************************************************************************
'	Sub Name		 					:					fnPopUpHandle
'	Objective							:					Used to search and to select the reterived data
'	Input Parameters					:					ssearchText
'	Output Parameters					:					NIL
'	Date Created						:					31-August-2015
'	QTP Version							:					UFT 12.0
'	QC Version							:					
'	Pre-requisites						:					NILL  
'	Created By							:					Gallap
'	Modification Date					:		   
'******************************************************************************************************************************************************************************************************************************************		


Public Sub fnPopUpHandle(sObjectName,sButton)
	On Error Resume Next
		fnPopUpHandle=False
		If Not IsObject(sObjectName) Then
			Set RefObject=Eval(fnGetObjectHierarchy(sObjectName))  
		Else
			Set RefObject = sObjectName
		End If
		RefObject.RefreshObject 
		If RefObject.Exist(MIN_WAIT) Then    
			fnHighlight sObjectName
			fnClick(sButton)
			fnPopUpHandle = True
		else
			Exit sub
		End If
	On Error Goto 0
End Sub 


'******************************************************************************************************************************************************************************************************************************************
'	Sub Name		 					:					fnTakeAction
'	Objective							:					Used to click on Action image
'	Input Parameters					:					sImage,sRefresh,sStatus
'	Output Parameters					:					NIL
'	Date Created						:					31-Sept-2015
'	QTP Version							:					UFT 12.0
'	QC Version							:					
'	Pre-requisites						:					NILL  
'	Created By							:					Gallap
'	Modification Date					:		   
'******************************************************************************************************************************************************************************************************************************************		


Sub fnTakeAction(sImage,sRefresh,sStatus)
	icount = 0
	Do While(icount<30)
		Do
			fnClick sRefresh
			If not(oFSObj.Image(sImage).Exist(MIN_WAIT)) Then
				fnHighlight sStatus
				icount = icount+1
				sFlag = True
			else	
				fnClick sImage
				wait(MIN_WAIT)
				sflag = False 			
				Exit Do	
			End If
		Loop until sFlag = False 
		If sFlag = False  Then
			Exit do
		End If
	Loop 
		
End Sub

'******************************************************************************************************************************************************************************************************************************************
'               Function Name                                     :                  CloseAllBrowsers Function
'              Date Created                                      :                    -05/Jul/2016
'               QTP Version                                       :                     12.0
'               QC Version                                        :                     QC  11.53
'               Created By                                             :           Balaji  Veeravalli                                                                                                                  
'  ******************************************************************************************************************************************************************************************************************************************
Public Function fnCloseAllOpenBrowsers()
		Reporter.Filter=3
		On Error Resume Next
		If Browser("OracleApplicationsHome").Page("CreateSupplier").Link("LNK_Logout").GetROProperty("visible")=True Then
			Browser("OracleApplicationsHome").Page("CreateSupplier").Link("LNK_Logout").Click
		End If 
		Reporter.Filter=0
wait(MIN_WAIT)
'''''		Reporter.Filter=3
'''''		wait 2
'''''		Set obj=Description.Create
'''''		obj("micClass").value="Browser"
'''''		
'''''		Set s=Desktop.ChildObjects(obj)
'''''		For i=0 to s.count-1
'''''		Browser("CreationTime:="&i).close
'''''		Wait(1)
'''''		Next
'''''		Reporter.Filter=0
'		Dim WshShell, oExec
'		Set WshShell = CreateObject("WScript.Shell")
'		Set oExec = WshShell.Exec("taskkill /fi ""imagename eq iexplore.exe""")
	SystemUtil.CloseProcessByName("iexplore.exe")
	SystemUtil.CloseProcessByName("chrome.exe")
End Function



'******************************************************************************************************************************************************************************************************************************************
'	Sub Name		 					:					fnGetNumericValues
'	Objective							:					Get numeric value from string
'	Input Parameters					:					strVal
'	Output Parameters					:					NIL
'	Date Created						:					21-Jul-2016
'	QTP Version							:					UFT 12.0
'	QC Version							:					
'	Pre-requisites						:					NILL  
'	Created By							:					Balaji Veeravalli
'	Modification Date					:		   
'******************************************************************************************************************************************************************************************************************************************		
Public Function fnGetNumericValues(strVal)
	On Error resume next
'		sFlag=False
		For i=1 to len(strVal)
			strValues=mid(strVal,i,1)
				If isnumeric(strValues) Then
					intNumbers=intNumbers&strValues
				Else
					alphabet=alphabet&strValues
				End If
		Next
	fnGetNumericValues=intNumbers
End Function


'******************************************************************************************************************************************************************************************************************************************
'	Sub Name		 					:					fnDBGetFieldValue
'	Objective							:					Function to get data from Database
'	Input Parameters					:					strQuery,strCol
'	Output Parameters					:					NIL
'	Date Created						:					15-Nov-2016
'	QTP Version							:					UFT 12.5
'	QC Version							:					
'	Pre-requisites						:					NILL  
'	Created By							:					Balaji Veeravalli
'	Modification Date					:		   
'******************************************************************************************************************************************************************************************************************************************		
'Public Function fnDBGetFieldValue(strQuery, strCol)
'Const adUseClient = 3
'Const adOpenStatic = 3
'Const adLockOptimistic = 3
'	Set UdfDBConnect1 = CreateObject("ADODB.Connection") 
'	UdfDBConnect1.CommandTimeout = 800
'		strDBConnString = "DRIVER=Oracle in OraClient11g_home1;DBQ=EBSQA;UID=apps_readonly;PWD=atd12345"
'		UdfDBConnect1.Open strDBConnString
'			If Err.Number = 0 Then
'				blnRtnVal = True	
'			Else
'				blnRtnVal = False
'			End If
'		If UdfDBConnect1.State="1" Then
'			Reporter.ReportEvent micPass,"Database Connection" ,"successfully Connected to EBSQA Database."
'		Else
'			Reporter.ReportEvent micFail,"Database Connection" ,"Connection to EBSQA Database failed."
'			Exit Function
'		End If	
'	Set objRecSet = CreateObject("ADODB.Recordset")
'		objRecSet.CursorLocation = adUseClient
'		objRecSet.Open strQuery, UdfDBConnect1, adOpenStatic, adLockOptimistic
'			If Err.Number = 0 Then
'				blnRtnVal = True
'			Else
'				Set UdfConnDBRunQueryRtnRecSet = Nothing
'				blnRtnVal = False
'			End If
'			If blnRtnVal = True Then
'				Reporter.ReportEvent micPass,"Record set","Get record set from query run: '" & strQuery & "'."
'				Reporter.ReportEvent micPass,"Record set","Verify record values are returned from query executed."
'			Else
'				Reporter.ReportEvent micFail,"Record set","Get record set from query run: '" & strQuery & "'."
'			End If
'		strDBFieldValue=Trim(objRecSet.Fields.Item(strCol))
'		fnDBGetFieldValue=strDBFieldValue
'		Set objRecSet = Nothing
'			If Err.Number <> 0 	Then 
'				blnRetStatus = False		
'			Else
'				Reporter.ReportEvent micPass,"Verify Returned record value","Verify record retrieved:'"&strDBFieldValue&"' as expected"
'			End If
'End Function

'******************************************************************************************************************************************************************************************************************************************
'	Sub Name		 					:					fnDBGetFieldValue
'	Objective							:					Function to get data from Database
'	Input Parameters					:					strQuery,strCol
'	Output Parameters					:					NIL
'	Date Created						:					15-Nov-2016
'	QTP Version							:					UFT 12.5
'	QC Version							:					
'	Pre-requisites						:					NILL  
'	Created By							:					Balaji Veeravalli
'	Modification Date					:		   
'******************************************************************************************************************************************************************************************************************************************		
Public Function fnDBGetFieldValue(strQuery, strCol)
Const adUseClient = 3
Const adOpenStatic = 3
Const adLockOptimistic = 3
	Set UdfDBConnect1 = CreateObject("ADODB.Connection") 
	UdfDBConnect1.CommandTimeout = 800
		strDBConnString = "DRIVER=Oracle in OraClient11g_home1;DBQ=EBSQA;UID=apps_readonly;PWD=atd12345"
		UdfDBConnect1.Open strDBConnString
			If Err.Number = 0 Then
				blnRtnVal = True	
			Else
				blnRtnVal = False
			End If
		If UdfDBConnect1.State="1" Then
			Reporter.ReportEvent micPass,"Database Connection" ,"successfully Connected to EBSQA Database."
		Else
			Reporter.ReportEvent micFail,"Database Connection" ,"Connection to EBSQA Database failed."
			Exit Function
		End If	
	Set objRecSet = CreateObject("ADODB.Recordset")
		objRecSet.CursorLocation = adUseClient
		objRecSet.Open strQuery, UdfDBConnect1, adOpenStatic, adLockOptimistic
'		wait(8)
			If Err.Number = 0 Then
				blnRtnVal = True
'				Reporter.ReportEvent micPass,"Record set","Get record set from query run: '" & strQuery & "'."
'				Reporter.ReportEvent micPass,"Record set","Verify record values are returned from query executed."
			Else
'				Set objRecSet = Nothing
				blnRtnVal = False
'				Reporter.ReportEvent micFail,"Record set","Not Get record set from query run: '" & strQuery & "'."

			End If
'			If blnRtnVal = True Then
'				Reporter.ReportEvent micPass,"Record set","Get record set from query run: '" & strQuery & "'."
'				Reporter.ReportEvent micPass,"Record set","Verify record values are returned from query executed."
'			Else
'				Reporter.ReportEvent micFail,"Record set","Get record set from query run: '" & strQuery & "'."
'			End If
		strDBFieldValue=Trim(objRecSet.Fields.Item(strCol))
		fnDBGetFieldValue=strDBFieldValue
		Set objRecSet = Nothing
			If Err.Number <> 0 	Then 
				blnRetStatus = False		
			Else
				Reporter.ReportEvent micPass,"Verify Returned record value","Verify record retrieved:'"&strDBFieldValue&"' as expected"
				Call rptWriteReport("PASSWITHSCREENSHOT", "Verify Returned record value" , "Record is retrieved sucessfully :'"&strDBFieldValue)
			End If
End Function



'******************************************************************************************************************************************************************************************************************************************
'	Sub Name		 					:					fnDB4DxGetFieldValue
'	Objective							:					Function to get data from Database
'	Input Parameters					:					strQuery,strCol
'	Output Parameters					:					NIL
'	Date Created						:					15-Nov-2016
'	QTP Version							:					UFT 12.5
'	QC Version							:					
'	Pre-requisites						:					NILL  
'	Created By							:					Balaji Veeravalli
'	Modification Date					:		   
'******************************************************************************************************************************************************************************************************************************************		
Public Function fnDB4DxGetFieldValue(strQuery, strCol)
Const adUseClient = 3
Const adOpenStatic = 3
Const adLockOptimistic = 3
	Set UdfDBConnect1 = CreateObject("ADODB.Connection") 
	UdfDBConnect1.CommandTimeout = 800
		strDBConnString = "DRIVER=Oracle in OraClient11g_home1;DBQ=EBS4DX;UID=apps_readonly;PWD=atd12345"
		UdfDBConnect1.Open strDBConnString
			If Err.Number = 0 Then
				blnRtnVal = True	
			Else
				blnRtnVal = False
			End If
		If UdfDBConnect1.State="1" Then
			Reporter.ReportEvent micPass,"Database Connection" ,"successfully Connected to EBSQA Database."
		Else
			Reporter.ReportEvent micFail,"Database Connection" ,"Connection to EBSQA Database failed."
			Exit Function
		End If	
	Set objRecSet = CreateObject("ADODB.Recordset")
		objRecSet.CursorLocation = adUseClient
		objRecSet.Open strQuery, UdfDBConnect1, adOpenStatic, adLockOptimistic
		wait(8)
			If Err.Number = 0 Then
				blnRtnVal = True
'				Reporter.ReportEvent micPass,"Record set","Get record set from query run: '" & strQuery & "'."
'				Reporter.ReportEvent micPass,"Record set","Verify record values are returned from query executed."
			Else
'				Set objRecSet = Nothing
				blnRtnVal = False
'				Reporter.ReportEvent micFail,"Record set","Not Get record set from query run: '" & strQuery & "'."
			End If
		strDBFieldValue=Trim(objRecSet.Fields.Item(strCol))
		fnDB4DxGetFieldValue=strDBFieldValue
		Set objRecSet = Nothing
			If Err.Number <> 0 	Then 
				blnRetStatus = False		
			Else
				Reporter.ReportEvent micPass,"Verify Returned record value","Verify record retrieved:'"&strDBFieldValue&"' as expected"
				Call rptWriteReport("PASSWITHSCREENSHOT", "Verify Returned record value" , "Record is retrieved sucessfully :'"&strDBFieldValue)
			End If
End Function
'******************************************************************************************************************************************************************************************************************************************
'	Sub Name		 					:					fnSecurityMessage
'	Objective							:					Function to handle window security message
'	Input Parameters					:					
'	Output Parameters					:					NIL
'	Date Created						:					20-Dec-2016
'	QTP Version							:					UFT 12.5
'	QC Version							:					
'	Pre-requisites						:					NILL  
'	Created By							:					Balaji Veeravalli
'	Modification Date					:		   
'******************************************************************************************************************************************************************************************************************************************		
 Public Function fnSecurityMessage()
' 	WAIT(MID_WAIT)
 	Set oOracleHome=Browser("OracleApplicationsHome").Page("Oracle Applications Home")
	' Wait(MIN_WAIT)
	If Window("Windows Internet Explorer").JavaWindow("PluginEmbeddedFrame").JavaDialog("Security Warning").Exist(MID_WAIT) Then
		Window("Windows Internet Explorer").JavaWindow("PluginEmbeddedFrame").JavaDialog("Security Warning").JavaCheckBox("chkSecurityBox").Set "ON"
		Window("Windows Internet Explorer").JavaWindow("PluginEmbeddedFrame").JavaDialog("Security Warning").JavaButton("btnSecurityRun").Click:Wait(3)
		
	ElseIf oOracleHome.JavaWindow("PluginEmbeddedFrame").JavaDialog("Security Warning").Exist(MIN_WAIT) Then''Çondition added by Pradeep on 28th April
		oOracleHome.JavaWindow("PluginEmbeddedFrame").JavaDialog("Security Warning").JavaCheckBox("chkSecurityBox").Set "ON":Wait 2
		oOracleHome.JavaWindow("PluginEmbeddedFrame").JavaDialog("Security Warning").JavaButton("btnRun").Click:Wait 3
	End IF	 	 
	If Browser("OracleApplicationsHome").WinObject("Notification").WinButton("btnRunthistime").Exist(MIN_WAIT) Then
		Browser("OracleApplicationsHome").WinObject("Notification").WinButton("btnRunthistime").Click      
	End If
     
End Function

'******************************************************************************************************************************************************************************************************************************************
'	Sub Name		 					:					fnCloseSystemzTelenet
'	Objective							:					To close SystemZ and Telenet Application
'	Input Parameters					:					
'	Output Parameters					:					NIL
'	Date Created						:					09-Mar-2017
'	QTP Version							:					UFT 12.5
'	QC Version							:					
'	Pre-requisites						:					NILL  
'	Created By							:					Balaji Veeravalli
'	Modification Date					:		   
'******************************************************************************************************************************************************************************************************************************************		
Public Function fnCloseSystemzTelenet()
	On error resume next
	Reporter.Filter=3
	If TeWindow("TeWindow").Exist(2) Then
			TeWindow("TeWindow").Activate
			TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micEsc
			TeWindow("TeWindow").TeTextScreen("TeTextScreen").Type micAltDwn + micF4 + micAltUp
			If Dialog("PuTTY Exit Confirmation").Exist Then
				Dialog("PuTTY Exit Confirmation").WinButton("OK").Click
			End If
	End If	
		Reporter.Filter=0
End Function


'******************************************************************************************************************************************************************************************************************************************
'	Sub Name		 					:					fnExcelStringCompare
'	Objective							:					Used to verifying values at excel
'	Input Parameters					:					sPath,sString
'	Output Parameters					:					NIL
'	Date Created						:					16-May-2017
'	QTP Version							:					UFT 12.0
'	QC Version							:					
'	Module Name							:					Common function
'	Pre-requisites						:					NILL  
'	Created By							:					Balaji Veeravalli
'	Modification Date					:		   			
'******************************************************************************************************************************************************************************************************************************************		
Public Function fnExcelStringCompare(sFileName,sString)
On error resume next
	Dim sFSO, oExcel, oData, iFoundCell, sFind, sFile
	sFind = sString
	sFile=sFileName
	Set sFSO = CreateObject("Scripting.FileSystemObject")
	Set oExcel = CreateObject("Excel.Application")
	Set oData = oExcel.Workbooks.Open(sResourcesPathForData& "\"&sFile&".xls")	
	Set iFoundCell = oData.ActiveSheet.Range("A4:AI100").Find(sFind)
			If Not iFoundCell Is Nothing Then
				Call fnReportStepALM("Request Field", "Passed", "Request field verification","Request field must be displayed","Request field is found--"&sFind & "in row No:"&iFoundCell.Row)
				Call rptWriteReport("PASSWITHSCREENSHOT", "Request field verification","Request field is found--"&sFind & "in row No:"&iFoundCell.Row)
			Else
				Call fnReportStepALM("Request Field", "Failed", "Request field verification","Request field must be displayed","Request field is NOT found")
				Call rptWriteReport("Fail", "Request field verification" ,"Request field is NOT found")		
			End If				
	Set sFile = nothing
	Set sFind = nothing
	Set iFoundCell = nothing
	Set oData = Nothing
	Set oExcel = Nothing
	Set sFSO = Nothing
	On error goto 0 
End Function



'******************************************************************************************************************************************************************************************************************************************
'	Sub Name		 					:					fnSaveExcelFile
'	Objective							:					Used to Save the excel log file at resource
'	Input Parameters					:					
'	Output Parameters					:					NIL
'	Date Created						:					16-May-2017
'	QTP Version							:					UFT 12.0
'	QC Version							:					
'	Module Name							:					Common function
'	Pre-requisites						:					NILL  
'	Created By							:					Balaji Veeravalli
'	Modification Date					:		   			
'******************************************************************************************************************************************************************************************************************************************		
Public Function fnSaveExcelFile(sFileName)
	On error resume next
	Dim obj, sFile
		Set obj = CreateObject("Scripting.FileSystemObject")			
			sFile=trim(sFileName)
			If  obj.FileExists(sResourcesPathForData& "\"&sFile&".xls") Then
				obj.DeleteFile(sResourcesPathForData& "\"&sFile&".xls")	
			End If
	Set obj= Nothing
		Dialog("WindowsInternetExplorer").WinButton("SaveAs").Click
		wait 3
		Dialog("dlgSave As").WinEdit("edtFileName").Set sResourcesPathForData& "\"&sFile&".xls"
		Dialog("dlgSave As").WinButton("btnSave").Click		
	On error goto 0 	
End Function




'******************************************************************************************************************************************************************************************************************************************
'	Function Name		 					:					fFUIPOTemplate_Creation
'	Objective							:					Used to create PO FUI excel template
'	Input Parameters					:					
'	Output Parameters					:					NIL
'	Date Created						:					16-May-2017
'	QTP Version							:					UFT 12.0
'	QC Version							:					
'	Module Name							:					Common function
'	Pre-requisites						:					NILL  
'	Created By							:					Pradeep
'	Modification Date					:		   			
'******************************************************************************************************************************************************************************************************************************************		

Public Function fFUIPOTemplate_Creation(DictObj)
	
	Dim DownloadLocation
	
	DownloadLocation=sResourcesPathForData&"\"&DictObj("FileName"&rKey)
	
	Set oExcel=CreateObject("Excel.Application")
	
	Set oWorkbook=oExcel.Workbooks.Open(gPOFUIExcel_FilePath)
	
	oExcel.Visible=True
	
	Set oSheet=oWorkbook.Worksheets(gPOFUIExcel_SheetName)
	For nRow = 2 To 3''''Loop to add the same data in 2 rows
			
		oSheet.Cells(nRow,fGetColumnNoFromExcel("ACTION"))=DictObj("ACTION"&rKey):Wait 1
		oSheet.Cells(nRow,fGetColumnNoFromExcel("PO_NO"))=DictObj("PO_NO"&rKey):Wait 1
		oSheet.Cells(nRow,fGetColumnNoFromExcel("LINE_NO"))=DictObj("LINE_NO"&rKey):Wait 1
		oSheet.Cells(nRow,fGetColumnNoFromExcel("ORG_CODE"))=DictObj("ORG_CODE"&rKey):Wait 1
		oSheet.Cells(nRow,fGetColumnNoFromExcel("ITEM_NUMBER"))=DictObj("ITEM_NUMBER"&rKey):Wait 1
		oSheet.Cells(nRow,fGetColumnNoFromExcel("QTY_ORDERED"))=DictObj("QTY_ORDERED"&rKey):Wait 1
		oSheet.Cells(nRow,fGetColumnNoFromExcel("VENDOR"))=DictObj("VENDOR"&rKey):Wait 2
		oSheet.Cells(nRow,fGetColumnNoFromExcel("ORDER_TYPE"))=Trim(DictObj("ORDER_TYPE"&rKey)):Wait 2
		oSheet.Cells(nRow,fGetColumnNoFromExcel("NEED_BY_DATE"))=DictObj("NEED_BY_DATE"&rKey):Wait 1
		oSheet.Cells(nRow,fGetColumnNoFromExcel("PROMISED_DATE"))=DictObj("PROMISED_DATE"&rKey):Wait 1
	Next
	'oExcel.Run("Extract")	
	Window("Excel").WinObject("Ribbon").WinTab("Ribbon Tabs").Select "Developer"
	Window("Excel").WinObject("Ribbon").WinButton("Macros").Click
	Window("Macro").WinObject("CANCEL").Type "Extract":Wait(MIN_WAIT)
	Wshell.SendKeys "%r":Wait 2
	
	Dialog("regexpwndtitle:=Text Delimited Exporter").Activate
	Wshell.SendKeys DownloadLocation:Wait 2
	Wshell.SendKeys "%s":Wait 2
	Wshell.SendKeys "{ENTER}":Wait 2
	
'	oExcel.Quit
'	SystemUtil.CloseProcessByName "EXCEL.exe"
	
End Function


'******************************************************************************************************************************************************************************************************************************************
'	Function Name		 					:					fGetColumnNoFromExcel
'	Objective							:					Used to find the column number
'	Input Parameters					:					
'	Output Parameters					:					NIL
'	Date Created						:					16-May-2017
'	QTP Version							:					UFT 12.0
'	QC Version							:					
'	Module Name							:					Common function
'	Pre-requisites						:					NILL  
'	Created By							:					Pradeep
'	Modification Date					:		   			
'******************************************************************************************************************************************************************************************************************************************		
Public Function fGetColumnNoFromExcel(ColumnName)
	
	On Error Resume Next
	
	Dim nCol,nColumnCount
	
	nColumnCount=oSheet.UsedRange.Columns.Count
	
	For nCol = 1 To nColumnCount

		 If Ucase(oSheet.Cells(1,nCol).Value)=Ucase(ColumnName) Then
		 	ColumnNo=nCol
		 	Exit For 
		 End If
	
	Next
	
	fGetColumnNoFromExcel=ColumnNo
	
	If Err.Number<>0 Then
		Call rptWriteReport("FAIL","fGetColumnNoFromExcel--->"&Err.Number,Err.Description)
	End If
	
End Function



