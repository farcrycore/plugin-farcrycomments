<cfsetting enablecfoutputonly="true">

<cfimport taglib="/farcry/core/tags/formtools" prefix="ft" />
<cfimport taglib="/farcry/core/tags/admin/" prefix="admin" />

<cfif structKeyExists(form,"objectid")>
	<cfset form.selectedObjectid = form.objectid />
</cfif>

<ft:processform action="Approve Comment">
	<cfset oComment = createObject("component",application.stCOAPI.farComment.packagepath) />
	<cfif structKeyExists(form,"selectedObjectid") AND len(form.selectedObjectid)>
		<cfloop list="#form.selectedObjectid#" index="ID">
			<cfset stComment = structNew() />
			<cfset stComment.objectid = ID />
			<cfset stComment.bApproved = true />
			<cfset oComment.setData(stProperties=stComment) />
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


<!--- set up page header --->
<admin:header title="Comments Administration" />

<ft:objectAdmin
	plugin="farcrycomments"
	title="Comments Administration"
	typename="farComment"
	ColumnList="articleType,commentHandle,comment,bApproved,datetimecreated"
	lcustomcolumns="Article:cellArticleTitle"
	SortableColumns="articleType,commentHandle,comment,bApproved,datetimecreated"
	lFilterFields="articleType,commentHandle,comment"
	sqlorderby="datetimecreated DESC"
	aButtons="#aButtons#"
	lcustomactions="Approve Comment" />

<admin:footer />

<cfsetting enablecfoutputonly="no">
