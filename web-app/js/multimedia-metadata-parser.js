/*
 * A javascript synote-multimedia-service response parser to get what we want
 */
function MultimediaMetadataParser()
{
	//Do nothing
}

/*
 * params:
 * data: json data response from synote-multimedia-service API
 * callback (thumbnail_url,errorMsg)
 */
MultimediaMetadataParser.prototype.getThumbnail = function(data,callback)
{
	if(data == null)
	{
		return callback(null, "Response data is empty.");
	}
	
	if(data.metadata.thumbnail === undefined)
		return callback(null,"Cannot get the default thumbnail picture from synote-multimedia-service.");
		
	return callback(data.metadata.thumbnail,null);
}

/*
 * params:
 * data: json data response from synote-multimedia-service API
 * callback (duration in milli-seconds,errorMsg)
 */
MultimediaMetadataParser.prototype.getDuration = function(data,callback)
{
	if(data == null)
	{
		return callback(null, "Response data is empty.");
	}
	
	if(data.metadata.duration === undefined)
		return callback(null,"Cannot get the duration of the resource.");
	var duration = parseInt(data.metadata.duration);
	return callback(duration*1000,null);
}

/*
 * params:
 * data: json data response from synote-multimedia-service API
 * callback (title,errorMsg)
 */
MultimediaMetadataParser.prototype.getTitle = function(data,callback)
{
	if(data == null)
	{
		return callback(null, "Response data is empty.");
	}
	
	if(data.metadata.title === undefined)
		return callback(null,"Cannot get the title of the resource.");
	var title = data.metadata.title;
	return callback(title,null);
}

/*
 * params:
 * data: json data response from synote-multimedia-service API
 * callback (description,errorMsg)
 */
MultimediaMetadataParser.prototype.getDescription = function(data,callback)
{
	if(data == null)
	{
		return callback(null, "Response data is empty.");
	}
	
	if(data.metadata.description === undefined)
		return callback(null,"Cannot get the description of the resource");
	var description = data.metadata.description;
	return callback(description,null);
}

/*
 * Get keywords, separated by comma
 * params:
 * data: json data response from synote-multimedia-service API
 * callback (keywords,errorMsg)
 */
MultimediaMetadataParser.prototype.getKeywords = function(data,callback)
{
	if(data == null)
	{
		return callback(null, "Response data is empty.");
	}
	
	if(data.metadata.tags === undefined)
		return callback(null,"Cannot get the tags of the resource");
	var keywords = data.metadata.tags;
	return callback(keywords,null);
}

/*
 * Get channel of the video (not applicable for DailyMotion)
 * params:
 * data: json data response from synote-multimedia-service API
 * callback (channel,errorMsg)
 */
MultimediaMetadataParser.prototype.getChannel = function(data,callback)
{
	if(data == null)
	{
		return callback(null, "Response data is empty.");
	}
	
	if(data.metadata.channel === undefined)
		return callback(null,"No channel");
	var channel = data.metadata.channel;
	return callback(channel,null);
}


/*
 * Get category of the video (not applicable for DailyMotion)
 * params:
 * data: json data response from synote-multimedia-service API
 * callback (category,errorMsg)
 */
MultimediaMetadataParser.prototype.getCategory = function(data,callback)
{
	if(data == null)
	{
		return callback(null, "Response data is empty.");
	}
	
	if(data.metadata.category === undefined || data.metadata.category == null)
		return callback(null,"No category");
	var category = data.metadata.category;
	return callback(category,null);
}

/*
 * Get language of the video (not applicable for youtube videos)
 * params:
 * data: json data response from synote-multimedia-service API
 * callback (lang,errorMsg)
 */
MultimediaMetadataParser.prototype.getLanguage = function(data,callback)
{
	if(data == null)
	{
		return callback(null, "Response data is empty.");
	}
	
	if(data.metadata.language === undefined)
		return callback(null,"Unknown language");
	var lang = data.metadata.language;
	return callback(lang,null);
}

/*
 * Get creation date of the video
 * params:
 * data: json data response from synote-multimedia-service API
 * callback (cDate,errorMsg)
 */
MultimediaMetadataParser.prototype.getCreationDate = function(data,callback)
{
	if(data == null)
	{
		return callback(null, "Response data is empty.");
	}
	
	if(data.metadata.creationDate === undefined)
		return callback(null,"Unknown creation date");
	var cDate = data.metadata.creationDate;
	return callback(cDate,null);
}

/*
 * Get publication date of the video
 * params:
 * data: json data response from synote-multimedia-service API
 * callback (pDate,errorMsg)
 */
MultimediaMetadataParser.prototype.getPublicationDate = function(data,callback)
{
	if(data == null)
	{
		return callback(null, "Response data is empty.");
	}
	
	if(data.metadata.publicationDate === undefined)
		return callback(null,"Cannot get the tags of the resource");
	var pDate = data.metadata.publicationDate;
	return callback(pDate,null);
}

/*
 * Get view times of the video
 * params:
 * data: json data response from synote-multimedia-service API
 * callback (views,errorMsg)
 */
MultimediaMetadataParser.prototype.getViews = function(data,callback)
{
	if(data == null)
	{
		return callback(null, "Response data is empty.");
	}
	
	if(data.statistics.views === undefined)
		return callback(null,"Unknown");
	var views = data.statistics.views;
	return callback(views,null);
}

/*
 * Get comment times of the video
 * params:
 * data: json data response from synote-multimedia-service API
 * callback (keywords,errorMsg)
 */
MultimediaMetadataParser.prototype.getComments = function(data,callback)
{
	if(data == null)
	{
		return callback(null, "Response data is empty.");
	}
	
	if(data.statistics.comments === undefined)
		return callback(null,"Unknown");
	var comments = data.statistics.comments;
	return callback(comments,null);
}
/*
 * Get favorites
 * params:
 * data: json data response from synote-multimedia-service API
 * callback (favorites,errorMsg)
 */
MultimediaMetadataParser.prototype.getFavorites = function(data,callback)
{
	if(data == null)
	{
		return callback(null, "Response data is empty.");
	}
	
	if(data.statistics.favorites === undefined)
		return callback(null,"Unknown");
	var favorites = data.statistics.favorites;
	return callback(favorites,null);
}
/*
 * Get ratings of the video
 * params:
 * data: json data response from synote-multimedia-service API
 * callback (ratings,errorMsg)
 */
MultimediaMetadataParser.prototype.getRatings = function(data,callback)
{
	if(data == null)
	{
		return callback(null, "Response data is empty.");
	}
	
	if(data.statistics.ratings === undefined)
		return callback(null,"Unknown");
	var ratings = data.statistics.ratings;
	return callback(ratings,null);
}

/*
 * Get video url. YouTube and DailyMotion sometimes have short URL which cannot be recognised by MediaElement player,
   So we use this function to return a url that can be played by the player
 * params:
 * data: json data response from synote-multimedia-service API
 * callback (url,errorMsg)
 */
/*MultimediaMetadataParser.prototype.getVideoURL = function(data,callback)
{
	if(data == null)
	{
		return callback(null, "Response data is empty.");
	}
	
	if(data.url === undefined)
		return callback(null,"Cannot get the url of the resource");
	return callback(data.url,null);
}*/

