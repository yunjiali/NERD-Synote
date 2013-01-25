package org.synote.integration.nerd

import grails.plugins.springsecurity.Secured
import org.synote.resource.compound.*
import org.synote.resource.Resource
import org.synote.resource.single.text.TagResource
import org.synote.resource.single.text.TextNoteResource
import org.synote.resource.single.text.WebVTTCue
import org.synote.annotation.ResourceAnnotation
import org.synote.api.APIStatusCode
import org.synote.linkeddata.LinkedDataService
import org.synote.permission.PermService
import org.synote.resource.compound.WebVTTService
import org.synote.resource.ResourceService
import org.synote.user.SecurityService
import grails.converters.*
import org.synote.linkeddata.LinkedDataService
import org.synote.config.ConfigurationService
import org.synote.player.client.WebVTTData
import org.synote.player.client.PlayerException
import org.synote.annotation.synpoint.Synpoint
import org.synote.linkeddata.Vocabularies as V


import groovyx.net.http.HTTPBuilder
import static groovyx.net.http.ContentType.*
import static groovyx.net.http.Method.*

import java.util.UUID
import java.net.URLDecoder

import fr.eurecom.nerd.client.*
import fr.eurecom.nerd.client.type.*
import fr.eurecom.nerd.client.schema.*

class NerdController {
	
	//def beforeInterceptor = [action: this.&checkNerdEnabled]
	
	def nerdService
	def permService
	def webVTTService
	def linkedDataService
	def resourceService
	def securityService
	def configurationService
	
	def index = {
		def synoteMultimediaServiceURL = configurationService.getConfigValue("org.synote.resource.service.server.url")
		return [mmServiceURL:synoteMultimediaServiceURL]
	}
	
	//preview subtitles with named entities
	def nerdpreview = {
		if(!params.videourl)
		{
			flash.error = "The url of the video is missing."
			redirect(action:'index')
			return
		}
		
		def videourl = URLDecoder.decode(params.videourl, "utf8")
		
		if(!params.subtitleurl)
		{
			flash.error = "The url of the subtitle is missing."
			redirect(action:'index')
			return
		}
		
		def subtitleurl = URLDecoder.decode(params.subtitleurl, "utf8")
		
		def prefixList = V.getVocabularies()
		StringBuilder builder = new StringBuilder()
		prefixList.each{p->
			builder.append("PREFIX "+p[0]+":"+"<"+p[1]+">")
			builder.append(" ")
		}
		
		def synoteMultimediaServiceURL = configurationService.getConfigValue("org.synote.resource.service.server.url")
		
		return [prefixString:builder.toString(), videourl:videourl,subtitleurl:subtitleurl,userBaseURI:linkedDataService.getUserBaseURI(),
			   resourceBaseURI:linkedDataService.getResourceBaseURI(),mmServiceURL:synoteMultimediaServiceURL]
	}
	
	def getSubtitleAjax = {
		if(!params.subtitleurl)
		{
			render(contentType:"text/json"){
				error(stat:APIStatusCode.PARAMS_MISSING, description:"subtitle url is missing.")
			}
			return
		}
		
		def subtitleurl = URLDecoder.decode(params.subtitleurl, "utf8")
		def http = new HTTPBuilder("https://api.dailymotion.com")
		def srtStr = null
		http.get(path:subtitleurl, contentType:TEXT){ resp,reader->
			
			String s = reader?.text
			if(s?.size() > 0)
			{
				srtStr = s
				try
				{
					def cuesList = webVTTService.convertToWebVTTObjectFromSRT(srtStr);
					render cuesList as JSON
					return
				}
				catch(PlayerException playerEx)
				{
					render(contentType:"text/json"){
						error(stat:APIStatusCode.TRANSCRIPT_SRT_INVALID, description:playerEX.getMessage())
					}
					return
				}
				catch(Exception ex)
				{
					render(contentType:"text/json"){
						error(stat:APIStatusCode.INTERNAL_ERROR, description:ex.getMessage())
					}
					return
				}
			}
			else
			{
				render "'"
				return
			}
		}
	}
	
	/*
	* Extract named entities from srt file using nerd
	*/
	def extractSRTAjax = {
		def text =""
		
		final String NERD_KEY = configurationService.getConfigValue("org.synote.integration.nerd.key")
		
		if(!params.resourceId)
		{
			render(contentType:"text/json"){
				error(stat:APIStatusCode.NERD_ID_MISSING, description:"Resource id is missing.")
			}
			return
		}
		
		def vtt = WebVTTResource.get(params.resourceId?.toLong())
		if(!vtt)
		{
			render(contentType:"text/json"){
				error(stat:APIStatusCode.NERD_RESOURCE_NOT_FOUND, description:"Cannot find the resource with id ${params.id}.")
			}
			return
		}
		
		def anno = ResourceAnnotation.findBySource(vtt)
		def multimedia = anno.target
		
		if(!anno)
		{
			render(contentType:"text/json"){
				error(stat:APIStatusCode.RESOURCEANNOTATION_NOT_FOUND, description:"Cannot find the annotation.")
				
			}
		}
		def transcript = webVTTService.getTranscriptFromAnnotation(anno, vtt)
		
		text = webVTTService.convertToSRT(transcript)
		
		if(!params.extractor)
		{
			render(contentType:"text/json"){
				error(stat:APIStatusCode.NERD_EXTRACTOR_NOT_FOUND, description:"Cannot find the extractor.")
			}
			return
		}
		
		def nerdExtractor = nerdService.getNerdExtractor(params.extractor)
		if(!nerdExtractor)
		{
			render(contentType:"text/json"){
				error(stat:APIStatusCode.NERD_EXTRACTOR_NOT_FOUND, description:"Cannot find the extractor with name ${params.extractor}.")
			}
			return
		}
		
		if(!text || text?.trim()?.size() ==0)
		{
			render(contentType:"text/json"){
				error(stat:APIStatusCode.NERD_TEXT_NOT_FOUND, description:"Extraction text cannot be empty.")
			}
			return
		}
		
		//TODO: add nerd language type
		if(!params.lang)
			params.lang = "en"
		
		try
		{
			
			NERD nerd = new NERD(NERD_KEY)
			def result= nerd.annotateJSON(nerdExtractor,
								   DocumentType.TIMEDTEXT,
								   text,
								   GranularityType.OEN,
								   30L);
			def jsObj = JSON.parse(result)
		   
			//save json to triple store
			//println "before"
			def entities = nerdService.getEntityFromJSON(result)
			//extractions.each{ex->
			//	println "startNPT:"+ex.getStartNPT()
			//	println "endNPT:"+ex.getEndNPT()
			//}
			//def synpoint = resourceService.getSynpointByResource(resource)
			//def multimedia = resourceService.getMultimediaByResource(resource)
		   
			def synpoints = Synpoint.findAllByAnnotation(anno)
			
			int countintriple = 0
			synpoints.each{syn->
				//TODO: if two synpoints have exactly the same start and end time
				def ents = entities.findAll{ ent->
					(((int)(ent.getStartNPT()*1000)) -syn.targetStart).abs() <=100 &&
					(((int)(ent.getEndNPT()*1000)) - syn.targetEnd).abs() <=100
				}
				//println "exts size:"+exts?.size()
				if(ents?.size() >0)
				{
					countintriple+=ents.size()
					def cue = WebVTTCue.findByCueIndexAndWebVTTFile(syn.sourceStart,vtt)
					linkedDataService.saveNERDToTripleStroe(ents,multimedia,cue,syn,params.extractor)
				}
			}
			   
			//println "££££££££££finalcounts:${countintriple}££££££££££"
			render JSON.parse(result) as JSON
			return
		}
		catch(Exception ex)
		{
			println ex.class
			println ex.getMessage()
			ex.printStackTrace()
			throw ex
			render(contentType:"text/json"){
				error(stat:APIStatusCode.NERD_EXTRACTOR_INTERAL_ERROR, description:"Connection failure to the extractor.")
			}
			return
		}
		
	}
	
	/*
	 * Nerd the subtitle as srt file without asking users to choose extractors
	 * displaying the result similar to nerditone
	 */
	def nerditsub = {
		def multimedia = MultimediaResource.get(params.id)
		if(!multimedia)
		{
			flash.error = "Cannot find the recording."
			redirect(action:'index', controller:'user')
			return
		}
		
		def perm = permService.getPerm(multimedia)
		if(perm?.val <=0)
		{
			flash.error = "Access denied! You don't have permission to access this transcript block."
			redirect(controller:'user',action: 'index')
			return
		}
		
		WebVTTData[] transcripts= webVTTService.getTranscripts(multimedia)
	   
	    if(!transcripts)
	    {
			flash.error = "No transcript is found for this recording."
			redirect(controller:'user',action: 'index')
			return
	    }
		def transcript = transcripts[0]
	   
	    def srtStr = webVTTService.convertToSRT(transcript)
	
		def results = [text:srtStr,extractors:["combined"]] as Map
	
		return [textResource:results,resourceId:transcript.id, multimedia:multimedia]
		
	}
}
