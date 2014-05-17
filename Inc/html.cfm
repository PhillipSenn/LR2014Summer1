<cfscript>
param name="Variables.fw.Name" default=Application.afw.Name;
</cfscript>

<cfoutput>
<!DOCTYPE html>
<html lang="en" class="no-js">
<head>
<meta charset="utf-8">
<meta content="Phillip Senn" name="author">
<meta content="no-cache, no-store, must-revalidate" http-equiv="Cache-Control">
<meta content="no-cache"                            http-equiv="Pragma">
<meta content="0"                                   http-equiv="Expires">
<cfif request.rfw.css>
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<cfif IsDefined('Variables.fw.jQueryUI')>
		<!-- black-tie,blitzer,cupertino,dark-hive,dot-luv,eggplant,excite-bike,flick,hot-sneaks,humanity,le-frog,mint-choc,overcast,pepper-grinder,redmond,smoothness,south-street,start,sunny,swanky-purse,trontastic,ui-darkness,ui-lightness,vader -->
		<link rel="stylesheet" href="//ajax.googleapis.com/ajax/libs/jqueryui/1/themes/#Variables.fw.jQueryUI#/jquery-ui.css">
	</cfif>
	<link rel="stylesheet" href="/Inc/css/fw.css">
	<link rel="stylesheet" href="#Application.afw.Path#Inc/css/html.css">
</cfif>
<cfif request.rfw.js>
	<script src="//cdnjs.cloudflare.com/ajax/libs/modernizr/2.8.1/modernizr.js"></script>
</cfif>
<title>#Variables.fw.Name#</title>
</cfoutput>