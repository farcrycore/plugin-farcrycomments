<cfsetting enablecfoutputonly="true" />
<!--- @@Copyright: Daemon Pty Limited 1995-2008, http://www.daemon.com.au --->
<!--- @@License: Released Under the "Common Public License 1.0", http://www.opensource.org/licenses/cpl.php --->
<!--- @@displayname: Comment form --->
<!--- @@Description: User-side comment form --->
<!--- @@Developer: Ezra Parker (ezra@cfgrok.com) --->

<!--- @@cacheStatus: 1 --->

<!--- import tag libraries --->
<cfimport prefix="ft" taglib="/farcry/core/tags/formtools" />
<cfimport prefix="skin" taglib="/farcry/core/tags/webskin" />

<cfif NOT structkeyexists(url, "commentAdded")>
	
	<cfif structKeyExists(arguments.stParam, "lFields")>
		<cfset lFields = arguments.stParam.lFields />
	<cfelse>
		<cfif arguments.stParam.bAllowSubscriptions>
			<cfset lFields = "commentHandle,email,bSubscribe,comment" />
		<cfelse>
			<cfset lFields = "commentHandle,email,comment" />
		</cfif>
	</cfif>
	
	<ft:form name="postComment">
		<ft:object stObject="#stObj#" lFields="#lFields#" format="edit" legend="Make a Comment" helptext="HTML not allowed.  Links will be automatically activated." />
		<ft:farcryButtonPanel>
			<ft:button value="Post Comment" bSpamProtect="true" />
			<ft:button value="Cancel" validate="false" />
		</ft:farcryButtonPanel>
	</ft:form>
	
	<cfoutput>*Required field</cfoutput>

</cfif>

<cfsetting enablecfoutputonly="false" />