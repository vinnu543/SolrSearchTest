<cfcomponent displayname="projectSearch" hint="Have different Search functions" output="false" extends="Search">

	<!--- Function used to search mobius proj --->
	<cffunction name="fncSearchProject" access="remote" returntype="any">
		<cfargument name="sSearchKey" type="string" required="true">
		<cfargument name="nPageNumber" type="numeric" required="false" default="1">

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
						'MARKET NAME: ' + MARKET_NAME_s+ ' - ' 
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
        
		<cfreturn LOCAL.qProjectSearchResults>
	</cffunction>

</cfcomponent>