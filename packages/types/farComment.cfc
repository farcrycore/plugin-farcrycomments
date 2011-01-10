6<cfcomponent displayname="Comment" hint="Generic comment" extends="farcry.core.packages.types.types" output="false" bObjectBroker="1">

	<!--- properties --->
	<cfproperty ftSeq="1"  name="articleID" type="UUID" required="false" default="" hint="Article content object reference" ftLabel="Article" />
	<cfproperty ftSeq="2" ftFieldset="Comment" name="articleType" type="string" required="false" default="" hint="Article content type" ftLabel="Article type" ftType="list" ftListData="getTypes" />
	
	<cfproperty ftSeq="11" ftFieldset="Comment" name="commentHandle" type="string" required="false" default="" hint="Name or handle of poster" ftLabel="Name" ftValidation="required" />
	<cfproperty ftSeq="12" ftFieldset="Comment" name="location" type="string" required="false" default="" hint="location of poster"  ftLabel="Location" />
	<cfproperty ftSeq="13" ftFieldset="Comment" name="comment" type="longchar" required="false" default="" hint="The comment" ftLabel="Comment" ftValidation="required" />
	<cfproperty ftSeq="14" ftFieldset="Comment" name="email" type="string" required="false" default="" hint="Email address of poster" ftLabel="Email" />
	<cfproperty ftSeq="15" ftFieldset="Comment" name="website" type="string" required="false" default="" hint="Website address of poster" ftLabel="Website" ftType="url" />
	
	<cfproperty ftSeq="21" ftFieldset="Comment" name="status" type="string" required="true" default="approved" ftLabel="Published" />
	
	<cfproperty ftSeq="31" ftFieldset="Comment" name="profileID" type="UUID" required="false" default="" hint="A member profile if commentor is a member" ftLabel="MemberID" ftJoin="dmProfile" />
	<cfproperty ftSeq="32" ftFieldset="Comment" name="bSubscribe" type="boolean" required="true" default="0" hint="Flag for thread subscription" ftLabel="Subscribe?" ftType="boolean" />

	<!--- req taglibs --->
	<cfimport taglib="/farcry/core/tags/webskin" prefix="skin" />
	
	<cffunction name="getApprovedComments" access="public" output="false" returntype="query" hint="Returns the objectids of approved comments for an article">
		<cfargument name="articleID" type="uuid" required="true" hint="The related article" />
		<cfargument name="order" type="string" required="false" default="latest-first" hint="The order of returned comments: latest-first OR oldest-first" />
		
		<cfset var q = "" />
		
		<cfquery datasource="#application.dsn#" name="q">
			SELECT objectid
			FROM #application.dbowner#farComment
			WHERE 
				articleID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.articleID#" /> AND
				status IN (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#request.lvalidstatus#" />)
			ORDER BY datetimecreated <cfif arguments.order eq "latest-first">desc<cfelse>asc</cfif>
		</cfquery>
		
		<cfreturn q />
	</cffunction>
	
	<cffunction name="getApprovedCommentCount" access="public" output="false" returntype="numeric" hint="Returns the number of approved comments for an article">
		<cfargument name="articleID" type="uuid" required="true" hint="The related article" />
		
		<cfset var q = "" />
		
		<cfquery datasource="#application.dsn#" name="q">
			SELECT count(objectid) as nComments
			FROM #application.dbowner#farComment
			WHERE 
				articleID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.articleID#" /> AND
				status IN (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#request.lvalidstatus#" />)
		</cfquery>
		
		<cfreturn q.nComments />
	</cffunction>	
	
	<cffunction name="getTypes" access="public" output="false" returntype="query" hint="Returns the types that are currently commented on">
		<cfset var q = "" />
		<cfset var qEmpty = querynew("value,name") />
		
		<cfset queryaddrow(qEmpty) />
		<cfset querysetcell(qEmpty,"value","") />
		<cfset querysetcell(qEmpty,"name","-- select --") />
		
		<cfquery datasource="#application.dsn#" name="q">
			select distinct r.typename as [value], r.typename as [name]
			from		#application.dbowner#farComment c
						inner join
						#application.dbowner#refObjects r
						on c.articleID=r.objectid
		</cfquery>
		
		<cfloop query="q">
			<cfif structkeyexists(application.stCOAPI[q.value],"displayname")>
				<cfset querysetcell(q,"name",application.stCOAPI[q.value].displayname,q.currentrow) />
			</cfif>
		</cfloop>
		
		<cfquery dbtype="query" name="q">
			select		*
			from		qEmpty
			
			UNION
			
			select		*
			from		q
			
			order by	[name] asc
		</cfquery>
		
		<cfreturn q />
	</cffunction>
	
	<cffunction name="notifyModerators" access="public" output="false" returntype="void" hint="Sends notification emails to moderators">
		<cfargument name="objectid" type="uuid" required="true" hint="The comment objectid" />
		<cfargument name="moderators" type="string" required="true" hint="A list of email addresses and profile objectids" />
		
		<cfset var moderator = "" />
		<cfset var stProfile = structnew() />
		<cfset var stComment = application.fapi.getContentObject(objectid=arguments.objectid,typename="farComment") />
		<cfset var stObject = application.fapi.getContentObject(objectid=stComment.articleID,typename=stComment.articleType) />
		
		<cfloop list="#arguments.moderators#" index="moderator">
			<!--- If this is a UUID retrieve the related profile email address --->
			<cfif isvalid("uuid",moderator)>
				<cfset stProfile = application.fAPI.getContentObject(objectid=moderator,typename="dmProfile") />
				<cfset moderator = stProfile.emailaddress />
			</cfif>
			
			<!--- If this is a valid email address send the notification --->
			<cfif isvalid("email",moderator)>
				<cfmail from="#application.config.general.adminemail#" to="#moderator#" subject="#application.ApplicationName#: Comment added to '#stObject.label#'" type="html">
					<p>A viewer has commented on an article</p>
					<ul>
						<li>View/Approve the comment - <a href="http://#cgi.http_host#/webtop/admin/customadmin.cfm?module=customlists/farComment.cfm&plugin=farcrycomments&articleID=#stObject.objectid#" target="_blank">Comment Administration</a></li>
						<li>View the Article - <a href="http://#cgi.http_host#/index.cfm?objectid=#stObject.objectid#" target="_blank">#stObject.label#</a></li>
					</ul>
				</cfmail>
			</cfif>
		</cfloop>
	</cffunction>
	
	<cffunction name="notifySubscribers" access="public" output="false" returntype="void" hint="Sends notification emails to moderators">
		<cfargument name="objectid" type="uuid" required="true" hint="The comment objectid" />
		
		<cfset var stComment = application.fapi.getContentObject(objectid=arguments.objectid,typename="farComment") />
		<cfset var stObject = application.fapi.getContentObject(objectid=stComment.articleID,typename=stComment.articleType) />
		<cfset var qSubscribers = "" />
		
		<cfparam name="application.config.comments.siteurl" default="#cgi.server_name#">
		
		<cfquery datasource="#application.dsn#" name="qSubscribers">
			select		email, objectID AS commentObjID
			from		#application.dbowner#farComment
			where		articleID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#stObject.objectid#" />
						and bSubscribe=<cfqueryparam cfsqltype="cf_sql_bit" value="1" />
						and not email=<cfqueryparam cfsqltype="cf_sql_varchar" value="" />
						and not objectid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#stComment.objectid#" />
		</cfquery>
		
		
		<cfloop query="qSubscribers">
			<!--- If this is a valid email address send the notification --->
			<cfif isvalid("email",qSubscribers.email)>
				<cfmail from="#application.config.general.adminemail#" to="#qSubscribers.email#" subject="#application.ApplicationName#: Comment added to '#stObject.label#'" type="html">
					<cfoutput>
						<p>A new comment has been posted.</p>
						
						<p>Article: 
					</cfoutput>
					<cfset link=application.fapi.getLink(objectid=stObject.objectID,includeDomain=true,domain=application.config.comments.siteurl)>
					<cfoutput>
						<a href="#link#">#stObject.label#</a>
					</cfoutput>
					
					<cfoutput>
						</p>
						<p>
					</cfoutput>

					<skin:buildLink includeDomain="1" objectID="#commentObjID#" bodyView="displayUnsubscribe">
						<cfoutput>Unsubscribe from this article</cfoutput>
					</skin:buildLink>
					
					<cfoutput>
						</p>
					</cfoutput>

				</cfmail>
			</cfif>
		</cfloop>
	</cffunction>
	
	<cffunction name="unsubscribe" access="public" output="false" returntype="void">
		<cfargument name="objectid" type="uuid" required="true" hint="The comment objectid" />
		
		<cfset var qSubscribe = queryNew("") />
		
		<cfquery datasource="#application.dsn#" name="qSubscribers">
			UPDATE farComment
			SET bSubscribe = 0
			WHERE objectID = <cfqueryparam value="#arguments.objectID#" cfsqltype="cf_sql_varchar" />
		</cfquery>
		
		<cfreturn />
	</cffunction>
	
	<cffunction name="transferComments" access="public" output="false" returntype="void" hint="Transfers comments between objects">
		<cfargument name="fromID" type="uuid" required="true" hint="The current article ID" />
		<cfargument name="toID" type="uuid" required="true" hint="The new article ID" />
		<cfargument name="toType" type="string" required="false" hint="The type of the new article" />
		
		<cfset var qComments = "" />
		<cfset var stComment = structnew() />
		
		<cfif not structkeyexists(arguments,"toType")>
			<cfset arguments.toType = application.fapi.findType(objectid=arguments.toType) />
		</cfif>
		
		<cfquery datasource="#application.dsn#" name="qComments">
			select	objectid
			from	#application.dbowner#farComment
			where	articleID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fromID#" />
		</cfquery>
		
		<cfloop query="qComments">
			<cfset stComment = structnew() />
			<cfset stComment.objectid = qComments.objectid />
			<cfset stComment.articleID = arguments.toID />
			<cfset stComment.articleType = arguments.toType />
			<cfset setData(stProperties=stComment) />
		</cfloop>
	</cffunction>

	<cffunction name="getCommentTypes" access="public" output="false">
		
		<cfset var q = "" />
		
		<cfquery datasource="#application.dsn#" name="q">
			select distinct articleType
			from #application.dbowner#farComment
			order by articleType DESC
		</cfquery>
		
		<cfreturn valueList(q.articleType) />
	</cffunction>
	
</cfcomponent>