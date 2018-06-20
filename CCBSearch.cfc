
<cfcomponent output="false"  extends="Search">

	<cffunction name="SearchForCCB" returntype="any" access="remote">
		<cfargument name="sSearchKey"  type="string"  required="yes">
		<cfargument name="nPageNumber" type="numeric" required="no" default="1">

		<cfset local.qCCBSearchResults = QueryNew('')>
			<cfif Len(Trim(arguments.sSearchKey)) GT 0>
				<cfsearch name="qCCBDetails" collection="changecontrolboard" criteria='"#Trim(LCase(ARGUMENTS.sSearchKey))#" ~4 #Trim(LCase(ARGUMENTS.sSearchKey))#'>
				<cfif qCCBDetails.RecordCount GT 0>
					<cfquery name="local.qCCBSearchResults" dbtype="query">
						SELECT cast([Key] as varchar) as ID
							   ,Title
							   ,Project_ID_s as PROJECT_ID
							   ,'CMR ID: '+CMR_ID_s+' - '+
							    'PROJECT ID: '+Project_ID_s+' - '+
							    'PTN: '+PTN_s+' - '+
							    'PROJECT NAME: '+Project_Name_s+' - '+
								'SOLUTION TYPE'+Program_ID_s+' - '+
							    'SITE NAME: '+Site_Name_s+' - '+
							    'VENUE NAME: '+Venue_Name_s+' - '+
							    'CMR CREATOR: '+CMR_Creator_s+' - '+
							    'CMR SUBTYPE: '+CMR_SubType_s+' - '+
							    'CMR STATUS: '+CMR_Status_s+' - '+
							    'FA LOCATION: '+FA_Location_s+' - '+
							    'CLUSTER: '+Cluster_s+' - '+
							    'CCB REGION: '+CCB_Region_s+' - '+
							    'CCB MARKET: '+CCB_Market_s+' - '+
							    'PROJECT TYPE: '+Project_Type_s+' - '+
							    'PROJECT SUBTYPE: '+Project_Subtype_s+' - '+
							    'POD YEAR: '+POD_YEAR_s+' - '+
							    'POE YEAR: '+POE_YEAR_s+' - '+'.'
							    AS  Summary
							   ,'' AS Recently_Visited_Dt
							   ,'' as URL
							   ,(cast (score as decimal)) as score
							   ,(cast(Rank as decimal)) as Rank
						  FROM qCCBDetails
					      ORDER BY Rank
					</cfquery>
				</cfif>
			</cfif>


		<cfreturn local.qCCBSearchResults>
	</cffunction>

	<cffunction name="sortByUserFavorites" returntype="any" access="remote">
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
					  ,qSearchResult.Project_ID
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
					  ,qSearchResult.Project_ID
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
					  ,qSearchResult.Project_ID
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


</cfcomponent>
