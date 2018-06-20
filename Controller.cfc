
<cfcomponent output="false">

	<cffunction name="SearchHandler" returnType="any" returnFormat="JSON" access="remote" output="false" hint="Receives input from Angular UI, invokes respective module search and returns result in JSON format">
		<cfscript>
			LOCAL.sSearchResultJSON = '';
			VARIABLES.nNumberOfRecordsPerPage = 25;
			VARIABLES.sColumnList = "ID,Title,Summary,URL,Rank,Recently_Visited_Dt";

			LOCAL.stParams = {};
			LOCAL.requestBody = toString(getHttpRequestData().content);
			if(len(LOCAL.requestBody)){
				structAppend(LOCAL.stParams,deSerializeJSON(LOCAL.requestBody));
			}
			if(StructKeyExists(LOCAL.stParams,'sModule') and StructKeyExists(LOCAL.stParams,'sSearchKey') and StructKeyExists(LOCAL.stParams,'nRefNo')){

				switch("#LOCAL.stParams.sModule#"){
					case "project":
							objProject = new projectSearch();
							LOCAL.qProjectResultsSorted = QueryNew('');
							LOCAL.bSearchResultExists = objProject.fncCheckUserSearchSESSION(LOCAL.stParams.sModule, LOCAL.stParams.sSearchKey);
							if(LOCAL.bSearchResultExists){
								LOCAL.qProjectResultsSorted = SESSION.qUserSearchSortedResults;
							}
							else{
								LOCAL.sSolrExpression = objProject.ExpressionConversion(LOCAL.stParams.sSearchKey);
								LOCAL.qProjectSearchResults = objProject.fncSearchProject(LOCAL.sSolrExpression, LOCAL.stParams.nRefNo);
								if (LOCAL.qProjectSearchResults.RecordCount GT 0){
									LOCAL.qProjectResultsSorted = objProject.sortByUserFavorites(LOCAL.qProjectSearchResults, 'Project', LOCAL.stParams.sSearchKey);
									objProject.fncSetUserSearchSESSION(LOCAL.qProjectResultsSorted, LOCAL.stParams.sModule, LOCAL.stParams.sSearchKey);
								}
							}
							LOCAL.qProjectResultsPaginated = objProject.fncGetPaginatedResult(LOCAL.qProjectResultsSorted, LOCAL.stParams.nRefNo, VARIABLES.nNumberOfRecordsPerPage);
							LOCAL.sSearchResultJSON = objProject.getFormattedResultSet(LOCAL.qProjectResultsPaginated, 'Project', LOCAL.stParams.nRefNo,LOCAL.qProjectResultsSorted.RecordCount,VARIABLES.nNumberOfRecordsPerPage,VARIABLES.sColumnList);
							//Function call for logging Result
							LOCAL.logResult = objProject.logResultSet(SerializeJSON(LOCAL.sSearchResultJSON["Search_Results"]),LOCAL.qProjectResultsSorted,LOCAL.stParams.sModule,LOCAL.stParams.sSearchKey,LOCAL.stParams.nRefNo);
							break;

					case "site":
							objSite = new siteSearch();
							LOCAL.qSiteResultsSorted = QueryNew('');
							LOCAL.bSearchResultExists = objSite.fncCheckUserSearchSESSION(LOCAL.stParams.sModule, LOCAL.stParams.sSearchKey);
							if(LOCAL.bSearchResultExists){
								LOCAL.qSiteResultsSorted = SESSION.qUserSearchSortedResults;
							}
							else{
								LOCAL.qSiteSearchResults = objSite.fncSearchSite(LOCAL.stParams.sSearchKey, LOCAL.stParams.nRefNo);
								if (LOCAL.qSiteSearchResults.RecordCount GT 0){
									LOCAL.qSiteResultsSorted = objSite.sortByUserFavorites(LOCAL.qSiteSearchResults, LOCAL.stParams.sModule, LOCAL.stParams.sSearchKey);
									objSite.fncSetUserSearchSESSION(LOCAL.qSiteResultsSorted, LOCAL.stParams.sModule, LOCAL.stParams.sSearchKey);
								}
							}
							LOCAL.qSiteResultsPaginated = objSite.fncGetPaginatedResult(LOCAL.qSiteResultsSorted, LOCAL.stParams.nRefNo, VARIABLES.nNumberOfRecordsPerPage);
							LOCAL.sSearchResultJSON = objSite.getFormattedResultSet(LOCAL.qSiteResultsPaginated, LOCAL.stParams.sModule, LOCAL.stParams.nRefNo,LOCAL.qSiteResultsSorted.RecordCount,VARIABLES.nNumberOfRecordsPerPage,VARIABLES.sColumnList);
							//Function call for logging Result
							LOCAL.logResult = objSite.logResultSet(SerializeJSON(LOCAL.sSearchResultJSON["Search_Results"]),LOCAL.qSiteResultsSorted,LOCAL.stParams.sModule,LOCAL.stParams.sSearchKey,LOCAL.stParams.nRefNo);
							break;

					case "ccb":
							objCCB = new CCBSearch();
							LOCAL.qCCBResultsSorted = QueryNew('');
							LOCAL.bSearchResultExists = objCCB.fncCheckUserSearchSESSION(LOCAL.stParams.sModule, LOCAL.stParams.sSearchKey);
							if(LOCAL.bSearchResultExists){
								LOCAL.qCCBResultsSorted = SESSION.qUserSearchSortedResults;
							}
							else{
								LOCAL.qCCBSearchResults = objCCB.searchForCCB(LOCAL.stParams.sSearchKey, LOCAL.stParams.nRefNo);
								if (LOCAL.qCCBSearchResults.RecordCount GT 0){
									LOCAL.qCCBResultsSorted = objCCB.sortByUserFavorites(LOCAL.qCCBSearchResults, LOCAL.stParams.sModule, LOCAL.stParams.sSearchKey);
									objCCB.fncSetUserSearchSESSION(LOCAL.qCCBResultsSorted, LOCAL.stParams.sModule, LOCAL.stParams.sSearchKey);
								}
							}
							LOCAL.qCCBResultsPaginated = objCCB.fncGetPaginatedResult(LOCAL.qCCBResultsSorted, LOCAL.stParams.nRefNo, VARIABLES.nNumberOfRecordsPerPage);
							LOCAL.sSearchResultJSON = objCCB.getFormattedResultSet(LOCAL.qCCBResultsPaginated, LOCAL.stParams.sModule, LOCAL.stParams.nRefNo,LOCAL.qCCBResultsSorted.RecordCount,VARIABLES.nNumberOfRecordsPerPage,VARIABLES.sColumnList);
							//Function call for logging Result
							LOCAL.logResult = objCCB.logResultSet(SerializeJSON(LOCAL.sSearchResultJSON["Search_Results"]),LOCAL.qCCBResultsSorted,LOCAL.stParams.sModule,LOCAL.stParams.sSearchKey,LOCAL.stParams.nRefNo);
							break;

					case "audit":
							objAudit = new AuditSearch();
							LOCAL.qAuditResultsSorted = QueryNew('');
							LOCAL.bSearchResultExists = objAudit.fncCheckUserSearchSESSION(LOCAL.stParams.sModule, LOCAL.stParams.sSearchKey);
							if(LOCAL.bSearchResultExists){
								LOCAL.qAuditResultsSorted = SESSION.qUserSearchSortedResults;
							}
							else{
								LOCAL.qAuditSearchResults = objAudit.SearchForAudit(LOCAL.stParams.sSearchKey, LOCAL.stParams.nRefNo);
								if (LOCAL.qAuditSearchResults.RecordCount GT 0){
									LOCAL.qAuditResultsSorted = objAudit.sortByUserFavorites(LOCAL.qAuditSearchResults, LOCAL.stParams.sModule, LOCAL.stParams.sSearchKey);
									objAudit.fncSetUserSearchSESSION(LOCAL.qAuditResultsSorted, LOCAL.stParams.sModule, LOCAL.stParams.sSearchKey);
								}
							}
							LOCAL.qAuditResultsPaginated = objAudit.fncGetPaginatedResult(LOCAL.qAuditResultsSorted, LOCAL.stParams.nRefNo, VARIABLES.nNumberOfRecordsPerPage);
							LOCAL.sSearchResultJSON = objAudit.getFormattedResultSet(LOCAL.qAuditResultsPaginated, LOCAL.stParams.sModule, LOCAL.stParams.nRefNo,LOCAL.qAuditResultsSorted.RecordCount,VARIABLES.nNumberOfRecordsPerPage,VARIABLES.sColumnList);
							//Function call for logging Result
							LOCAL.logResult = objAudit.logResultSet(SerializeJSON(LOCAL.sSearchResultJSON["Search_Results"]),LOCAL.qAuditResultsSorted,LOCAL.stParams.sModule,LOCAL.stParams.sSearchKey,LOCAL.stParams.nRefNo);
							break;

					case "documents":
							objDoc = new DocumentSearch();
							LOCAL.qDocResultsSorted = QueryNew('');
							LOCAL.bSearchResultExists = objDoc.fncCheckUserSearchSESSION(LOCAL.stParams.sModule, LOCAL.stParams.sSearchKey);
							if(LOCAL.bSearchResultExists){
								LOCAL.qDocResultsSorted = SESSION.qUserSearchSortedResults;
							}
							else{
								LOCAL.qDocSearchResults = objDoc.SearchForDocuments(LOCAL.stParams.sSearchKey, LOCAL.stParams.nRefNo);
								if (LOCAL.qDocSearchResults.RecordCount GT 0){
									LOCAL.qDocResultsSorted = objDoc.sortByUserFavorites(LOCAL.qDocSearchResults, LOCAL.stParams.sModule, LOCAL.stParams.sSearchKey);
									objDoc.fncSetUserSearchSESSION(LOCAL.qDocResultsSorted, LOCAL.stParams.sModule, LOCAL.stParams.sSearchKey);
								}
							}
							LOCAL.qDocResultsPaginated = objDoc.fncGetPaginatedResult(LOCAL.qDocResultsSorted, LOCAL.stParams.nRefNo, VARIABLES.nNumberOfRecordsPerPage);
							LOCAL.sSearchResultJSON = objDoc.getFormattedResultSet(LOCAL.qDocResultsPaginated, LOCAL.stParams.sModule, LOCAL.stParams.nRefNo,LOCAL.qDocResultsSorted.RecordCount,VARIABLES.nNumberOfRecordsPerPage,VARIABLES.sColumnList);
							//Function call for logging Result
							LOCAL.logResult = objDoc.logResultSet(SerializeJSON(LOCAL.sSearchResultJSON["Search_Results"]),LOCAL.qDocResultsSorted,LOCAL.stParams.sModule,LOCAL.stParams.sSearchKey,LOCAL.stParams.nRefNo);
							break;

					case "contracts":
							objContracts = new ContractsSearch();
							LOCAL.qContractsResultsSorted = QueryNew('');
							LOCAL.bSearchResultExists = objContracts.fncCheckUserSearchSESSION(LOCAL.stParams.sModule, LOCAL.stParams.sSearchKey);
							if(LOCAL.bSearchResultExists){
								LOCAL.qContractsResultsSorted = SESSION.qUserSearchSortedResults;
							}
							else{
								LOCAL.qContractsSearchResults = objContracts.SearchForContracts(LOCAL.stParams.sSearchKey, LOCAL.stParams.nRefNo);
								if (LOCAL.qContractsSearchResults.RecordCount GT 0){
									LOCAL.qContractsResultsSorted = objContracts.sortByUserFavorites(LOCAL.qContractsSearchResults, LOCAL.stParams.sModule, LOCAL.stParams.sSearchKey);
									objContracts.fncSetUserSearchSESSION(LOCAL.qContractsResultsSorted, LOCAL.stParams.sModule, LOCAL.stParams.sSearchKey);
								}
							}
							LOCAL.qContractResultsPaginated = objContracts.fncGetPaginatedResult(LOCAL.qContractsResultsSorted, LOCAL.stParams.nRefNo, VARIABLES.nNumberOfRecordsPerPage);
							LOCAL.sSearchResultJSON = objContracts.getFormattedResultSet(LOCAL.qContractResultsPaginated, LOCAL.stParams.sModule, LOCAL.stParams.nRefNo,LOCAL.qContractsResultsSorted.RecordCount,VARIABLES.nNumberOfRecordsPerPage,VARIABLES.sColumnList);
							//Function call for logging Result
							LOCAL.logResult = objContracts.logResultSet(SerializeJSON(LOCAL.sSearchResultJSON["Search_Results"]),LOCAL.qContractsResultsSorted,LOCAL.stParams.sModule,LOCAL.stParams.sSearchKey,LOCAL.stParams.nRefNo);
							break;

				}
				//Log json response for debug only
				LOCAL.objRefreshLog = new PerformanceLog();
				LOCAL.objRefreshLog.InsertJSONResponse(Session.CFToken,LOCAL.stParams.sModule,serializejson(LOCAL.sSearchResultJSON),LOCAL.stParams.nRefNo);

			}
			return serializejson(LOCAL.sSearchResultJSON);
		</cfscript>
	</cffunction>

	<cffunction name="PreviewHandler" returnType="any" returnformat="plain" access="remote" output="false" hint="Receives input from Angular UI, invokes respective module preview and returns data in HTML format">
		<cfscript>
			LOCAL.sPreviewData = "";
			objPreview = new preview();

			LOCAL.stParams = {};
			LOCAL.requestBody = toString(getHttpRequestData().content);
			if(len(LOCAL.requestBody)){
				structAppend(LOCAL.stParams,deSerializeJSON(LOCAL.requestBody));
			}

			if(StructKeyExists(LOCAL.stParams,'sModule') and StructKeyExists(LOCAL.stParams,'nKeyId') and StructKeyExists(LOCAL.stParams,'sTitle')){

				switch("#LOCAL.stParams.sModule#"){
					case "project":
							LOCAL.sPreviewData = objPreview.fncGetProjPreview(LOCAL.stParams.nKeyId);
							break;
					case "site":
							LOCAL.sPreviewData = objPreview.fncGetSitePreview(LOCAL.stParams.nKeyId);
							break;
					case "ccb":
							LOCAL.sPreviewData = objPreview.fncGetCcbPreview(LOCAL.stParams.nKeyId);
							break;
					case "audit":
							LOCAL.sPreviewData = objPreview.fncGetAuditPreview(LOCAL.stParams.nKeyId);
							break;
					case "documents":
							LOCAL.sPreviewData = objPreview.fncGetDocumentPreview(LOCAL.stParams.nKeyId,LOCAL.stParams.sTitle);
							break;
					case "contracts":
							LOCAL.sPreviewData = objPreview.fncGetContractPreview(LOCAL.stParams.nKeyId);
							break;
					case "finance":
							LOCAL.sPreviewData = objPreview.fncGetFinancePreview(LOCAL.stParams.nKeyId);
							break;
				}
			}
			return LOCAL.sPreviewData;
		</cfscript>
	</cffunction>

	<cffunction name="SearchLogHandler" access="remote" output="false" returntype="void">
		<cfscript>
			LOCAL.stParams = {};
			LOCAL.requestBody = toString(getHttpRequestData().content);
			if(len(LOCAL.requestBody)){
				structAppend(LOCAL.stParams,deSerializeJSON(LOCAL.requestBody));
			}

			if(StructKeyExists(LOCAL.stParams,'sSearchID') and StructKeyExists(LOCAL.stParams,'sSearchKey') and StructKeyExists(LOCAL.stParams,'sModule') and StructKeyExists(LOCAL.stParams,'sTitle')){
				objSearch = new Search();
				objSearch.addUserFavScore(LOCAL.stParams.sSearchID,LOCAL.stParams.sSearchKey,LOCAL.stParams.sModule,LOCAL.stParams.sTitle);
			}
		</cfscript>
	</cffunction>

</cfcomponent>