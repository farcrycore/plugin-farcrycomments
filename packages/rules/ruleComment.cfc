
<cfcomponent displayname="Comments" extends="farcry.core.packages.rules.rules" hint="this rule publishes comments from multiple user defined content types" bObjectBroker="true">

	<cfproperty ftSeq="1" ftFieldset="General Details" name="nComments" type="numeric" hint="The items to be displayed" ftIncludeDecimal="false" ftLabel="Number of Comments" />
	<cfproperty ftSeq="2" ftFieldSet="General Details" name="lTypes" type="string" required="false" default="" ftType="List" ftListData="getCommentTypes" ftListDataTypename="farComment" ftRenderType="checkbox" ftLabel="Source" />
	<cfproperty ftSeq="3" ftFieldSet="General Details" name="displayMethod" type="string" hint="Display method to render this rule with." required="yes" default="displayTeaserStandard" ftType="webskin" ftTypeName="farComment" ftPrefix="displayTeaser" ftLabel="Display Method" />

	<cffunction name="getComments" access="public" output="false" returntype="query">
		<cfargument name="items" type="numeric" required="true" />
		<cfargument name="lTypes" type="string" required="true" />
		
		<cfset var qComments = queryNew("") />

		<cfquery datasource="#application.dsn#" name="qComments">
			SELECT	TOP #numberFormat(arguments.items)# objectID
			FROM	#application.dbowner#farComment
			WHERE	
				articleType IN ('#replace(arguments.ltypes,",","','","all")#') AND 
				status = 'approved'
			ORDER BY dateTimeCreated DESC
		</cfquery>
		
		<cfreturn qComments />
	</cffunction>

</cfcomponent>