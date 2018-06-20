<cfcomponent displayname="userProfile" hint="Have different user Profile functions" output="true">

	<!--- Function to user profile --->
	<cffunction name="fncAddUserProfile" returntype="any" access="remote">
		<cfargument name="sAttUid" required="yes" type="string">
		<cfargument name="sProfileUrl" required="yes" type="string">

		<cfscript>
			LOCAL.objUserProfile = EntityLoad("User_profile", {ATT_UID: ARGUMENTS.sAttUid});

			if(ArrayLen(LOCAL.objUserProfile)){
				LOCAL.objUpdUserProfile = EntityLoad("User_profile", {ATT_UID: ARGUMENTS.sAttUid}, true);

			}else{
				LOCAL.objUpdUserProfile = EntityNew("User_profile");
				LOCAL.objUpdUserProfile.setATT_UID(ARGUMENTS.sAttUid);
			}

			LOCAL.objUpdUserProfile.setUrl(ARGUMENTS.sProfileUrl);
			LOCAL.objUpdUserProfile.setLast_updated_date(Now());

			EntitySave(LOCAL.objUpdUserProfile);
		</cfscript>

		<cfoutput>Added sucessfully!!</cfoutput>
	</cffunction>

	<cffunction name="fncGetUserList" returntype="any" access="remote">

		<cfscript>
			var LOCAL.jsonData = "";
			LOCAL.objUserProfile = EntityLoad("User_profile");

			LOCAL.qUsers = EntityToQuery(LOCAL.objUserProfile);
		</cfscript>

		<cfloop query="LOCAL.qUsers">
			<cfset LOCAL.jsonData = LOCAL.jsonData & '{"attUid":"#LOCAL.qUsers.ATT_UID#"
										}' >

			<!--- Condition to ensure that the comma is not appended after the last json object --->
			<cfif LOCAL.qUsers.RecordCount NEQ LOCAL.qUsers.CurrentRow>
				<cfset LOCAL.jsonData = LOCAL.jsonData & ','>
			</cfif>
		</cfloop>

		<cfoutput>[#LOCAL.jsonData#]</cfoutput>
	</cffunction>

</cfcomponent>