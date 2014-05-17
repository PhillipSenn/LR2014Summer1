<cfscript>
param name='Variables.fw.navbar' default='navbar-fixed-top';
param name='Variables.fw.container' default=true;
if (IsDefined("Variables.showProgress") && Variables.showProgress) {
	progress = "progress";
	Variables.PctComplete = Score.qry.PctComplete;
	if (PctComplete >= 100) {
		if (Score.qry.Earned >= 100) {
			progress &= " active progress-striped"; // This won't show if the student gets points taken off and can't make them up (Multiple choice).
		}
	}
}
// request.rfw.msg = 'test'
</cfscript>

</head>
<body>
<cfoutput>
<nav class="navbar-default #Variables.fw.navbar#">
	<div class="navbar-inverse">
		<div class="container">
			<cfif IsDefined('session.Usr')>
				<div class="navbar-header">
					<button type="button" class="navbar-toggle" data-toggle="collapse" data-target="##collapse">
						<span class="icon-bar"></span>
						<span class="icon-bar"></span>
						<span class="icon-bar"></span>
					</button>
					<a class="navbar-brand" href="/">Lenoir-Rhyne.com</a>
				</div>
				<div class="collapse navbar-collapse" id="collapse">
					<ul class="nav navbar-nav">
						<li><a href="Progress/Progress.cfm">Progress</a></li>
					</ul>
					<ul class="nav navbar-nav navbar-right">
						<li class="active dropdown">
						<a href="##" class="dropdown-toggle" data-toggle="dropdown">Profile <b class="caret"></b></a>
						<ul class="dropdown-menu">
							<li><a href="#Application.afw.Path#Person/Person.cfm">Edit my profile</a></li>
							<li class="divider"></li>
							<li><a href="/TPT/Login/Logout.cfm?Logout">Logout</a></li>
						</ul>
						</li>
					</ul>
				</div>
			<cfelse>
				<div class="navbar-header">
					<button type="button" class="navbar-toggle" data-toggle="collapse" data-target="##collapse">
						<span class="icon-bar"></span>
						<span class="icon-bar"></span>
						<span class="icon-bar"></span>
					</button>
					<a class="navbar-brand" href="//lr.edu">LR.edu</a>
				</div>
			</cfif>
			</div>
		</div>
	</div>
	<cfif request.rfw.msg NEQ ''>
		<div class="msg container #request.rfw.modifier#">
			#request.rfw.msg#
		</div>
	<cfelseif IsDefined("Variables.showProgress") AND Variables.showProgress>
		<div class="msg container #progress#">
			<div class="progress-bar" style="width: #Int(PctComplete)#%"></div>
		</div>
	<cfelse>
		<div class="msg container">
		</div>
	</cfif>
</nav>
<section id="main" class="<cfif Variables.fw.Container>container<cfelse>noContainer</cfif>"<cfif request.rfw.hidden && request.rfw.css && request.rfw.js> hidden</cfif>>
</cfoutput>
