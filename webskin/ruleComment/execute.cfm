<cfsetting enablecfoutputonly="true" />

<!--- IMPORT TAG LIBRARIES --->
<cfimport taglib="/farcry/core/tags/webskin" prefix="skin" />

<cfset qComments = getComments(stObj.nComments,stObj.lTypes) />

<cfloop query="qComments">
	<skin:view objectID="#qComments.objectID#" typename="farComment" webskin="#stObj.displayMethod#" />
</cfloop>

<cfsetting enablecfoutputonly="false" />