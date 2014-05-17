<cfscript>
LogCF = new com.LogCF().Read(url);
result = LogCF.qry.LogCFOutString;
if (FindNoCase('</body>',result)) {
	result = Replace(result,"</body>",'<script src="OutString.js"></script></body>');
	WriteOutput(result);
} else {
	WriteOutput(result);
	WriteOutput('<script src="OutString.js"></script>');
}
</cfscript>
