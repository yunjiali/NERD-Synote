<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional with HTML5 microdata//EN" "xhtml1-transitional-with-html5-microdata.dtd">
<html lang="en">
<head>
	<title><g:layoutTitle default="NERD Annotation Viewer" /></title>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<meta name="viewport" content="width=device-width, initial-scale=1.0"/>
	<meta name="author" content="Yunjia Li"/>
	<link rel="stylesheet" type="text/css" href="${resource(dir: 'bootstrap', file: 'css/bootstrap.min.css')}" />
	<link rel="stylesheet" type="text/css" href="${resource(dir: 'css', file: 'main.css')}" />
	<link rel="shortcut icon" href="${resource(dir: 'images/nerd', file: 'favicon-nerd.png')}" type="image/png" />
	<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js"></script>
	<script type="text/javascript" src="${resource(dir: 'bootstrap', file: 'js/bootstrap.min.js')}"></script>
	<script id="scriptInit" type="text/javascript">
		//In case I forget to remove console.log in IE
		var alertFallback = true;
		if (typeof console === "undefined" || typeof console.log === "undefined") {
		     console = {};
		     if (alertFallback) {
		         console.log = function(msg) {
		              //Do nothing
		         };
		     } else {
		         console.log = function() {};
		     }
		};
	</script>
	<g:layoutHead />
</head>
<body>
<!-- Top Navigation bar -->
	<div id="navbar_div" class="navbar" style="margin-bottom:0px !important;">
		<div class="navbar-inner">
			<div class="container">
				<a class="brand" href="#">NERD Annotation Viewer</a>
				<ul class="nav pull-right">   
				    <li>
				    	<a href="${resource(dir: '/')}" title="home">
				    	<i class="icon-home icon-white"></i>Home </a>
				    </li>
					<li><a href="http://nerd.eurecom.fr/documentation" target="_blank" title="documentation">
						<i class="icon-info-sign icon-white"/></i>Documentation</a>
					</li>
				</ul>
			</div>
		</div>
	</div>
	<div class="container" id="content">
		<g:layoutBody />
	</div>
</body>