<cfsetting enablecfoutputonly="true" />
<!--- @@displayname: Article Title object admin cell --->

<cfimport taglib="/farcry/core/tags/webskin" prefix="skin" />

<skin:view objectid="#stObj.articleID#" typename="#stObj.articleType#" webskin="librarySelected" />

<cfsetting enablecfoutputonly="false" />