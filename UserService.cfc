<cfcomponent displayname="UserService" output="false">

	<cffunction name="GetUserImageLink" returntype="any" returnFormat="json" access="remote">
		<!------Get Image URL from tspace profile------>
		<cftry>
			<cfset local.stUserAttributes = {} />
			<cfif StructKeyExists(SESSION,'stUserAttributes') AND StructKeyExists(SESSION.stUserAttributes,'IMAGE_URL')>
				<cfset local.stUserAttributes.IMAGE_URL = SESSION.stUserAttributes.IMAGE_URL>
			<cfelse>
				<cfset SESSION.stUserAttributes = {}>
				<cfstoredproc datasource="#application.sqlSource#" username="#application.sqlName#" password="#application.sqlPass#" procedure="New.GetUserImage">
				    <cfprocparam value="#client.ATTUID#" cfsqltype="cf_sql_varchar">
				    <cfprocresult name="LOCAL.qUserImageURL" maxrows="1">
				</cfstoredproc>
				<cfset SESSION.stUserAttributes.IMAGE_URL = LOCAL.qUserImageURL.IMAGE_URL>
				<cfset local.stUserAttributes.IMAGE_URL = LOCAL.qUserImageURL.IMAGE_URL>
			</cfif>
			<cfcatch type="any">
				<cfoutput>
					<p>#cfcatch.message#</p><p>#cfcatch.detail#</p>
				</cfoutput>
				<cfabort>
			</cfcatch>
		</cftry>
		<cfreturn local.stUserAttributes>
	</cffunction>

</cfcomponent>