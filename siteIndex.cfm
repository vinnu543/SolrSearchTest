<!--- create a Solr search engine collection - only really needs to be done once, but you might want to create it on application start to make sure it exists --->
<cfcollection action="list" name="cfCollections">
<cfquery name="VARIABLES.qCollections" dbtype="query">
	SELECT * FROM cfCollections WHERE cfCollections.name = 'site'
</cfquery>

<cfif VARIABLES.qCollections.recordCount>
	<cfcollection action="delete" collection="site" path="#ExpandPath( '.' )#\collections\">
</cfif>

<cftry>
	<cfcollection action="create" collection="site" engine="solr" path="#ExpandPath( '.' )#\collections\">
	<cfcatch type="any">
		<!--- collection already exists --->
	</cfcatch>
</cftry>

<cfstoredproc procedure="New.uspGetSiteCollectionData" datasource="#APPLICATION.sqlSource#">
	<cfprocresult name="VARIABLES.qSiteCollection">
</cfstoredproc>

<cfset VARIABLES.stFieldList = StructNew()>
<cfset VARIABLES.sColumnList = "Financial_Location,Site_Name,USID,Region,Street_Address,City,Zip,Market,Cluster,State,Site_Type,Contract_Responsibility,PROJECT_ID,PROJECT_NAME,ORACLE_PTN,VENUE_NAME">

<!--- build the custom field set --->
<cfloop from="1" to="#ListLen(VARIABLES.sColumnList, ',')#" index="VARIABLES.nIndex">
	<cfset VARIABLES.stFieldList[ListGetAt(VARIABLES.sColumnList, VARIABLES.nIndex) & "_s"] = ListGetAt(VARIABLES.sColumnList, VARIABLES.nIndex)>
</cfloop>


<!--- populate collection with pages - only really needs to be done if records have changed in the database --->
<cfindex
	collection="site"
	action="refresh"
	query="VARIABLES.qSiteCollection"
	key="Financial_Location"
	title="Site_Name"
	attributecollection="#VARIABLES.stFieldList#"
	body="
		Financial_Location
		,Site_Name
		,USID
		,Region
		,Street_Address
		,City
		,Zip
		,Market
		,Cluster
		,State
		,Site_Type
		,Contract_Responsibility
		,PROJECT_ID
		,PROJECT_NAME
		,ORACLE_PTN
		,VENUE_NAME"
/>

<!--- Log Refresh Time --->
<cfset objRefreshLog = new PerformanceLog()>
<cfset objRefreshLog.InsRefreshTimeForCollections('Site')>

<h2>Site Indexing Complete</h2>