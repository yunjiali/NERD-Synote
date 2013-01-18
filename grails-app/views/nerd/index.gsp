<html>
<head>
	<title>NERD Annotation Viewer</title>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<meta name="layout" content="nerd" />
	<link rel="stylesheet" type="text/css" href="${resource(dir: 'mediaelement', file: 'mediaelementplayer.min.css')}" />
	<script type="text/javascript" src="${resource(dir:'mediaelement',file:'mediaelement-and-player.min.js')}"></script>
	<script type="text/javascript" src="${resource(dir:'js/jquery',file:"jquery.maskedinput-1.3.min.js")}"></script>
	<script type="text/javascript" src="${resource(dir: 'js/jquery', file: 'jquery.form.js')}"></script>
	<script type="text/javascript" src="http://ajax.aspnetcdn.com/ajax/jquery.validate/1.9/jquery.validate.min.js"></script>
	<script type="text/javascript" src="${resource(dir:'js',file:"util.js")}"></script>
	<script type="text/javascript" src="${resource(dir:'js',file:"synote-multimedia-service-client.js")}"></script>
	<script type="text/javascript" src="${resource(dir:'js',file:"dailymotion-parser.js")}"></script>
	<script type="text/javascript" src="${resource(dir:'js',file:"youtube-parser.js")}"></script>
	<script type="text/javascript">
	var mmServiceURL = "${mmServiceURL}";
	var client = new SynoteMultimediaServiceClient(mmServiceURL);
	var dmParser = new DailyMotionParser();
	var ytParser = new YouTubeParser(); //use it later

	function initPreview(videourl)
	{
		console.log("videourl:"+videourl);
		var player_tag = $("#multimedia_player");
		player_tag.children("source").attr("src",videourl);
		//find out the media type by checking the file format
		
		if(isYouTubeURL(videourl))
		{
			$("#multimedia_player").children("source").attr("type","video/x-youtube");
		}
		else if(isDailyMotionURL(videourl))
		{
			$("#multimedia_player").children("source").attr("type","video/dailymotion");
		}

		opts = {
			videoWidth: 480,
			videoHeight: 320
		};
		player_tag.mediaelementplayer(opts);
	}
	
	function showMsg(msg,type)
	{
		var msg_div = $("#error_msg_div");
		if(type == "error")
		{
			msg_div.html("<div class='alert alert-error'><button class='close' data-dismiss='alert'>x</button>"+msg+"</div>");
		}
		else if(type=="warning")
		{
			msg_div.html("<div class='alert'><button class='close' data-dismiss='alert'>x</button>"+msg+"</div>");
		}
		else
		{
			msg_div.html("<div class='alert alert-success'><button class='close' data-dismiss='alert'>x</button>"+msg+"</div>");
		}
	}


	$(document).ready(function(){
		
		$("#url_submit_btn").click(function(){
			var url = $("#url").val();
			var parser = null;
			if(isDailyMotionURL(url,true))
			{
				parser = dmParser;
			}
			else if(isYouTubeURL(url,true))
			{
				parser = ytParser
			}
			else
			{
				showMsg("The video URL is not valid","error");
				return;
			}
			
			$("#url_submit_btn").button('loading');
			$("#preview_content").hide();
			$("#preview_loading_div").show();
			client.getMetadata(url, function(data, errMsg){
				if(data != null)
				{
					$("#preview_loading_div").hide();
					//Don't need thumbnail

					parser.getDuration(data,function(duration,errorMsg){
						if(duration != null)
						{
							$("#duration_span").val(milisecToString(duration));
							$("#duration").val(duration);
						}
						else
						{
							$("#duration_span").closest(".control-group").addClass("warning");
							//var oldHtml = $("#duration_span").closest(".controls").html();
							//$("#duration_span").closest(".controls").html(oldHtml+"<p class='help-block'>Please enter the duration of the recording.</p>");
						}
					});

					parser.getKeywords(data,function(keywords,errorMsg){
						if(keywords != null)
						{
							$("#tags").val(keywords);
						}
					});

					parser.getTitle(data,function(title,errorMsg){
						if(title != null)
						{
							$("#title").val(title);
						}
					});

					parser.getDescription(data,function(note,errorMsg){
						if(note != null)
						{
							$("#note").val(note);
						}
					});

					initPreview(url);
					$("#preview_content").show();
				}
				else
				{
					showMsg(errMsg,"error");
					$("#form_loading_div").hide();
				}
				$("#url_submit_btn").button('reset');
			});
		});
	});
	</script>
</head>
<body>
	<br/>
	<div class="row">
		<div class="span5">
			<h1>Video Preview</h1>
		</div>
		<div class="span6">
			<img class="pull-right" src="${resource(dir: 'images/nerd', file: 'nerd-header.png')}" width="300px" height="93px" alt="nerd header" title="nerd header"/>
		</div>
	</div>
	<hr/>
	<div id="multimediaCreateForm_div">
		<div id="error_msg_div"></div>
		<g:form name='multimediaCreateForm'>
			<fieldset>
				<input type="hidden" name="rlocation" value="youtube" />
				<div class="control-group span9">
					<label for="url" class="control-label"><b><em>*</em>URL</b></label>
				    <div class="controls">
				    	<div class="input-append">
				       		<input type='text' autocomplete="off" class="required span6" name='url' id='url' />
				       		<button id="url_submit_btn" type="button" class="btn" data-loading-text="loading...">Preview</button>
				        	<p class="help-block">Please enter the URL of the YouTube or DailyMotion Video e.g. http://www.dailymotion.com/video/28764736</p>
				        </div>
				    </div>
			    </div>
			</fieldset>
		</g:form>
	</div>
	<hr/>
	<div id="preview_loading_div" style="display:none;">
		<img id="preview_loading_img" src="${resource(dir:'images/skin',file:'loading_64.gif')}" alt="loading"/>
	</div>
	<!-- Preview player -->
	<div class="container" id="preview_content" style="display:none;">
		<div class="row">
			<div class="span7">
				<div id="multimedia_player_div">
				<!-- always use video -->
					<video id="multimedia_player" width="480" height="320" preload="none">
						<source src=""/>
					</video>
				</div>
			</div>
			<div class="span5">
				<div class="control-group">
					<label for="title" class="control-label"><b><em>*</em>Title</b></label>
			      	<div class="controls">
			        	<input type='text' autocomplete="off" class="required span4 resetFields" name='title' id='title'/>
			      	</div>
		      	</div>
		      	<div class="control-group">
					<label for="note" class="control-label"><b>Description</b></label>
			      	<div class="controls">
			        	<textarea class="input-xlarge span4 resetFields" name='note' id='note' rows="8" id="note"></textarea>
			      	</div>
		      	</div>
		      	<div class="control-group">
					<label for="tags" class="control-label"><b>Tags</b></label>
			      	<div class="controls">
			        	<input class="span4 resetFields" name='tags' id='tags' />
			        	<span class="help-block">Please separate the tags by comma ","</span>
			      	</div>
		      	</div>
			</div>
		</div>
	</div>
</body>
</html>