<cfcomponent displayname="siteSearch" hint="Have Search functions for Site" output="false" extends="Search">

	<cffunction name="fncSearchSite" access="remote" returntype="any">
		<cfargument name="sSearchKey" type="string" required="true">
		<cfargument name="nPageNumber" type="numeric" required="false" default="1">

		<cfscript>
			var LOCAL.qSiteDetails = QueryNew("");
			var LOCAL.qSiteSearchResults = QueryNew("");
		</cfscript>
			<cfsearch name="LOCAL.qSiteDetails" collection="site" criteria='"#Trim(LCase(ARGUMENTS.sSearchKey))#" ~4 #Trim(LCase(ARGUMENTS.sSearchKey))#'>

			<cfif LOCAL.qSiteDetails.RecordCount>
				<cfquery name="LOCAL.qSiteSearchResults" dbtype="query">
					SELECT
						CAST([KEY] AS VARCHAR) AS ID
						,Title
						,'Financial Location: ' + Financial_Location_s+ ' - '+
						'Site Name: ' + Site_Name_s + ' - ' +
						'USID: ' + USID_s + ' - ' +
						'Region: ' + Region_s + ' - ' +
						'Street Address: ' + Street_Address_s + ' - ' +
						'City: ' + City_s + ' - ' +
						'Zip: ' + Zip_s + ' - ' +
						'Market: ' + Market_s + ' - ' +
						'Cluster: ' + Cluster_s + ' - ' +
						'State: ' + State_s  + ' - ' +
						'Site Type: ' + Site_Type_s + ' - ' +
						'Venue Name: ' + VENUE_NAME_s + '.'
						AS Summary
						,''  as Recently_Visited_Dt
						,'' AS URL
						,(CAST (score AS DECIMAL)) AS score
						,(CAST(Rank AS DECIMAL)) AS Rank
					FROM qSiteDetails
					ORDER BY Rank
				</cfquery>
			</cfif>

		<cfreturn LOCAL.qSiteSearchResults>
	</cffunction>

</cfcomponent>