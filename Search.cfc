<!---------------------------------------------------------------------------------------------
  ---             Modification History
  --- -----------------------------------------------------------------------------------------
  --- Date          --  Modified By   			-- Comments
  --- May 17, 2017  --  Nandakumar			    -- Created inital version
  ---
  ---
  ---------------------------------------------------------------------------------------------->
<cfcomponent output="false">
	<!--- Set number of results to be displayed per page & columns to include in search result --->

	<cffunction name="sortByUserFavorites" returntype="any" access="remote" hint="There are customized versions for this method in finance & contracts module">
		<cfargument name="qSearchResult" type="query"  required="yes" hint="Search Query Result set from Collections">
		<cfargument name="sSearchModule" type="string" required="yes" hint="Search module can be Project, CCB, Audit etc">
		<cfargument name="sSearchKey"    type="string" required="yes" hint="Search text entered by user">
		<cfset qFavoriteScore.RecordCount = 0>
		<cfset LOCAL.qSearchResult = ARGUMENTS.qSearchResult>
		<cfset LOCAL.qFavoriteScore = GetFavoriteLookupScore(ARGUMENTS.sSearchModule,ARGUMENTS.sSearchKey) />

		<cfif qFavoriteScore.RecordCount EQ 0>
			<cfquery name="LOCAL.qSortedResult" dbtype="query">
				SELECT  qSearchResult.ID
					  ,qSearchResult.Title
					  ,qSearchResult.Summary
					  ,qSearchResult.URL
					  ,qSearchResult.Recently_Visited_Dt
					  ,qSearchResult.Rank
					  ,cast(0.000 as double) AS User_Fav_Score
					  ,cast(qSearchResult.Score as double) AS Score
				FROM qSearchResult
				ORDER BY Rank
			</cfquery>

		<cfelse>

			<cfquery name="LOCAL.qSortedResult" dbtype="query">

				SELECT  qSearchResult.ID
					  ,qSearchResult.Title
					  ,qSearchResult.Summary
					  ,qSearchResult.URL
					  ,qSearchResult.Recently_Visited_Dt
					  ,cast(qFavoriteScore.RowNo as integer) AS Rank
					  ,cast(qFavoriteScore.Score as double) AS User_Fav_Score
					  ,cast(qSearchResult.Score as double) AS Score
				FROM qSearchResult, qFavoriteScore
				WHERE qSearchResult.ID  =qFavoriteScore.SEARCH_ID

				UNION

				SELECT  qSearchResult.ID
					  ,qSearchResult.Title
					  ,qSearchResult.Summary
					  ,qSearchResult.URL
					  ,qSearchResult.Recently_Visited_Dt
					  ,cast(90000000 as integer)  AS Rank
					  ,cast(0.000 as double) AS User_Fav_Score
					  ,cast(qSearchResult.Score as double) AS Score
				FROM qSearchResult,qFavoriteScore
				WHERE (qSearchResult.ID) NOT IN (<cfqueryparam value="#ValueList(qFavoriteScore.SEARCH_ID)#" cfsqltype="cf_sql_varchar" list="yes"/>)

				ORDER BY Rank, Score DESC

			</cfquery>

		</cfif>

		<cfreturn LOCAL.qSortedResult>
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
        <cfset LOCAL.sSearchString=#ReplaceNoCase(LOCAL.sSearchString,'\', '\\,','ALL')#/>
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

	<cffunction name="GetFavoriteLookupScore" returntype="query" access="public">
		<cfargument name="sSearchModule" type="string" 	required="yes" hint="Search module can be Project, CCB, Audit etc">
		<cfargument name="sSearchKey"    type="string" 	required="yes" hint="Search text entered by user">
		<cfstoredproc procedure="New.getFavoriteLookupScore" datasource="#application.sqlSource#" username="#application.sqlName#" password="#application.sqlPass#">
			<cfprocparam value="#Trim(ARGUMENTS.sSearchModule)#" 	cfsqltype="cf_sql_varchar">
			<cfprocparam value="#Trim(ARGUMENTS.sSearchKey)#" 	cfsqltype="cf_sql_varchar">
			<cfprocparam value="#Trim(client.attuid)#" 			cfsqltype="cf_sql_varchar">
			<cfprocresult name="LOCAL.qFavoriteLookupScore" resultset="1">
		</cfstoredproc>
		<cfreturn LOCAL.qFavoriteLookupScore>
	</cffunction>

	<cffunction name="getFormattedResultSet" returntype="any" access="remote">
		<cfargument name="qData" 					type="query" required="yes">
		<cfargument name="sSearchModule" 			type="string" required="no" 	default="Project">
		<cfargument name="nPageNumber" 				type="numeric" 	required="no" 	default="1">
		<cfargument name="nTotaRecordCount"			type="numeric" 	required="no" 	default="1">
		<cfargument name="nNumberOfRecordsPerPage"	type="numeric"	required="no"	default="20">
		<cfargument name="sColumnList"				type="string"	required="no"	default="ID,Title,Summary,URL,Rank,Recently_Visited_Dt">

		<!--- Format records  --->
		<cfscript>
       		LOCAL.aResultSet = [];
       		LOCAL.aVisitedDates = [];
       		LOCAL.qRecentlyVistedDates = queryNew('');
       		LOCAL.stResult = createObject("java", "java.util.LinkedHashMap").init();
        	LOCAL.nNumerOfRows = ARGUMENTS.qData.RecordCount;

        	if(ARGUMENTS.qData.RecordCount GT 0){
        		LOCAL.qRecentlyVistedDates = getRecentlyVistedDates(ARGUMENTS.sSearchModule,ARGUMENTS.qData);
        		LOCAL.aVisitedDates = ListToArray(valueList(LOCAL.qRecentlyVistedDates.SEARCH_ID));
        	}

        	structInsert(LOCAL.stResult,'Total_Record_Count',ARGUMENTS.nTotaRecordCount);

        	if(ARGUMENTS.nNumberOfRecordsPerPage LT LOCAL.nNumerOfRows){
				LOCAL.nNumerOfRows = ARGUMENTS.nNumberOfRecordsPerPage;
        	}

        	if(CompareNoCase(ARGUMENTS.sSearchModule,'CCB') EQ 0){
				 LOCAL.sURL = "#application.siteroot#/ChangeControl/CCB_Details.cfm?CMRID=";
        	}
        	else if(CompareNoCase(ARGUMENTS.sSearchModule,'Audit') EQ 0){
                 LOCAL.sURL = "#application.siteroot#/Audit/Conduct/Ques_ans.cfm?getScheduleId=";
            }
        	else if(CompareNoCase(ARGUMENTS.sSearchModule,'Project') EQ 0){
                 LOCAL.sURL = "#application.siteroot#/Project/Conduct/Ques_ans.cfm?getScheduleId=";
            }
        	else if(CompareNoCase(ARGUMENTS.sSearchModule,'Site') EQ 0){
                 LOCAL.sURL = "#application.siteroot#/Site/Conduct/Ques_ans.cfm?getScheduleId=";
            }
            else if(CompareNoCase(ARGUMENTS.sSearchModule,'Documents') EQ 0){
                 LOCAL.sURL = "#application.siteroot#/Site/Conduct/Ques_ans.cfm?getScheduleId=";
            }
            else if(CompareNoCase(ARGUMENTS.sSearchModule,'Contracts') EQ 0){
                 LOCAL.sURL = "#application.siteroot#/Contracts/Conduct/Ques_ans.cfm?getScheduleId=";
            }
            else if(CompareNoCase(ARGUMENTS.sSearchModule,'financial') EQ 0){
                 LOCAL.sURL = "";
            }

        	//create array of search result structure
			for(LOCAL.nRow=1; LOCAL.nRow<=LOCAL.nNumerOfRows; LOCAL.nRow++) {
            	LOCAL.stRecord = createObject("java", "java.util.LinkedHashMap").init();
            	for(LOCAL.nCol=1; LOCAL.nCol<=listLen(ARGUMENTS.sColumnList); LOCAL.nCol++) {
            		if(CompareNoCase(listGetAt(ARGUMENTS.sColumnList, LOCAL.nCol),'URL') EQ 0){
						LOCAL.stRecord[lcase(listGetAt(ARGUMENTS.sColumnList, LOCAL.nCol))] = LOCAL.sURL & '#ARGUMENTS.qData['ID'][nRow]#';
            		}else if(CompareNoCase(listGetAt(ARGUMENTS.sColumnList, LOCAL.nCol),'Rank') EQ 0){
            			LOCAL.stRecord[lcase(listGetAt(ARGUMENTS.sColumnList, LOCAL.nCol))] = (LOCAL.nRow+((ARGUMENTS.nPageNumber-1)*ARGUMENTS.nNumberOfRecordsPerPage));
            		}
            		else if(CompareNoCase(listGetAt(ARGUMENTS.sColumnList, LOCAL.nCol),'Recently_Visited_Dt') EQ 0){
            			LOCAL.stRecord[lcase(listGetAt(ARGUMENTS.sColumnList, LOCAL.nCol))] = LOCAL.qRecentlyVistedDates['Recently_Visited_Dt'][arrayFind(LOCAL.aVisitedDates,'#ARGUMENTS.qData['ID'][nRow]#')];
            		}
            		else{
            			LOCAL.stRecord[lcase(listGetAt(ARGUMENTS.sColumnList, LOCAL.nCol))] = ARGUMENTS.qData[listGetAt(ARGUMENTS.sColumnList, LOCAL.nCol)][LOCAL.nRow];
            		}
            	}
            	arrayAppend(LOCAL.aResultSet, LOCAL.stRecord);
        	}
        	structInsert(LOCAL.stResult,'Search_Results',LOCAL.aResultSet);
		</cfscript>
		<cfreturn LOCAL.stResult>
	</cffunction>

	<cffunction name="getRecentlyVistedDates" returntype="query" access="public">
		<cfargument name="sSearchModule" type="string" 	required="yes" hint="Search module can be Project, CCB, Audit etc">
		<cfargument name="qData" type="query" required="yes">
		<cfquery name="LOCAL.qRecentlyVistedDates" datasource="#application.sqlSource#" username="#application.sqlName#" password="#application.sqlPass#">
			SELECT SEARCH_ID
			      ,SEARCH_TYPE
			      ,Recently_Visited_Dt = MAX(session_time)
              FROM New.USER_SEARCH_LOG
          GROUP BY SEARCH_ID, SEARCH_TYPE
            HAVING SEARCH_TYPE = <cfqueryparam value="#ARGUMENTS.sSearchModule#" cfsqltype="cf_sql_varchar">
			   AND SEARCH_ID IN (<cfqueryparam value="#ValueList(ARGUMENTS.qData.ID)#" cfsqltype="cf_sql_varchar" list="yes"/>)
		</cfquery>
		<cfreturn LOCAL.qRecentlyVistedDates>
	</cffunction>

	<cffunction name="addUserFavScore" access="remote" output="false" returntype="void">
		<cfargument name="sSearchID" 	type="string" 	required="true"		hint="search ID">
		<cfargument name="sSearchKey" 	type="string" 	required="true" 	hint="The search key">
		<cfargument name="sModule" 		type="string" 	required="true" 	hint="Module for which search was done">
		<cfargument name="sTitle"		type="string"	required="false"	default=""	hint="This will be used for documents module to get the UID">

			<cfstoredproc procedure="New.UpdateSearchClickLog" datasource="#application.sqlSource#" username="#application.sqlName#" password="#application.sqlPass#">
				<cfprocparam  value="#Trim(ARGUMENTS.sSearchID)#" cfsqltype="CF_SQL_VARCHAR">
				<cfprocparam  value="#Trim(ARGUMENTS.sSearchKey)#" cfsqltype="CF_SQL_VARCHAR">
				<cfprocparam  value="#Trim(ARGUMENTS.sModule)#" cfsqltype="CF_SQL_VARCHAR">
				<cfprocparam  value="#Trim(ARGUMENTS.sTitle)#" cfsqltype="CF_SQL_VARCHAR">
				<cfprocparam  value="#client.attuid#" cfsqltype="CF_SQL_VARCHAR">
			</cfstoredproc>
	</cffunction>


	<!--- Function for pagination --->
	<cffunction name="fncGetPaginatedResult" access="remote" output="false" returntype="any" returnFormat="plain">
		<cfargument name="qObj" type="query" required="true">
		<cfargument name="nPageNumber" type="numeric" required="true" default="1" hint="The page number">
		<cfargument name="nPageSize" type="numeric" required="true" default="25" hint="The number of rows">
        <cftry>
		<cfscript>
			var LOCAL.qPaginatedResults = Duplicate(ARGUMENTS.qObj);
			var LOCAL.nStartRow = ((ARGUMENTS.nPageNumber - 1) * ARGUMENTS.nPageSize) + 1;
			var LOCAL.nEndRow = LOCAL.nStartRow + ARGUMENTS.nPageSize - 1;
			LOCAL.qPaginatedResults.removeRows(LOCAL.nEndRow, LOCAL.qPaginatedResults.recordcount - LOCAL.nEndRow);
			LOCAL.qPaginatedResults.removeRows(0, LOCAL.nStartRow - 1);
		</cfscript>

		<cfreturn LOCAL.qPaginatedResults>
            <cfcatch type=any></cfcatch>
        </cftry>     
	</cffunction>

	<!--- Function for checking user search query and info in SESSION --->
	<cffunction name="fncCheckUserSearchSESSION" access="remote" output="false" returntype="any" returnFormat="plain">
		<cfargument name="sModule" type="string" required="true" hint="Module for which search was done">
		<cfargument name="sSearchKey" type="string" required="true" hint="The search key">
        <cftry>
		<cfset LOCAL.nCollectionsRefreshTimeInterval = 0>
		<cfif StructKeyExists(SESSION,'dtCreateTime')>
			<cfset LOCAL.objRefresh = new global.PerformanceLog()>
			<cfset LOCAL.qRefreshTime  = LOCAL.objRefresh.GetRefreshTimeForCollections(ARGUMENTS.sModule)>
			<!--- A +ve or 0 difference shows SESSION was created after collections refresh --->
			<cfif LOCAL.qRefreshTime.RecordCount GT 0 AND isDate(LOCAL.qRefreshTime.REFRESH_TIME)>
				<cfset LOCAL.nCollectionsRefreshTimeInterval = DateDiff("n",LOCAL.qRefreshTime.REFRESH_TIME,SESSION.dtCreateTime)>
			</cfif>
		</cfif>

		<cfscript>
			var LOCAL.bSearchResultExists = false;

			if(StructKeyExists(SESSION, "sUserSearchModule") AND SESSION.sUserSearchModule EQ ARGUMENTS.sModule
				AND StructKeyExists(SESSION, "sUserSearchKey") AND SESSION.sUserSearchKey EQ ARGUMENTS.sSearchKey
				AND StructKeyExists(SESSION, "qUserSearchSortedResults")
				AND LOCAL.nCollectionsRefreshTimeInterval GTE 0){
					LOCAL.bSearchResultExists = true;
			}
		</cfscript>

		<cfreturn LOCAL.bSearchResultExists>
            <cfcatch type=any></cfcatch>
        </cftry>    
	</cffunction>

	<!--- Function for saving user search query and info in SESSION --->
	<cffunction name="fncSetUserSearchSESSION" access="remote" output="true" returntype="any" returnFormat="plain">

		<cfargument name="qSearchedSortedResult" type="query" required="true">
		<cfargument name="sModule" type="string" required="true" hint="Module for which search was done">
		<cfargument name="sSearchKey" type="string" required="true" hint="The search key">

		<cfscript>
			lock timeout="10" scope="SESSION" type="exclusive"{
				SESSION.qUserSearchSortedResults = ARGUMENTS.qSearchedSortedResult;
				SESSION.sUserSearchKey = ARGUMENTS.sSearchKey;
				SESSION.sUserSearchModule = ARGUMENTS.sModule;
				SESSION.dtCreateTime = now();
			}
		</cfscript>

		<cfreturn true>
	</cffunction>

	<cffunction name="logResultSet" returntype="any" access="public">
		<cfargument name="sResultJSON" type="string"  required="yes" hint="Formatted JSON result">
		<cfargument name="qScoreQuery" type="query"  required="yes" hint="Sort Query Result for getting score and favScore">
		<cfargument name="sSearchModule" type="string" required="yes" hint="Search module can be Project, CCB, Audit etc">
		<cfargument name="sSearchKey"    type="string" required="yes" hint="Search text entered by user">
		<cfargument name="nPageNumber" type="numeric" required="true" default="1" hint="The page number">

		<cfset ResultData=DeserializeJSON(ARGUMENTS.sResultJSON)>
		<cfset LOCAL.time=#DateTimeFormat(Now(), "yyyy-mm-dd hh:nn:ss")#>


		<cfloop array="#ResultData#" index="i"> <!--- Loop for array --->
			<cfloop collection="#i#" item="k"> <!--- loop for structure inside array --->
				<cfif k eq 'id'>
					<cfset LOCAL.key=#i[k]#>
				</cfif>
				<cfif k eq 'rank'>
					<cfset LOCAL.rank=#i[k]#>
				</cfif>
				<cfif k eq 'summary'>
					<cfset LOCAL.summary=#i[k]#>
				</cfif>
				<cfif k eq 'title'>
					<cfset LOCAL.title=#i[k]#>
				</cfif>
				<cfif k eq 'url'>
					<cfset LOCAL.url=#i[k]#>
				</cfif>
			</cfloop>
			<cfquery name="LOCAL.getScore" dbtype="query">
				SELECT User_Fav_Score,Score FROM ARGUMENTS.qScoreQuery WHERE ID = CAST("#key#" AS VARCHAR)
			</cfquery>

			<cfstoredproc procedure="New.InsertSearchResultLog" datasource="#application.sqlSource#" username="#application.sqlName#" password="#application.sqlPass#">
				<cfprocparam value="#LOCAL.key#" 	cfsqltype="CF_SQL_INTEGER">
				<cfprocparam value="#LOCAL.rank#" 	cfsqltype="CF_SQL_INTEGER">
				<cfprocparam value="#SESSION.CFToken#" 	cfsqltype="CF_SQL_VARCHAR">
				<cfprocparam value="#LOCAL.time#" 	cfsqltype="CF_SQL_TIMESTAMP">
				<cfprocparam value="#ARGUMENTS.sSearchKey#" 	cfsqltype="CF_SQL_VARCHAR">
				<cfprocparam value="#LOCAL.title#" 	cfsqltype="CF_SQL_VARCHAR">
				<cfprocparam value="#LOCAL.summary#" 	cfsqltype="CF_SQL_VARCHAR">
				<cfprocparam value="#LOCAL.url#" 	cfsqltype="CF_SQL_VARCHAR">
				<cfprocparam value="#ARGUMENTS.sSearchModule#" 	cfsqltype="CF_SQL_VARCHAR">
				<cfprocparam value="#LOCAL.getScore.Score#" 	cfsqltype="CF_SQL_FLOAT">
				<cfprocparam value="#LOCAL.getScore.User_Fav_Score#" 	cfsqltype="CF_SQL_FLOAT">
				<cfprocparam value="#ARGUMENTS.nPageNumber#" 	cfsqltype="CF_SQL_INTEGER">
				<cfprocparam value="#client.attuid#" 	cfsqltype="CF_SQL_VARCHAR">
			</cfstoredproc>
		</cfloop>
	</cffunction>



</cfcomponent>

