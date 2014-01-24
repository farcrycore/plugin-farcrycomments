<cfsetting enablecfoutputonly="true">

<cfimport taglib="/farcry/core/tags/formtools" prefix="ft" />

<cfif structKeyExists(form,"objectid")>
	<cfset form.selectedObjectid = form.objectid />
</cfif>

<ft:processform action="Approve Comment">
	<cfset oComment = createObject("component",application.stCOAPI.farComment.packagepath) />
	<cfif structKeyExists(form,"selectedObjectid") AND len(form.selectedObjectid)>
		<cfloop list="#form.selectedObjectid#" index="ID">
			<cfset stComment = structNew() />
			<cfset stComment.objectid = ID />
			<cfset stComment.status = "approved" />
			<cfset oComment.setData(stProperties=stComment) />
			<cfset oComment.notifySubscribers(objectid=stComment.objectid) />
		</cfloop>
	</cfif>
</ft:processform>

<cfscript>
	//This data structure is used to create the buttons
	//remember to delimit dynamic expressions ##
	aButtons=arrayNew(1);

	// Approve Comment button
		stBut=structNew();
		stBut.type="button";
		stBut.name="approveComment";
		stBut.value="Approve Comment";
		stBut.class="f-submit";
		stBut.onClick="";
		stBut.permission="";
		stBut.confirmText="Are you sure you wish to approve these comments?";
		
		stBut.buttontype="approve";
		arrayAppend(aButtons,stBut);
		
	// delete object(s)
		stBut=structNew();
		stBut.type="button";
		stBut.name="deleteAction";
		stBut.value="#application.rb.getResource("delete")#";
		stBut.class="f-submit";
		// todo: i18n
		stBut.onClick="";
		stBut.confirmText="Are you sure you wish to delete these comments?";
		stBut.permission="";
		stBut.buttontype="delete";
		arrayAppend(aButtons,stBut);
</cfscript>

<cfif isdefined("url.articleID")>
	<cfset sqlwhere = "articleID in ('#listchangedelims(url.articleID,"','")#')">
	<cfset stArticle = application.fapi.getContentObject(objectid=listfirst(url.articleID)) />
	<cfset title = "Comments for #stArticle.label#" />
	<cfif listlen(url.articleID) gt 1>
		<cfset title = "#title# et al." />
	</cfif>
<cfelseif isdefined("url.articleType")>
	<cfset sqlwhere = "articleType in ('#listchangedelims(url.articleType,"','")#')">
	<cfif structkeyexists(application.stCOAPI[listfirst(url.articleType)],"displayname")>
		<cfset title = "Comments for #application.stCOAPI[listfirst(url.articleType)].displayname#" />
	</cfif>
	<cfif listlen(url.articleType) gt 1>
		<cfset title = "#title# et al." />
	</cfif>
<cfelse>
	<cfset sqlwhere = "" />
	<cfset title = "Comments" />
</cfif>

<cfif structKeyExists(url,"status")>
	<cfset sqlWhere = "#sqlWhere# AND status='#url.status#'" />
</cfif>

<!--- remove validation --->
<cfset stFilterMetaData = StructNew() />
<cfset stFilterMetaData.commentHandle.ftValidation = "" />
<cfset stFilterMetaData.comment.ftValidation = "" />

<ft:objectAdmin
	plugin="farcrycomments"
	title="#title#"
	typename="farComment"
	ColumnList="articleType,commentHandle,comment,status,datetimecreated"
	<!--- lcustomcolumns="Article:cellArticleTitle" --->
	<!--- SortableColumns="articleType,commentHandle,comment,status,datetimecreated" --->
	<!--- lFilterFields="articleType,commentHandle,comment" --->
	<!--- sqlorderby="datetimecreated DESC" --->
	<!--- sqlwhere="#sqlwhere#" --->
	<!--- aButtons="#aButtons#" --->
	lcustomactions="Approve Comment" 
	stFilterMetaData="#stFilterMetaData#" />

<cfsetting enablecfoutputonly="false">
