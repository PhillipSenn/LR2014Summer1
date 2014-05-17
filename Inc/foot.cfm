</section>
<cfoutput>
<cfif request.fw.js>
	<!---
	<script src="Inc/isogram.js"></script>
	--->
	<script src="//code.jquery.com/jquery-2.1.1.js"></script>
	<cfif IsDefined('Variables.fw.jQueryUI')>
		<script src="//cdnjs.cloudflare.com/ajax/libs/jqueryui/1.10.4/jquery-ui.js"></script>
		<script src="//cdnjs.cloudflare.com/ajax/libs/jqueryui-touch-punch/0.2.2/jquery.ui.touch-punch.min.js"></script>
	</cfif>
	<script src="#Application.fw.Path#Inc/js/fw.js"></script>
	<script src="//cdn.PhillipSenn.com/bootstrap-3.1.1-dist/js/bootstrap.js"></script>
	<script src="#Application.fw.Path#Inc/js/dom.js"></script>
	<script src="#Application.fw.Path#Inc/js/LogJS.js"></script> <!--- Uses /edu/ --->
	<script src="#Application.fw.Path#Inc/js/LogUI.js"></script> <!--- Uses /edu/ --->
	<script src="#Application.fw.Path#Inc/js/Sortable.js"></script>
</cfif>
</cfoutput>
