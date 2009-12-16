<cfsetting enablecfoutputonly="true" />
<!--- @@displayname: Comment --->

<cfif NOT len(stObj.commentHandle)>
	<cfset stObj.commentHandle = "Secret Admirer" />
</cfif>
<cfif len(stObj.website)>
	<cfset stObj.commentHandle = '<a href="#stObj.website#" target="_blank">#stObj.commentHandle#</a>' />
</cfif>

<cfoutput>
	<div class="comment" id="comment-#stobj.objectid#">
		<p>
			#stObj.comment#<br />
			<cite>
				<span><strong>#stObj.commentHandle#</strong> on #dateformat(stObj.dateTimeCreated)# #timeformat(stObj.dateTimeCreated)#</span>
			</cite>
		</p>
	</div>
</cfoutput>

<cfsetting enablecfoutputonly="true" />