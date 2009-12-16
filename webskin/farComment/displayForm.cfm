<cfsetting enablecfoutputonly="true" />
<!--- @@Copyright: Daemon Pty Limited 1995-2008, http://www.daemon.com.au --->
<!--- @@License: Released Under the "Common Public License 1.0", http://www.opensource.org/licenses/cpl.php --->
<!--- @@displayname: Comment form --->
<!--- @@Description: User-side comment form --->
<!--- @@Developer: Ezra Parker (ezra@cfgrok.com) --->

<!--- @@cacheStatus: 0 --->

<!--- import tag libraries --->
<cfimport prefix="ft" taglib="/farcry/core/tags/formtools" />
<cfimport prefix="skin" taglib="/farcry/core/tags/webskin" />
<cfimport prefix="extjs" taglib="/farcry/core/tags/extjs" />


<cfif NOT structkeyexists(url, "commentAdded")>

	<ft:form name="postComment">
		<ft:object stObject="#stObj#" lFields="commentHandle,email,comment" format="edit" legend="Make a Comment" helptext="HTML not allowed.  Links will be automatically activated." />
		<ft:farcryButtonPanel>
			<ft:button value="Post Comment" bSpamProtect="true" />
			<ft:button value="Cancel" validate="false" />
		</ft:farcryButtonPanel>
	</ft:form>

</cfif>

<cfsetting enablecfoutputonly="false" />