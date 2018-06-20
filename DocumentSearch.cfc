<cfcomponent accessors="true" output="false" extends="Search">

	<cffunction name="SearchForDocuments" returntype="any" access="remote">
		<cfargument name="sSearchKey"  type="string"  required="yes">
		<cfargument name="nPageNumber" type="numeric" required="no" default="1">
		<cftry>
			<cfset local.qDocSearchResults = QueryNew('')>
			<cfif Len(Trim(arguments.sSearchKey)) GT 0>
				<cfsearch name="local.qDocDetails" collection="documents" criteria='"#Trim(LCase(ARGUMENTS.sSearchKey))#" ~4 #Trim(LCase(ARGUMENTS.sSearchKey))#'>
				<cfif local.qDocDetails.RecordCount GT 0>
					<cfquery name="local.qDocSearchResults" dbtype="query">
						SELECT cast([Project_ID_s] as varchar) as ID
							   ,Title
							   ,'FA LOCATION: '+FA_Location_s+' - '+
                                'FILE NAME: '+File_Name_s+' - '+
                                'FILETYPE: '+File_Type_s+' - '+
                                'PROJECT ID: '+Project_ID_s+' - '+
                                'PROJECT NAME: '+Project_Name_s+' - '+
                                'SOLUTION TYPE: '+Program_ID_s+' - '+
                                'PTN: '+PTN_s+' - '+
                                'SITE NAME: '+Site_Name_s+' - '+
                                'VENUE NAME: '+Venue_Name_s+' - '+
                                'TASK ID: '+Task_ID_s+' - '+' . '
                                AS Summary
							   ,'' AS Recently_Visited_Dt
							   ,'' as URL
							   ,(cast (score as decimal)) as score
							   ,(cast(Rank as decimal)) as Rank
						  FROM qDocDetails
					      ORDER BY Rank
					</cfquery>
				</cfif>
			</cfif>
			<cfcatch type="any">
				<cfoutput>
					<p>#cfcatch.message#</p><p>#cfcatch.detail#</p>
				</cfoutput>
				<cfabort>
			</cfcatch>
		</cftry>
		<cfreturn local.qDocSearchResults>
	</cffunction>

</cfcomponent>