
<cfcomponent displayname="Yaffa: Comments" extends="farcry.core.packages.rules.rules" hint="this rule publishes comments from multiple user defined content types" bObjectBroker="true">

	<cfproperty ftSeq="1" ftFieldset="General Details" name="nComments" type="numeric" hint="The items to be displayed" ftIncludeDecimal="false" ftLabel="Number of Comments" />
	<cfproperty ftSeq="2" ftFieldSet="General Details" name="lTypes" type="string" required="false" default="" ftType="List" ftListData="getCommentTypes" ftListDataTypename="farComment" ftRenderType="checkbox" ftLabel="Source" />
	<cfproperty ftSeq="3" ftFieldSet="General Details" name="displayMethod" type="string" hint="Display method to render this rule with." required="yes" default="displayTeaserStandard" ftType="webskin" ftTypeName="farComment" ftPrefix="displayTeaser" ftLabel="Display Method" />
	<cfproperty ftSeq="4" ftFieldSet="General Details" name="charCount" type="numeric" hint="character count of comment to show" required="no" default="40" ftDefault="40" ftLabel="Character Count" />

	<cffunction name="getComments" access="public" output="false" returntype="query">
		<cfargument name="items" type="numeric" required="true" />
		<cfargument name="lTypes" type="string" required="true" />
		
		<cfset var qComments = queryNew("") />

		<cfquery datasource="#application.dsn#" name="qComments">
			SELECT	TOP #numberFormat(arguments.items)# objectID
			FROM	#application.dbowner#farComment
			WHERE	
				articleType IN (<cfqueryparam 
                value="#arguments.ltypes#" 
                cfsqltype="CF_SQL_VARCHAR" 
                list="yes">)  AND 
				status = 'approved'
			ORDER BY dateTimeCreated DESC
		</cfquery>
		
		<cfreturn qComments />
	</cffunction>

</cfcomponent>