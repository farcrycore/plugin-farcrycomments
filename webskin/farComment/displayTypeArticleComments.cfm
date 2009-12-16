<cfsetting enablecfoutputonly="true" />
<!--- @@displayname: Article comment section --->

<!--- import tag libraries --->
<cfimport taglib="/farcry/core/tags/webskin" prefix="skin" />
<cfimport taglib="/farcry/core/tags/formtools" prefix="ft" />

<cfparam name="arguments.stParam.articleID" />
<cfparam name="arguments.stParam.articleType" />
<cfparam name="arguments.stParam.moderated" default="0" /><!--- Set to 1 to hide comments until they're reviewed --->
<cfparam name="arguments.stParam.moderators" default="" /><!--- The list of moderator profile ids, or email address, to send comment notifications to --->


<!--- ACTION --->
	<!--- Form processing needs to be done here, since the comments may be displayed before the form --->
	
	<!--- PERFORM SERVER SIDE VALIDATION --->
	<ft:serverSideValidation />
	
	<ft:processForm action="Post Comment" url="#application.fapi.fixURL(addvalues='commentAdded=true')#">
		<!--- process action items --->
		<ft:processFormObjects typename="farComment" r_stProperties="stProps">
			<cfset stProps.articleID = arguments.stParam.articleID />
			<cfset stProps.articleType = arguments.stParam.articleType />
			<cfset stProps.bApproved = not arguments.stParam.moderated />
			<!--- validate weblink --->
			<cfif structkeyexists(stProps,"website") and len(trim(stProps.website)) AND left(stProps.website,4) NEQ "http">
				<cfset stProps.website = "http://#trim(stProps.website)#" />
			</cfif>
		</ft:processFormObjects>
		
		<cfif len(lsavedobjectids)>
			<cfset notifyModerators(objectid=lsavedobjectids,moderators=arguments.stParam.moderators) />
			
			<skin:bubble title="Comment Posted" bAutoHide="false">
				<cfoutput><p>Thank you for your comment</p></cfoutput>
				
				<cfif arguments.stParam.moderated>
					<cfoutput><p>Comments on this post are moderated and so you will not see your comment until it is reviewed by a moderator.</p></cfoutput>
				</cfif>
			</skin:bubble>
		</cfif>
	</ft:processForm>
	
	<ft:processForm action="Cancel" url="#application.fapi.getLink(objectid=arguments.stParam.articleID)#" />


<!--- VIEW --->
	<cfoutput><div id="comments"></cfoutput>
		<skin:view typename="farComment" webskin="displayComments" stParam="#arguments.stParam#" />
		<skin:view typename="farComment" webskin="displayForm" key="addcomment-#arguments.stParam.articleID#" stParam="#arguments.stParam#" />
	<cfoutput></div></cfoutput>

<cfsetting enablecfoutputonly="false" />