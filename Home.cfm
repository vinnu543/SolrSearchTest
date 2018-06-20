<html>
    <head>
        <title>LOCAL MOBIUS</title>
    </head>
    <body>
		<br>
        <h1>MOBIUS SEARCH</h1>
        <br><br>
        <form action="Home.cfm" id="myForm" method="post">
		    <Label>Search : </Label>
		    <input type="text" name="searchInput" id="searchInput"/>
		    <select name="module">
				<option value="Project">Project</option>
				<option value="Audit">Audit</option>
				<option value="CCB">CCB</option>
			</select>
			<input type="submit" name="Search" value="Search"><br><br>

        </form>
		<cfif isdefined("Search")>
			<cfswitch expression="#form.module#">
				<cfcase value="Project">
					<cfinvoke
					    component="projectSearch"
					    method="fncSearchProject"
					    sSearchKey="#form.searchInput#"
					    returnVariable="qProjectResults">
				</cfcase>
				<cfcase value="CCB">
                    <cfinvoke
                        component="CCBSearch"
                        method="SearchForCCB"
                        sSearchKey="#form.searchInput#"
                        returnVariable="qCCBResults">
				</cfcase>
                <cfcase value="Audit">
                    <cfinvoke
                        component="AuditSearch"
                        method="SearchForAudit"
                        sSearchKey="#form.searchInput#"
                        returnVariable="qAuditResults">
				</cfcase>
			</cfswitch>
		</cfif>
    </body>
</html>