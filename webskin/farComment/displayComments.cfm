<cfsetting enablecfoutputonly="true" />
<!--- @@displayname: Article comments --->

<!--- import tag libraries --->
<cfimport taglib="/farcry/core/tags/webskin" prefix="skin" />

<cfset qComments = getApprovedComments(articleID=arguments.stParam.articleID,order="latest-first") />

<cfloop query="qComments">
	<skin:view typename="farComment" objectid="#qComments.objectid#" webskin="displayTeaserStandard" />
</cfloop>

<cfsetting enablecfoutputonly="false" />