/*
 * A javascript YouTube response parser to get what we want
 */
function YouTubeParser()
{
	//Do nothing
}

/*
 * params:
 * data: json data response from YouTube API
 * callback (thumbnail_url,errorMsg)
 */
YouTubeParser.prototype.getThumbnail = function(data,callback)
{
	if(data == null)
	{
		return callback(null, "Response data is empty.");
	}
	
	if(data.entry[ "media$group" ][ "media$thumbnail" ][ 0 ].url === undefined)
		return callback(null,"Cannot get the default thumbnail picture from YouTube.");
		
	return callback(data.entry[ "media$group" ][ "media$thumbnail" ][ 0 ].url,null);
}

/*
 * params:
 * data: json data response from YouTube API
 * callback (duration in milli-seconds,errorMsg)
 */
YouTubeParser.prototype.getDuration = function(data,callback)
{
	if(data == null)
	{
		return callback(null, "Response data is empty.");
	}
	
	if(data.entry[ "media$group" ][ "yt$duration" ].seconds === undefined)
		return callback(null,"Cannot get the duration of the resource.");
	var duration = parseInt(data.entry[ "media$group" ][ "yt$duration" ].seconds);
	return callback(duration*1000,null);
}

/*
 * params:
 * data: json data response from YouTube API
 * callback (title,errorMsg)
 */
YouTubeParser.prototype.getTitle = function(data,callback)
{
	if(data == null)
	{
		return callback(null, "Response data is empty.");
	}
	
	if(data.entry[ "title" ].$t === undefined)
		return callback(null,"Cannot get the title of the resource.");
	var title = data.entry["title"].$t;
	return callback(title,null);
}

/*
 * params:
 * data: json data response from YouTube API
 * callback (description,errorMsg)
 */
YouTubeParser.prototype.getDescription = function(data,callback)
{
	if(data == null)
	{
		return callback(null, "Response data is empty.");
	}
	
	if(data.entry[ "media$group" ]["media$description"].$t === undefined)
		return callback(null,"Cannot get the description of the resource");
	var description = data.entry[ "media$group" ]["media$description"].$t;
	return callback(description,null);
}

/*
 * Get keywords, separated by comma
 * params:
 * data: json data response from YouTube API
 * callback (keywords,errorMsg)
 */
YouTubeParser.prototype.getKeywords = function(data,callback)
{
	if(data == null)
	{
		return callback(null, "Response data is empty.");
	}
	
	if(data.entry[ "media$group" ]["media$keywords"].$t === undefined)
		return callback(null,"Cannot get the keywords of the resource");
	var keywords = data.entry[ "media$group" ]["media$keywords"].$t;
	return callback(keywords,null);
}

/*
 * Get video url. YouTube and DailyMotion sometimes have short URL which cannot be recognised by MediaElement player,
   So we use this function to return a url that can be played by the player
 * params:
 * data: json data response from DailyMotion API
 * callback (url,errorMsg)
 */
DailyMotionParser.prototype.getVideoURL = function(data,callback)
{
	if(data == null)
	{
		return callback(null, "Response data is empty.");
	}
	
	if(data.entry[ "media$group" ]["media$player"].url === undefined)
		return callback(null,"Cannot get the url of the resource");
	return callback(data.entry[ "media$group" ]["media$player"].url,null);
}