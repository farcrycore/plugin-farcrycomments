<!--- import tag libraries --->
<cfimport taglib="/farcry/core/tags/webskin" prefix="skin" />
<cfimport taglib="/farcry/core/tags/formtools" prefix="ft" />

<cfloop list="articleID,articleType,bAllowFurtherComments,bAllowSubscriptions" index="stLocal.thisparam">
	<cfif structkeyexists(url,stLocal.thisparam)>
		<cfset arguments.stParam[stLocal.thisparam] = url[stLocal.thisparam] />
	</cfif>
</cfloop>

<cfparam name="arguments.stParam.articleID" />
<cfparam name="arguments.stParam.articleType" />
<cfset stLocal.stArticle = application.fapi.getContentObject(typename=arguments.stParam.articleType,objectid=arguments.stParam.articleID) />
<cfparam name="arguments.stParam.moderated" default="#application.fapi.getConfig('comments','bmoderate', 0)#" /><!--- Set to 1 to hide comments until they're reviewed --->
<cfparam name="arguments.stParam.moderators" default="#listappend(application.fapi.getConfig('comments','moderators', ''),stLocal.stArticle.ownedby)#" /><!--- The list of moderator profile ids, or email address, to send comment notifications to --->
<cfparam name="arguments.stParam.bAllowFurtherComments" default="1" /><!--- Set to 0 to disable comment posting --->
<cfparam name="arguments.stParam.bAllowSubscriptions" default="0" /><!--- Set to 1 to allow commenters to subscribe to the comment thread --->


<!--- ACTION --->
	<!--- Form processing needs to be done here, since the comments may be displayed before the form --->
	
	
	<ft:processForm action="Post Comment" url="#application.fapi.fixURL(addvalues='commentAdded=true')#" bSpamProtect="true">
		<!--- process action items --->
		<ft:processFormObjects typename="farComment" r_stProperties="stProps">
			<cfset stProps.articleID = arguments.stParam.articleID />
			<cfset stProps.articleType = arguments.stParam.articleType />
			<cfif arguments.stParam.moderated>
				<cfset stProps.status = "draft" />
			<cfelse>
				<cfset stProps.status = "approved" />
			</cfif>
			<cfif isdefined("session.dmProfile.objectid")>
				<cfset stProps.profileID = session.dmProfile.objectid />
			</cfif>
			<!--- validate weblink --->
			<cfif structkeyexists(stProps,"website") and len(trim(stProps.website)) AND left(stProps.website,4) NEQ "http">
				<cfset stProps.website = "http://#trim(stProps.website)#" />
			</cfif>
		</ft:processFormObjects>
		
		<cfif len(lsavedobjectids)>
			<cfset notifyModerators(objectid=lsavedobjectids,moderators=arguments.stParam.moderators) />
			<cfset stComment = getData(objectid=lsavedobjectids) />
			<cfif stComment.status eq "approved">
				<cfset notifySubscribers(objectid=lsavedobjectids) />
			</cfif>
			
			<cfsavecontent variable="stLocal.message">
				<cfoutput><p>Thank you for your comment</p></cfoutput>
				
				<cfif arguments.stParam.moderated>
					<cfoutput><p>Comments on this post are moderated and so you will not see your comment until it is reviewed by a moderator.</p></cfoutput>
				</cfif>
			</cfsavecontent>
			
			<skin:bubble title="Comment Posted" message="#stLocal.message#" bAutoHide="false" />
		</cfif>
	</ft:processForm>
	
	<ft:processForm action="Cancel" url="#application.fapi.getLink(objectid=arguments.stParam.articleID)#" />


	<!--- VIEW --->
	<cfoutput><div id="comments"></cfoutput>
		<skin:view typename="farComment" webskin="displayComments" stParam="#arguments.stParam#" />
		<cfif arguments.stParam.bAllowFurtherComments>	
			<skin:view typename="farComment" webskin="displayForm" key="addcomment-#arguments.stParam.articleID#" stParam="#arguments.stParam#" />
		</cfif>
	<cfoutput></div></cfoutput>

<cfsetting enablecfoutputonly="false" />