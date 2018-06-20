<!--- create a Solr search engine collection - only really needs to be done once, but you might want to create it on application start to make sure it exists --->
<cfcollection action="list" name="cfCollections">
<cfquery name="VARIABLES.qCollections" dbtype="query">
	SELECT * FROM cfCollections WHERE cfCollections.name = 'project'
</cfquery>

<cfif VARIABLES.qCollections.recordCount>
	<cfcollection action="delete" collection="project" path="#ExpandPath( '.' )#\collections\">
</cfif>

<cftry>
	<cfcollection action="create" collection="project" engine="solr" path="#ExpandPath( '.' )#\collections\">
	<cfcatch type="any">
		<!--- collection already exists --->
	</cfcatch>
</cftry>

<cfstoredproc procedure="New.uspGetProjectCollectionData" datasource="#APPLICATION.sqlSource#">
	<cfprocresult name="VARIABLES.qProjectCollection">
</cfstoredproc>


<cfset VARIABLES.stFieldList = StructNew()>
<cfset VARIABLES.sColumnList = "PROJECT_ID,VENUE_NAME,PROJECT_NAME,VENUE_TYPE,ASG_PHASE,ADDRESS_LINE_1,VENUE_CITY,VENUE_STATE,ORACLE_PTN,REGION_2,FA_LOCATION,MARKET_NAME,POE_YEAR,POD_YEAR,POR_YEAR,Site_Name,USID,Cnq_Location_Cluster,Funding_Type,Build_Type,Contract_Responsibility,Project_Type,Project_Subtype,Solution_Type">

<!--- build the custom field set --->
<cfloop from="1" to="#ListLen(VARIABLES.sColumnList, ',')#" index="VARIABLES.nIndex">
	<cfset VARIABLES.stFieldList[ListGetAt(VARIABLES.sColumnList, VARIABLES.nIndex) & "_s"] = ListGetAt(VARIABLES.sColumnList, VARIABLES.nIndex)>
</cfloop>


<!--- populate collection with pages - only really needs to be done if records have changed in the database --->
<cfindex
	collection="project"
	action="refresh"
	type="custom"
	query="VARIABLES.qProjectCollection"
	key="PROJECT_ID"
	title="PROJECT_NAME"
	attributecollection="#VARIABLES.stFieldList#"
	body="PROJECT_ID
		,VENUE_NAME
		,PROJECT_NAME
		,VENUE_TYPE
		,ASG_PHASE
		,ADDRESS_LINE_1
		,VENUE_CITY
		,VENUE_STATE
		,ORACLE_PTN
		,REGION_2
		,FA_LOCATION
		,MARKET_NAME"
/>

<!--- Log Refresh Time --->
<cftry>
    <cfset objRefreshLog = new service.global.PerformanceLog()>
    <cfset objRefreshLog.InsRefreshTimeForCollections('Project')>
    <cfcatch type="any"></cfcatch>
</cftry>
<h2>Project Indexing Complete</h2>