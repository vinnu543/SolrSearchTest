
<cfcomponent output="false">

	<cffunction name="getFavouriteProjects" access="remote"  returntype="any" returnFormat="json">
		<cfargument name="sATTUID"  type="string"  required="no" default="ns794y" hint="Given attuid for testing">

		<cfset LOCAL.qMyFavorites = QueryNew('')>

		<cfstoredproc procedure="New.getMyProjects" datasource="#application.sqlSource#" username="#application.sqlName#" password="#application.sqlPass#">
			<cfprocparam value="#ARGUMENTS.sATTUID#" cfsqltype="cf_sql_varchar">
			<cfprocresult name="LOCAL.qMyFavorites">
		</cfstoredproc>

		<cfscript>
       		var LOCAL.aFavorites = [];
       		var LOCAL.sColumns = 'Project_ID,Project_Name,Phase,Weight,Color';
        	//create array of project structure
			for(var LOCAL.nRow=1; LOCAL.nRow<=local.qMyFavorites.RecordCount; LOCAL.nRow++) {
            	var LOCAL.stProject= createObject("java", "java.util.LinkedHashMap").init();
            	for(var LOCAL.nCol=1; LOCAL.nCol<=listLen(LOCAL.sColumns); LOCAL.nCol++) {
            		structInsert(LOCAL.stProject,listGetAt(LOCAL.sColumns, LOCAL.nCol),LOCAL.qMyFavorites[listGetAt(LOCAL.sColumns, LOCAL.nCol)][LOCAL.nRow]);
            	}
            	arrayAppend(LOCAL.aFavorites, LOCAL.stProject);
        	}
		</cfscript>

		<cfreturn LOCAL.aFavorites>
	</cffunction>

</cfcomponent>