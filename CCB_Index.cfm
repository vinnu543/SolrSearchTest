<!--- Delete any existing collections --->
<cftry>
  <cfcollection action="delete" collection="changecontrolboard" path="#ExpandPath( '.' )#\collections\">
  <cfcatch type="any"></cfcatch>
</cftry>
<!--- Create collections for CCB --->
<cftry>
  <cfcollection action="create" collection="changecontrolboard" engine="solr" path="#ExpandPath( '.' )#\collections\">
  <cfcatch type="any"></cfcatch>
</cftry>

<!--- CCB Collections Query --->
<cfstoredproc procedure="New.getCCBCollectionsData" datasource="VishnuDBTest" username="#application.sqlName#" password="#application.sqlPass#">
	<cfprocresult name="qCCBCollections">
</cfstoredproc>
<!--- Refresh --->
<cfset local.stFieldList = structNew()>
<cfset local.sColumnList = "CMR_ID,Project_ID,PTN,Project_Name,Program_ID,Site_Name,Venue_Name,CMR_Creator,CMR_SubType,CMR_Status,FA_Location,Cluster,CCB_Region,CCB_Market,Project_Type,Project_Subtype,POD_YEAR,POE_YEAR">
<!--- build the custom field set --->
<cfloop from="1" to="#ListLen(local.sColumnList,',')#" index="local.nIndex">
<cfset local.stFieldList [listGetAt(local.sColumnList,local.nIndex) & "_s"] = listGetAt(local.sColumnList,local.nIndex) >
</cfloop>

<cfindex collection="changecontrolboard"
		 action="refresh"
		 query="qCCBCollections"
		 type="custom"
		 key= "CMR_ID"
		 title="Project_Name"
		 attributecollection="#local.stFieldList#"
		 body="CMR_ID,Project_ID,PTN,Project_Name,Program_ID,Site_Name,Venue_Name,CMR_Creator,CMR_SubType,CMR_Status,FA_Location,Cluster,CCB_Region,CCB_Market,Project_Type"/>

<!--- Log Refresh Time --->
<cfset objRefreshLog = new PerformanceLog()>
<cfset objRefreshLog.InsRefreshTimeForCollections('CCB')>

<h2>Change Control Board Indexing Complete!</h2>