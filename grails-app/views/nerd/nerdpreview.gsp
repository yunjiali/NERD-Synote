<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="org.synote.player.client.TimeFormat" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional with HTML5 microdata//EN" "xhtml1-transitional-with-html5-microdata.dtd">
<html lang="en">
<head>
	<meta name="layout" content="nerd" />
	<title>Preview Named Entities</title>
	<meta name="author" content="Yunjia Li"/>
	<g:urlMappings/>
	<link rel="stylesheet" href="${resource(dir: 'css', file: 'player.css')}" />
	<link rel="stylesheet" href="${resource(dir: 'css', file: 'nerd.css')}" />
	<link rel="stylesheet" type="text/css" href="${resource(dir: 'bootstrap', file: 'css/bootstrap-responsive.min.css')}" />
	<link rel="stylesheet" type="text/css" href="${resource(dir: 'mediaelement', file: 'mediaelementplayer.min.css')}" />
	
	<script type="text/javascript" src="${resource(dir: 'js', file: 'player/player.responsive.js')}"></script>
	<script type="text/javascript" src="${resource(dir:'js',file:"Base.js")}"></script>
	<script type="text/javascript" src="${resource(dir: 'js/jquery', file: 'jquery.form.js')}"></script>
	<script type="text/javascript" src="http://ajax.aspnetcdn.com/ajax/jquery.validate/1.9/jquery.validate.min.js"></script>
	<!-- Other jquery libraries  -->
	<script type="text/javascript" src="${resource(dir:'js/jquery',file:"jquery.maskedinput-1.3.min.js")}"></script>
	<script type="text/javascript" src="${resource(dir:'js/jquery',file:"jquery.url.js")}"></script>
	<script type="text/javascript" src="${resource(dir:'js/jquery',file:"jquery.timers.js")}"></script>
	<script type="text/javascript" src="${resource(dir:'js/jquery',file:"jquery.field_selection.js")}"></script>
	<script type="text/javascript" src="${resource(dir:'js/jquery',file:"jquery.scrollTo-1.4.2-min.js")}"></script>
	<script type="text/javascript" src="${resource(dir:'js/jquery',file:"jquery.okShortcut.min.js")}"></script>
	<script type="text/javascript" src="${resource(dir:'js/player',file:"mediafragments.js")}"></script>
	<!-- Player settings -->
	<script type="text/javascript" src="${resource(dir:'js/jquery',file:"jquery.media.js")}"></script>
	<script type="text/javascript" src="${resource(dir:'js/jquery',file:"microdataHelper.js")}"></script>
	<script type="text/javascript" src="${resource(dir:'js/tiny_mce',file:"jquery.tinymce.js")}"></script>
	<script type="text/javascript" src="${resource(dir:'js/player',file:"webvtt.parser.js")}"></script>
	<script type="text/javascript" src="${resource(dir:'js',file:"util.js")}"></script>
	<!-- For player -->
	<script type="text/javascript" src="${resource(dir:'mediaelement',file:"mediaelement-and-player.min.js")}"></script>
	<script type="text/javascript" src="${resource(dir:'js/player',file:"player.timer.js")}"></script>
	<script type="text/javascript" src="${resource(dir:'js/player',file:"player.multimedia.js")}"></script>
	<script type="text/javascript" src="${resource(dir:'js/player',file:"player.mediafragment.controller.js")}"></script>
	<script type="text/javascript" src="${resource(dir:'js/player',file:"player.transcript.js")}"></script>
	<script type="text/javascript" src="${resource(dir:'js/player',file:"player.textselector.js")}"></script>
	<script type="text/javascript" src="${resource(dir:'js/player',file:"player.subpreview.js")}"></script>
	<script type="text/javascript" src="${resource(dir:'js/player',file:"player.nerd.js")}"></script>
	<script type="text/javascript" src="${resource(dir:'js',file:"synote-multimedia-service-client.js")}"></script>
	<script type="text/javascript" src="${resource(dir:'js',file:"multimedia-metadata-parser.js")}"></script>
	
	<script type="text/javascript">
	var recording = null;
	var appPath = "${grailsApplication.metadata['app.name']}";
	var mf_json = null; //pasrse the media fragment as json object
	var ctrler = null; //multimedia controller, including play media fragment
	var user = null;
	var mdHelper = null //helper to help embed microdata
	var userBaseURI = "${userBaseURI}";
	var resourceBaseURI = "${resourceBaseURI}";
	var nerdClient = null;
	var subtitleurl = "${subtitleurl}";
	
	$(document).ready(function(){
		//Deal with the media fragment first
		
		var uglyURI = decodeURIComponent(window.location);
		var prettyURI = uglyURI;
		if(uglyURI.indexOf("#!") != -1)
			prettyURI = uglyURI.replace("#!","#");
		var currentURL = $.url(prettyURI);
		var recordingURLStr = "${videourl}";
		if(currentURL.attr('fragment')) //if current url has fragment
		{
			if(recordingURLStr.indexOf('#') == -1)
				recordingURLStr+='#';
				
			recordingURLStr +=currentURL.attr('fragment');
			//console.log(recordingURLStr);
		}
		mf_json = MediaFragments.parseMediaFragmentsUri(recordingURLStr);
		//console.log(mf_json);
		
		recording = new Object();
		recording.id = 100001; //random id
		recording.title = "some title";
		recording.url = "${videourl}";
		recording.canEdit = false;
		recording.canCreateSynmark = false;
		recording.isVideo = true;
		recording.uuid = "7382cda8-33db-4ce6-a64f-003fe48dda12";
		recording.thumbnail = null;
		recording.hasCC = true;

		user = new Object();
		user.id = -1;
		user.user_name = "Guest User";
		
		mdHelper= new MicrodataHelper(true);

		var sparqlEndpoint = g.createLink({controller:'linkedData',action:'sparql'}).replace("?id=__ID__","");
		nerdClient = new NerdClient(sparqlEndpoint,'${prefixString}');
		
		initSynotePlayer(recording);
		//initShortCutKeys();
		
		//Start playing from media fragment is exisiting
		if(!$.isEmptyObject(mf_json.hash) || !$.isEmptyObject(mf_json.query))
		{
			//ctrler.start_playback();
		}

		var client = new SynoteMultimediaServiceClient("${mmServiceURL}");
		var parser =  new MultimediaMetadataParser();
		
		client.getMetadata(recording.url, function(data, errMsg){
			if(data != null)
			{
				parser.getTitle(data,function(title,errorMsg){
					if(title != null)
					{
						$("#recording_title_h2").text(title);
					}
				});
			}
		});
		
	});
	</script>
</head>
<body>
<!-- Recording title -->
<div id="multimedia_title_div">
	<div>
		<h2 id="recording_title_h2"></h2>
	</div>
</div>
<!-- Player and Description-->
<div class="container">
<div class="row">
	<div id="col_left_div" class="player-fixed-width">
		<div id="mf_info_div" class="mf-info-video" style="display:none;">
			<div class="pull-left">
				<button class="btn btn-success" id="control_mf" title="Play this fragment"><i class="icon-play-circle icon-white"></i>Play from</button>
			</div>
		</div>
		<div id="multimedia_player_error_div">
			<!-- attach error messages as another span class="error" here -->
		</div>
		<div id="recording_content_div" itemscope="itemscope" itemtype="http://schema.org/AuidoObject" itemref="recording_title_div recording_owner_div created_time_span"> <!-- player -->
			<div id="multimedia_player_div">
					<video id="multimedia_player" width="480" height="320" preload="none">
						<source src=""/>
					</video>
			</div>
		</div><!-- end player -->
		<br/>
		<!-- Transcript -->
		<div id="transcripts_div">
			<h3 class="heading-inline">Subtitle</h3>
		</div>
		<div id="transcript_msg_div"></div><!-- displaying info, error messages -->
		<div id="transcript_loading_div" style="display:none;"><img id="transcript_loading_img" src="${resource(dir:'images/skin',file:'loading_64.gif')}" alt="loading"/></div>
		<div id="transcripts_inner_div">
			<div id="transcripts_content_div">
				<ol id="transcript_ol"></ol>
			</div>
		</div>
	</div>

	<div id="col_right_div" class="span-fluid-right tabbable">
		<div class="container-fluid">
			<div class="row-fluid">
				<div id="nerd_div" class="tab-pane span-left">
					<h3>NERD</h3>
					<div id="nerd_div_msg" style="display:none;"></div>
					<div id="nerd_category_list_div" class="well">
						<div id="nerd_thing_div" class="nerd-line">
							<div id="nerd_thing_count_div"></div>
							<div id="nerd_thing_list_div" class="nerd-entity-line">
								<table id="nerd_thing_table"></table>
							</div>
						</div>
						<div id="nerd_person_div" class="nerd-line">
							<div id="nerd_person_count_div"></div>
							<div id="nerd_person_list_div" class="nerd-entity-line">
								<table id="nerd_person_table"></table>
							</div>
						</div>
						<div id="nerd_organization_div" class="nerd-line">
							<div id="nerd_organization_count_div"></div>
							<div id="nerd_organization_list_div" class="nerd-entity-line">
								<table id="nerd_organization_table"></table>
							</div>
						</div>
						<div id="nerd_location_div" class="nerd-line">
							<div id="nerd_location_count_div"></div>
							<div id="nerd_location_list_div" class="nerd-entity-line">
								<table id="nerd_location_table"></table>
							</div>
						</div>
						<div id="nerd_product_div" class="nerd-line">
							<div id="nerd_product_count_div"></div>
							<div id="nerd_product_list_div" class="nerd-entity-line">
								<table id="nerd_product_table"></table>
							</div>
						</div>
						<div id="nerd_event_div" class="nerd-line">
							<div id="nerd_event_count_div"></div>
							<div id="nerd_event_list_div" class="nerd-entity-line">
								<table id="nerd_event_table"></table>
							</div>
						</div>
						<div id="nerd_function_div" class="nerd-line">
							<div id="nerd_function_count_div"></div>
							<div id="nerd_function_list_div" class="nerd-entity-line">
								<table id="nerd_function_table"></table>
							</div>
						</div>
						<div id="nerd_time_div" class="nerd-line">
							<div id="nerd_time_count_div"></div>
							<div id="nerd_time_list_div" class="nerd-entity-line">
								<table id="nerd_time_table"></table>
							</div>
						</div>
						<div id="nerd_amount_div" class="nerd-line">
							<div id="nerd_amount_count_div"></div>
							<div id="nerd_amount_list_div" class="nerd-entity-line">
								<table id="nerd_amount_table"></table>
							</div>
						</div>
					</div>	
				</div>
			</div><!-- end transcript -->
		</div>
	</div>
</div>
</div>
</body>
</html>
