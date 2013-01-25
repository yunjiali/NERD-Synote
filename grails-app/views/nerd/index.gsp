<html>
<head>
	<title>NERD Annotation Viewer</title>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<meta name="layout" content="nerd" />
	<g:urlMappings />
	<link rel="stylesheet" type="text/css" href="${resource(dir: 'mediaelement', file: 'mediaelementplayer.min.css')}" />
	<script type="text/javascript" src="${resource(dir:'mediaelement',file:'mediaelement-and-player.min.js')}"></script>
	<script type="text/javascript" src="${resource(dir:'js/jquery',file:"jquery.maskedinput-1.3.min.js")}"></script>
	<script type="text/javascript" src="${resource(dir: 'js/jquery', file: 'jquery.form.js')}"></script>
	<script type="text/javascript" src="http://ajax.aspnetcdn.com/ajax/jquery.validate/1.9/jquery.validate.min.js"></script>
	<script type="text/javascript" src="${resource(dir:'js',file:"util.js")}"></script>
	<script type="text/javascript" src="${resource(dir:'js',file:"synote-multimedia-service-client.js")}"></script>
	<script type="text/javascript" src="${resource(dir:'js',file:"multimedia-metadata-parser.js")}"></script>
	<script type="text/javascript">
	var mmServiceURL = "${mmServiceURL}";
	var client = new SynoteMultimediaServiceClient(mmServiceURL);
	var parser = new MultimediaMetadataParser();
	var player = null;
	var videoHtml = '<video id="multimedia_player" width="480" height="320" preload="none"><source src=""/></video>'
	
	function initPreview(videourl)
	{
		var player_div = $("#multimedia_player_div");
		player_div.empty();

		player_div.html(videoHtml);

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
		else
		{
			showMsg("The video URL is not valid","error");
			return;
		}

		var opts = {
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
			
			$("#url_submit_btn").button('loading');
			$("#preview_content").hide();
			$("#NERDifySubmit_div").hide();
			$("#preview_loading_div").show();
			client.getMetadata(url, function(data, errMsg){
				if(data != null)
				{
					$("#preview_loading_div").hide();
					//Don't need thumbnail

					parser.getDuration(data,function(duration,errorMsg){
						if(duration != null)
						{
							$("#duration").text(milisecToString(duration));
						}
						else
						{
							$("#duration_span").closest(".control-group").addClass("warning");
							//var oldHtml = $("#duration_span").closest(".controls").html();
							//$("#duration_span").closest(".controls").html(oldHtml+"<p class='help-block'>Please enter the duration of the recording.</p>");
						}
					});

					parser.getKeywords(data,function(keywords,errorMsg){
						//console.log(keywords);
						if(keywords != null && keywords.length > 0)
						{
							var tagHtml = "";
							for(i=0;i<keywords.length;i++)
							{
								tagHtml+="<span class='badge badge-tag' style='float:left;margin:3px;'><i class='icon-tag tag-item icon-white'></i>"+keywords[i]+"</span>";
							}
							$("#tags").html(tagHtml);
						}
						else
						{
							$("#tags").text("No tags");
						}
					});

					parser.getTitle(data,function(title,errorMsg){
						if(title != null)
						{
							$("#title").text(title);
						}
					});

					parser.getDescription(data,function(note,errorMsg){
						if(note != null)
						{
							$("#note").html(note);
						}
					});

					parser.getChannel(data,function(channel,errorMsg){
						if(errorMsg != null)
						{
							$("#channel").text(errorMsg);
						}
						else
						{
							$("#channel").text(channel);
						}
					});

					parser.getCategory(data,function(category,errorMsg){
						if(errorMsg != null)
						{
							$("#category").text(errorMsg);
						}
						else
						{
							$("#category").text(category);
						}
					});

					parser.getLanguage(data,function(language,errorMsg){
						if(language !== undefined)
						{
							$("#language").text(language);
						}
					});

					parser.getCreationDate(data,function(creationDate,errorMsg){
						if(creationDate !== undefined)
						{
							$("#creationDate").text(creationDate);
						}
					});

					parser.getPublicationDate(data,function(publicationDate,errorMsg){
						if(publicationDate !== undefined)
						{
							$("#publicationDate").text(publicationDate);
						}
					});
					
					parser.getViews(data,function(views,errorMsg){
						if(views !== undefined)
						{
							$("#views").text(views+" Views");
						}
					});
					
					parser.getComments(data,function(comments,errorMsg){
						if(comments !== undefined)
						{
							$("#comments").text(comments+" Comments");
						}
					});

					parser.getFavorites(data,function(favorites,errorMsg){
						if(favorites !== undefined)
						{
							$("#favorites").text(favorites+" Favorites");
						}
					});

					parser.getRatings(data,function(ratings,errorMsg){
						if(ratings !== undefined)
						{
							$("#ratings").text(ratings+" Ratings");
						}
					});

					
					initPreview(url);
					$("#preview_content").show();

					//get subtitlelist
					client.getSubtitleList(url, function(data, errMsg){
						if(data!=null)
						{
							if(data.total == 0)
							{
								$("#subtitles").text("No subtitle available");
							}
							else
							{
								var subtitlesHtml = "<ul>";
								var ensubtitleurl = data.list[0].url;
								for(var i=0;i<data.list.length;i++)
								{
									subtitlesHtml += "<li><a href='"+data.list[i].url+"' target='_blank' title='"+data.list[i].language+" subtitle'>"+data.list[i].language+"</a></li>";
									if(language == "en")
									{
										ensubtitleurl = data.list[i].url;
									}
								}
								
								subtitlesHtml += "</ul>"
								$("#subtitles").html(subtitlesHtml);
								//update the link and show the nerdify button
								var subpreviewurl  = g.createLink({controller: 'nerd', action: 'nerdpreview', 
									params: {videourl: encodeURIComponent(url), subtitleurl:encodeURIComponent(ensubtitleurl)}});
								$("#NERDify_a").prop("href",subpreviewurl);
								$("#NERDifySubmit_div").show();
							}
						}
						else
						{
							showMsg(errMsg,"error");
							$("#form_loading_div").hide();
						}
					});
				}
				else
				{
					showMsg(errMsg,"error");
				}
				$("#form_loading_div").hide();
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
		<g:render template="/common/message" />
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
		<h2 id="title"></h2>
		<div class="row">
			<div class="span7">
				<div id="multimedia_player_div">
				<!-- always use video -->
					
				</div>
		      	<br/>
		      	<div class="control-group">
					<label for="tags" class="control-label"><b>Tags</b></label>
			      	<div id="tags"></div>
		      	</div>
		      	<br/>
				<div class="control-group pull-left">
					<label for="note" class="control-label"><b>Description</b></label>
			      	<div class="controls" id="note"></div>
		      	</div>
			</div>
			<div class="span5">
				<div class="control-group">
					<label for="duration" class="control-label"><b>Duration</b></label>
			      	<div class="controls" id="duration"></div>
		      	</div>	
		      	<div class="control-group">
		      		<label for="statistics" class="control-label"><b>Statistics</b></label>
		      		<div class="controls" id="statistics">
		      			<span><i class="icon-fire metrics-item"></i><span id="views"></span></span><br/>
						<span><i class="icon-comment metrics-item"></i><span id="comments"></span></span><br/>
						<span><i class="icon-star metrics-item"></i><span id="favorites"></span></span><br/>
						<span><i class="icon-signal metrics-item"></i><span id="ratings"></span></span><br/>
		      		</div>
				</div>
				<div class="control-group">
					<label for="channel" class="control-label"><b>Channel</b></label>
			      	<div class="controls" id="channel"></div>
		      	</div>
		      	<div class="control-group">
					<label for="category" class="control-label"><b>Category</b></label>
			      	<div class="controls" id="category"></div>
		      	</div>
		      	<div class="control-group">
					<label for="language" class="control-label"><b>Language</b></label>
			      	<div class="controls" id="language"></div>
		      	</div>
		      	<div class="control-group">
					<label for="creationDate" class="control-label"><b>Creation Date</b></label>
			      	<div class="controls" id="creationDate"></div>
		      	</div>
		      	<div class="control-group">
					<label for="publicationDate" class="control-label"><b>Publication Date</b></label>
			      	<div class="controls" id="publicationDate"></div>
		      	</div>
		      	<div class="control-group">
					<label for="subtitles" class="control-label"><b>Subtitles Available</b></label>
			      	<div class="controls" id="subtitles"></div>
		      	</div>
			</div>
		</div>
		<div class="row" style="display:none;" id="NERDifySubmit_div">
			<div class="form-actions" id="controls_div">
				<div class="pull-right">
	            	<a class="btn btn-warning" target="_blank" id="NERDify_a" href="" type="submit" data-loading-text="NERDifying">NERDify</a>
	            </div>
	        </div>
		</div>
	</div>
</body>
</html>