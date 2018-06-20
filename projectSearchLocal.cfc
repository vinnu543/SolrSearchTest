<cfcomponent displayname="projectSearch" hint="Have different Search functions" output="false" extends="Search">

	<!--- Function used to search mobius proj --->
	<cffunction name="fncSearchProject" access="remote" returntype="any">
		<cfargument name="sSearchKey" type="string" required="true">

			<cfscript>
			var LOCAL.qProjectDetails = QueryNew("");
			var LOCAL.qProjectSearchResults = QueryNew("");
		</cfscript>
		<cfif Len(Trim(arguments.sSearchKey)) GT 0>

			<cfsearch name="LOCAL.qProjectDetails" collection="project" criteria='"#Trim(LCase(ARGUMENTS.sSearchKey))#" ~4 #Trim(LCase(ARGUMENTS.sSearchKey))#'>
			<cfif LOCAL.qProjectDetails.RecordCount>
				<cfquery name="LOCAL.qProjectSearchResults" dbtype="query">
					SELECT
						[key] AS ID
						,Title
						,'PROJECT ID: ' + PROJECT_ID_s+ ' - '+
						'PROJECT NAME: ' + PROJECT_NAME_s + ' - ' +
						'VENUE NAME: ' + VENUE_NAME_s + ' - ' +
						'VENUE TYPE: ' + VENUE_TYPE_s + ' - ' +
						'ASG PHASE: ' + ASG_PHASE_s + ' - ' +
						'ADDRESS: ' + ADDRESS_LINE_1_s + ' - ' +
						'VENUE CITY: ' + VENUE_CITY_s + ' - ' +
						'VENUE STATE: ' + VENUE_STATE_s + ' - ' +
						'ORACLE PTN: ' + ORACLE_PTN_s + ' - ' +
						'REGION: ' + REGION_2_s + ' - ' +
						'FA LOCATION: ' + FA_LOCATION_s + ' - ' +
						'MARKET NAME: ' + MARKET_NAME_s+ ' - ' +
						'POE YEAR: ' + POE_YEAR_s + ' - ' +
						'POD YEAR: ' + POD_YEAR_s + ' - ' +
						'POR YEAR: ' + POR_YEAR_s + ' - ' +
						'SITE NAME: ' + Site_Name_s + ' - ' +
						'USID: ' + USID_s + ' - ' +
						'Cluster: ' + Cnq_Location_Cluster_s + ' - ' +
						'Funding Type: ' + Funding_Type_s + ' - ' +
						'Build Type: ' + Build_Type_s + ' - ' +
						'Contract Responsibility: ' + Contract_Responsibility_s + ' - ' +
						'Project Type: ' + Project_Type_s + ' - ' +
						'Project Subtype: ' + Project_Subtype_s + ' - ' +
						'Solution Type: ' + Solution_Type_s + ' .'
						AS Summary
						,'' AS Recently_Visited_Dt
						,'' AS URL
						,(CAST (score AS DECIMAL)) AS score
						,(CAST(Rank AS DECIMAL)) AS Rank
					FROM qProjectDetails
					ORDER BY Rank
				</cfquery>
			</cfif>

		</cfif>
		<cfdump var=#LOCAL.qProjectDetails#><br>
		<cfdump var=#LOCAL.qProjectSearchResults#>
		<cfabort>

		<cfreturn LOCAL.qProjectSearchResults>
	</cffunction>
	<cffunction name="ExpressionConversion" returntype="any" access="remote">
	<cfargument name="sSearchKey"  type="string"  required="yes">
	<cftry>

		<cfset LOCAL.sSearchString=Trim(ARGUMENTS.sSearchKey)>
		<cfparam name="LOCAL.sExpression" default="+(">
		<cfset LOCAL.sStringArray =LOCAL.sSearchString.Split(" ")>
		<cfparam name="LOCAL.sExpression" default="+(">
		<cfswitch expression="#LOCAL.sStringArray[1]#">
			<cfcase value="in">
				<cfset LOCAL.sSearchString=Right(LOCAL.sSearchString, Len(LOCAL.sSearchString)-3) />
				<cfset LOCAL.sExpression="+("/>
			</cfcase>
			<cfcase value="not">
				<cfset LOCAL.sSearchString=Right(LOCAL.sSearchString, Len(LOCAL.sSearchString)-4) />
				<cfset LOCAL.sExpression="-("/>
				<cfif LOCAL.sStringArray[2] EQ "in">
					<cfset LOCAL.sSearchString=TRIM(LOCAL.sSearchString)>
					<cfset LOCAL.sSearchString=Right(LOCAL.sSearchString, Len(LOCAL.sSearchString)-3) />
				</cfif>
			</cfcase>
			<cfcase value="notin">
				<cfset LOCAL.sSearchString=Right(LOCAL.sSearchString, Len(LOCAL.sSearchString)-6) />
				<cfset LOCAL.sExpression="-("/>
			</cfcase>
			<cfcase value="and">
				<cfset LOCAL.sSearchString=Right(LOCAL.sSearchString, Len(LOCAL.sSearchString)-4) />
				<cfset LOCAL.sExpression="+("/>
			</cfcase>

			<cfcase value="or">
				<cfset LOCAL.sSearchString=Right(LOCAL.sSearchString, Len(LOCAL.sSearchString)-3) />
				<cfset LOCAL.sExpression="+("/>
			</cfcase>
		</cfswitch>
		<cfset LOCAL.sSearchString=TRIM(LOCAL.sSearchString)>
		<cfset LOCAL.sSearchString=#ReplaceNoCase(LOCAL.sSearchString,' not in ', ' not ','ALL')#/>
		<cfset LOCAL.sSearchString=#ReplaceNoCase(LOCAL.sSearchString,' notin ', ' not ','ALL')#/>
		<cfset LOCAL.sSearchString=#ReplaceNoCase(LOCAL.sSearchString,']', '\]','ALL')#/>
		<cfset LOCAL.sSearchString=#ReplaceNoCase(LOCAL.sSearchString,'[', '\[','ALL')#/>
		<cfset LOCAL.sSearchString=#ReplaceNoCase(LOCAL.sSearchString,'~', '\~','ALL')#/>
		<cfset LOCAL.sSearchString=#ReplaceNoCase(LOCAL.sSearchString,'!', '\!','ALL')#/>
		<cfset LOCAL.sSearchString=#ReplaceNoCase(LOCAL.sSearchString,'^', '\^','ALL')#/>
		<cfset LOCAL.sSearchString=#ReplaceNoCase(LOCAL.sSearchString,'*', '\*','ALL')#/>
		<cfset LOCAL.sSearchString=#ReplaceNoCase(LOCAL.sSearchString,'{', '\{','ALL')#/>
		<cfset LOCAL.sSearchString=#ReplaceNoCase(LOCAL.sSearchString,'}', '\}','ALL')#/>
		<cfset LOCAL.sSearchString=#ReplaceNoCase(LOCAL.sSearchString,'?', '\?','ALL')#/>
		<cfset LOCAL.sSearchString=#ReplaceNoCase(LOCAL.sSearchString,'/', '\/','ALL')#/>
		<cfset LOCAL.sSearchString=#ReplaceNoCase(LOCAL.sSearchString,'+', '\+','ALL')#/>
		<cfset LOCAL.sSearchString=#ReplaceNoCase(LOCAL.sSearchString,'(', '\(','ALL')#/>
		<cfset LOCAL.sSearchString=#ReplaceNoCase(LOCAL.sSearchString,')', '\)','ALL')#/>
		<cfset LOCAL.sSearchString=#ReplaceNoCase(LOCAL.sSearchString,'_', '\_','ALL')#/>
		<cfset LOCAL.sSearchString=#ReplaceNoCase(LOCAL.sSearchString,'##', '\##','ALL')#/>
		<cfset LOCAL.sSearchString=#ReplaceNoCase(LOCAL.sSearchString,'"', '\"','ALL')#/>
		<cfset LOCAL.sSearchString=#ReplaceNoCase(LOCAL.sSearchString,'-', '\-','ALL')#/>
		<cfset LOCAL.sSearchString=#ReplaceNoCase(LOCAL.sSearchString,':', '\:','ALL')#/>
		<cfset LOCAL.sSearchString=#ReplaceNoCase(LOCAL.sSearchString,',', '\,','ALL')#/>
        <!---
        <cfset LOCAL.sSearchString=#REReplace(LOCAL.sSearchString,'[~!^*{}?/+()_##:"-]','','ALL')#/>
		~!@#$%^&*()_+`test-=\|}]{[;:'"<,.>/?test--->
		<cfset stPointer=structnew()>
		<cfif FindNoCase(" in ",LOCAL.sSearchString) neq 0>
			<cfset stPointer.in = #FindNoCase(" in ",LOCAL.sSearchString)#>
		</cfif>
		<cfif FindNoCase(" not ",LOCAL.sSearchString) neq 0>
			<cfset stPointer.not = #FindNoCase(" not ",LOCAL.sSearchString)#>
		</cfif>
		<cfif FindNoCase(" or ",LOCAL.sSearchString) neq 0>
			<cfset stPointer.or = #FindNoCase(" or ",LOCAL.sSearchString)#>
		</cfif>
				<cfif FindNoCase(" and ",LOCAL.sSearchString) neq 0>
			<cfset stPointer.and = #FindNoCase(" and ",LOCAL.sSearchString)#>
		</cfif>

		<cfparam name="nIndex" default="1">

		<cfloop condition="nIndex LTE #len(LOCAL.sSearchString)#">
			<!--- finding first condition --->
			<cfscript>
				aSortedStruct=StructSort(stPointer,"numeric","asc"); //Sorts the top level keys in the struct in ascending order
				bArrayDefined=ArrayIsDefined(aSortedStruct,1);
				writeOutput(bArrayDefined);
			</cfscript>
			<cfif bArrayDefined>
				<cfswitch expression="#aSortedStruct[1]#">
					<cfcase value="in">
						<!---get the position of IN--->

						<cfset nCount=evaluate(#stPointer.in#-#nIndex#)>
						<cfset sSubstring = mid(LOCAL.sSearchString,nIndex,nCount)><br>

						<cfset LOCAL.sExpression='#Trim(LOCAL.sExpression)##Trim(sSubstring)#)+('>
						<cfset nIndex=evaluate(#stPointer.in#+3)>

						<cfif FindNoCase(" in ",LOCAL.sSearchString,nIndex) neq 0>
							<cfset stPointer.in = #FindNoCase(" in ",LOCAL.sSearchString,nIndex)#>
						<cfelse>
							<cfif ArrayLen(aSortedStruct) eq 1>
								<cfset nCount=evaluate(#len(LOCAL.sSearchString)#)-#nIndex#+1>
								<cfset sSubstring = mid(LOCAL.sSearchString,nIndex,nCount)><br>
								<cfset LOCAL.sExpression='#Trim(LOCAL.sExpression)##Trim(sSubstring)#)'>
								<cfset nIndex=evaluate(#len(LOCAL.sSearchString)# + 1)>
							</cfif>
							<cfset delStruct = StructDelete(stPointer, "in", "True")>
						</cfif>
					</cfcase>
					<cfcase value="not">
						<!---get the position of NOT--->
						<cfset nCount=evaluate(#stPointer.not#-#nIndex#)>
						<cfset sSubstring = mid(LOCAL.sSearchString,nIndex,nCount)><br>
						<cfset LOCAL.sExpression='#Trim(LOCAL.sExpression)##Trim(sSubstring)#)-('>
						<cfset nIndex=evaluate(#stPointer.not#+4)>
						<cfif FindNoCase(" not ",LOCAL.sSearchString,nIndex) neq 0>
							<cfset stPointer.not = #FindNoCase(" not ",LOCAL.sSearchString,nIndex)#>
						<cfelse>
							<cfif ArrayLen(aSortedStruct) eq 1>
								<cfset nCount=evaluate(#len(LOCAL.sSearchString)#)-#nIndex#+1>
								<cfset sSubstring = mid(LOCAL.sSearchString,nIndex,nCount)><br>
								<cfset LOCAL.sExpression='#Trim(LOCAL.sExpression)##Trim(sSubstring)#)'>
								<cfset nIndex=evaluate(#len(LOCAL.sSearchString)# + 1)>
							</cfif>
							<cfset delStruct = StructDelete(stPointer, "not",false)>
						</cfif>
					</cfcase>

					<cfcase value="or">
						<!---get the position of OR--->
						<cfset nCount=evaluate(#stPointer.or#-#nIndex#)>
						<cfset sSubstring = mid(LOCAL.sSearchString,nIndex,nCount)><br>
						<cfset LOCAL.sExpression='#Trim(LOCAL.sExpression)##Trim(sSubstring)#'>
						<cfset nIndex=evaluate(#stPointer.or#+3)>

						<cfif FindNoCase(" in ",LOCAL.sSearchString,nIndex) neq 0>
							<cfset stPointer.or = #FindNoCase(" or ",LOCAL.sSearchString,nIndex)#>
						<cfelse>
							<cfif ArrayLen(aSortedStruct) eq 1>
								<cfset nCount=evaluate(#len(LOCAL.sSearchString)#)-#nIndex#+1>
								<cfset sSubstring = mid(LOCAL.sSearchString,nIndex,nCount)><br>
								<cfset LOCAL.sExpression='#Trim(LOCAL.sExpression)# #Trim(sSubstring)#)'>
								<cfset nIndex=evaluate(#len(LOCAL.sSearchString)# + 1)>
							</cfif>
							<cfset delStruct = StructDelete(stPointer, "or", "True")>
						</cfif>
					</cfcase>

					<cfcase value="and">
						<!---get the position of AND--->
						<cfset nCount=evaluate(#stPointer.and#-#nIndex#)>
						<cfset sSubstring = mid(LOCAL.sSearchString,nIndex,nCount)><br>
						<cfset LOCAL.sExpression='#Trim(LOCAL.sExpression)#+(#Trim(sSubstring)#)+'>
						<cfset nIndex=evaluate(#stPointer.and#+4)>
						<cfif FindNoCase(" not ",LOCAL.sSearchString,nIndex) neq 0>
							<cfset stPointer.and = #FindNoCase(" and ",LOCAL.sSearchString,nIndex)#>
						<cfelse>
							<cfif ArrayLen(aSortedStruct) eq 1>
								<cfset nCount=evaluate(#len(LOCAL.sSearchString)#)-#nIndex#+1>
								<cfset sSubstring = mid(LOCAL.sSearchString,nIndex,nCount)><br>
								<cfset LOCAL.sExpression='#Trim(LOCAL.sExpression)##Trim(sSubstring)#)'>
								<cfset nIndex=evaluate(#len(LOCAL.sSearchString)# + 1)>
							</cfif>
							<cfset delStruct = StructDelete(stPointer, "and",false)>
						</cfif>
					</cfcase>

				</cfswitch>
				<cfelse>
					<cfset nCount=evaluate(#len(LOCAL.sSearchString)#)-#nIndex#+1>
					<cfset sSubstring = mid(LOCAL.sSearchString,nIndex,nCount)>
					<cfset LOCAL.sExpression='#Trim(LOCAL.sExpression)##Trim(sSubstring)#)'>
					<cfset nIndex=evaluate(#len(LOCAL.sSearchString)# + 1)>
				</cfif>

		</cfloop>
		<cfcatch type="any">
				<cfoutput>
					<p>#cfcatch.message#</p><p>#cfcatch.detail#</p>
				</cfoutput>
				<cfabort>
			</cfcatch>
		</cftry>
		<cfreturn LOCAL.sExpression>
	</cffunction>



</cfcomponent>
