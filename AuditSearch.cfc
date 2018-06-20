<cfcomponent accessors="true" output="false" extends="Search">

	<cffunction name="SearchForAudit" returntype="any" access="remote">
		<cfargument name="sSearchKey"  type="string"  required="yes">
		<cfargument name="nPageNumber" type="numeric" required="no" default="1">
		<cftry>
			<cfset local.auditSearchResults = QueryNew('')>
			<cfif Len(Trim(arguments.sSearchKey)) GT 0>
				<cfsearch name="local.auditDetails" collection="Audit_Project" criteria='"#Trim(LCase(ARGUMENTS.sSearchKey))#" ~4 #Trim(LCase(ARGUMENTS.sSearchKey))#'>
				<cfif local.auditDetails.RecordCount GT 0>

					<cfquery name="local.auditSearchResults" dbtype="query">
						SELECT [Key] as ID
							   ,Title
							   ,'SCHEDULE ID: '+ CAST([Key] as varchar) + ' - ' +
							    'AUDIT NAME:  '+ Title + ' - ' +
							    'AUDIT STATUS: '+ Status_s +' - '+
							    'AUDITOR ID: '+ AuditorID_s +' - '+
							    'ADDRESS: '+ Address_s +' - '+
							    'CITY: '+ City_s +' - '+
							    'MARKET: '+ Market_s +' - '+
							    'CLUSTER: '+ Cluster_s +' - '+
							    'FA LOCATION: '+ financialLocation_s +' - '+
							    'SURVEYOR ID: '+ SurveyorID_s +' - '+
							    'REVIEWER ID: '+ ReviewerID_s +' - '+
							    'REGION: '+ Region_s +' - '+
							    'QUESTION SET: '+ QuestionSet_s +' - '+
							    'SITE: '+ Site_s +' - '+
							    'STATE: '+ State_s +' - '+
							    'PROJECT ID: '+ ProjectID_s +' - '+
							    'PROJECT NAME: '+ ProjectName_s +' - '+
                                'SOLUTION TYPE: '+ Program_ID_s +' - '+
							    'USID: '+ USID_s +' - '+
							    'PTN: '+ PTN_s +' - '+
							    'VENUE NAME: '+ VenueName_s +'. '
							     AS Summary
                               ,'' AS Recently_Visited_Dt
							   ,'' as URL
							   ,(cast (score as decimal)) as score
							   ,(cast(Rank as decimal)) as Rank

						  FROM auditDetails
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
		<cfreturn local.auditSearchResults>
	</cffunction>

</cfcomponent>