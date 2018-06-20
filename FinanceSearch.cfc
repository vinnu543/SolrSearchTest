<cfcomponent displayname="FinanceSearch" hint="Have different Search functions" output="false" extends="Search">

	<!--- Function used to search proj --->
	<cffunction name="SearchForFinance" access="remote" returntype="any">
		<cfargument name="sSearchKey" type="string" required="true">
		<cfargument name="nPageNumber" type="numeric" required="false" default="1">

		<cfscript>
			var LOCAL.qFinanceDetails = QueryNew("");
			var LOCAL.qFinanceSearchResults = QueryNew("");
		</cfscript>
		<cfif Len(Trim(arguments.sSearchKey)) GT 0>

			<cfsearch name="LOCAL.qFinanceDetails" collection="finance" criteria='"#Trim(LCase(ARGUMENTS.sSearchKey))#" ~4 #Trim(LCase(ARGUMENTS.sSearchKey))#'>
			<cfif LOCAL.qFinanceDetails.RecordCount>
				<cfquery name="LOCAL.qFinanceSearchResults" dbtype="query">
					SELECT
						[key] AS ID
						,Title
						,PTN_s as PTN
						,'PROJECT ID: ' + PROJECT_ID_s+ ' - '+
						'PROJECT NAME: ' + PROJECT_NAME_s + ' - ' +
						'VENUE NAME: ' + VENUE_NAME_s + ' - ' +
						'VENUE TYPE: ' + VENUE_TYPE_s + ' - ' +
						'ASG PHASE: ' + ASG_PHASE_s + ' - ' +
						'ADDRESS: ' + ADDRESS_LINE_1_s + ' - ' +
						'VENUE CITY: ' + VENUE_CITY_s + ' - ' +
						'VENUE STATE: ' + VENUE_STATE_s + ' - ' +
						'PTN: ' + PTN_s + ' - ' +
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
					FROM qFinanceDetails
					ORDER BY Rank
				</cfquery>
			</cfif>

		</cfif>

		<cfreturn LOCAL.qFinanceSearchResults>
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
					  ,qSearchResult.PTN
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
					  ,qSearchResult.PTN
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
					  ,qSearchResult.PTN
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