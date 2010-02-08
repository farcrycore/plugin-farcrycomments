<cfsetting enablecfoutputonly="true" />
<!--- @@displayname: Article comments --->

<!--- @@cacheStatus:1 --->
<!--- @@cacheTypeWatch: farComment --->

<!--- import tag libraries --->
<cfimport taglib="/farcry/core/tags/webskin" prefix="skin" />

<cfparam name="commentsPerPage" default="50" />

<cfset qComments = getApprovedComments(articleID=arguments.stParam.articleID,order="latest-first") />

<cfif qComments.recordCount GT commentsPerPage>
	<skin:pagination 
			paginationID="comments"
			qRecordSet="#qComments#"
			typename="farComment"
			pageLinks="10"
			recordsPerPage="#commentsPerPage#" 
			Top="false" 
			Bottom="true"
			renderType="inline"
			r_stObject="stComment"> 
	
		<skin:view objectID="#stComment.objectID#" webskin="displayTeaserStandard" typename="farComment" />
			
	</skin:pagination>
<cfelse>

	<cfloop query="qComments">
		<skin:view typename="farComment" objectid="#qComments.objectid#" webskin="displayTeaserStandard" />
	</cfloop>
	
</cfif>

<cfsetting enablecfoutputonly="false" />