
<!--- Delete any existing collections for CCB --->
<cftry>
  <cfcollection action="delete" collection="contracts" path="#ExpandPath( '.' )#\collections\">
  <cfcatch type="any"></cfcatch>
</cftry>
<!--- Create collections for CCB --->
<cftry>
  <cfcollection action="create" collection="contracts" engine="solr" path="#ExpandPath( '.' )#\collections\">
  <cfcatch type="any"></cfcatch>
</cftry>
<!--- CCB Collections Query --->
<cfstoredproc procedure="New.getContractCollectionsData" datasource="#application.sqlSource#" username="#application.sqlName#" password="#application.sqlPass#">
	<cfprocresult name="qContractCollections">
</cfstoredproc>

<!--- start --->
<cfset local.stFieldList = structNew()>
<cfset local.sColumnList = "Contract_Status,Contract_Type,Contract_Title,Project_ID,PTN,Project_Name,Site_Name,Venue_Name,Address,City,State,FA_Location,DAS_Owner,Project_Type,Project_Subtype,POD_YEAR,POE_YEAR,USID">
<!--- build the custom field set --->
<cfloop from="1" to="#ListLen(local.sColumnList,',')#" index="local.nIndex">
    <cfset local.stFieldList [listGetAt(local.sColumnList,local.nIndex) & "_s"] = listGetAt(local.sColumnList,local.nIndex) >
</cfloop>

<cfindex action="refresh"
	collection="contracts"
	attributecollection="#local.stFieldList#"
	type="custom"
	query="qContractCollections"
	body="Contract_ID,Contract_Status,Contract_Type,Contract_Title,Project_ID,PTN,Project_Name,Site_Name,Venue_Name,Address,City,State,FA_Location,DAS_Owner,Project_Type,USID"
	key= "Contract_ID"
/>

<!--- Log Refresh Time --->
<cfset objRefreshLog = new PerformanceLog()>
<cfset objRefreshLog.InsRefreshTimeForCollections('Contracts')>

<h2>Contracts Indexing Complete!</h2>