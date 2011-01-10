<cfcomponent displayname="Comments configuration" hint="Configuration for Comments" 
	extends="farcry.core.packages.forms.forms" output="false" key="Comments">
	
	<cfproperty 
		ftSeq="1" 
		ftWizardStep="" 
		ftFieldset="" 
		name="bModerate"
		type="boolean"
		fttype="list"
		ftList="0:Publish comments without moderation,1:Comments require moderation"
		ftrendertype="radio" 
		ftLabel="Moderation" 
		hint="Moderation on or off" 
		default="1"
		/>	

	<cfproperty 
		ftSeq="2" 
		ftFieldset="" 
		name="moderators" 
		type="string" 
		default="" 
		hint="Moderators (seperate multiple with comma) " 
		ftLabel="Moderators" 
		ftType="string" />

	<cfproperty ftSeq="1" 
		ftFieldset="Site Description" 
		name="siteurl" 
		type="string" 
		default="" 
		hint="???"
		ftLabel="Site Primary Url" 
		ftType="string" />		
	

		
</cfcomponent>