package org.synote.linkeddata

/*
 * Defines all the vocabularies, including classes and properties,which will be used
 */
class Vocabularies {
	/*
	 * Define namespaces in form of XX_NS:
	 * [prefixString,URI]
	 * 
	 * URI should ends with # or /
	 */
	static final String[] RDF_NS = ["rdf",'''http://www.w3.org/1999/02/22-rdf-syntax-ns#''']
	static final String[] RDFS_NS = ["rdfs",'''http://www.w3.org/2000/01/rdf-schema#''']
	static final String[] DC_NS = ["dc",'''http://purl.org/dc/elements/1.1/''']
	static final String[] DCTERMS_NS = ["dcterms",'''http://purl.org/dc/terms/''']
	static final String[] SCHEMAORG_NS = ["schemaorg",'''http://schema.org/'''] //schema.org
	static final String[] FOAF_NS=["foaf",'''http://xmlns.com/foaf/0.1/''']
	static final String[] MAONT_NS=["ma",'''http://www.w3.org/ns/ma-ont#'''] //ontology for media resource
	static final String[] OAC_NS=["oac",'''http://www.openannotation.org/ns/'''] //DEPRECATED:open annotation collaboration
	static final String[] OA_NS=["oa",'''http://www.w3.org/ns/openannotation/core/'''] //open annotation
	static final String[] ORE_NS=["ore",'''http://www.openarchives.org/ore/terms/'''] //object reuse and exchange, part of open archieves initiative
	static final String[] NSA_NS=["nsa",'''http://multimedialab.elis.ugent.be/organon/ontologies/ninsuna#'''] //Ninsuna vocabulary
	static final String[] REVIEW_NS=["review",'''http://purl.org/stuff/rev#'''] //review ontology
	static final String[] OWL_NS=["owl",'''http://www.w3.org/2002/07/owl#'''] //owl ontology, useful for owl:sameAs
	static final String[] NERD_NS=["nerd",'''http://nerd.eurecom.fr/ontology#'''] //NERD ontology
	static final String[] STR_NS=["str",'''http://nlp2rdf.lod2.eu/schema/string/'''] //lod2 String ontology, see http://nlp2rdf.org/nif-1-0
	static final String[] OPMV_NS=["opmv",'''http://purl.org/net/opmv/ns#'''] //Open Provenance Model Vocabulary
	static final String[] TIME_NS=["time",'''http://www.w3.org/2006/time#'''] //Time ontology
	static final String[] LINKEDTV_NS=["linkedtv",'''http://data.linkedtv.eu/ontology/'''] //linked tv ontology
	static final String[] DBPEDIAOWL_NS=["dbpedia-owl",'''http://dbpedia.org/ontology/'''] //dbpedia ontology
	
	//Not used currently
	static final String[] TIMELINE_NS=["timeline",'''http://purl.org/NET/c4dm/timeline.owl/'''] //Timeline ontology
	static final String[] XSD_NS=["xsd",'''http://www.w3.org/2001/XMLSchema#''']
	/*
	 * Define properties in form of XX_PropertyName:
	 * [nsPrefix+propertyName,propertyURI]
	 * 
	 */
	//static final String[] RDFS_LABEL = [RDF_NS[0]+":label",'''http://www.w3.org/2000/01/rdf-schema#label''']
	//static final String[] RDFS_SEEALSO = [RDF_NS[0]+":seeAlso",'''http://www.w3.org/2000/01/rdf-schema#seeAlso''']
	public static getVocabularies()
	{
		def vocabularies = []
		vocabularies << RDF_NS
		vocabularies << RDFS_NS
		vocabularies << DC_NS
		vocabularies << DCTERMS_NS
		//vocabularies << SCHEMAORG_NS
		vocabularies << FOAF_NS
		vocabularies << MAONT_NS
		vocabularies << OA_NS
		vocabularies << ORE_NS
		vocabularies << NSA_NS
		vocabularies << OWL_NS
		vocabularies << NERD_NS
		vocabularies << STR_NS
		vocabularies << OPMV_NS
		vocabularies << TIMELINE_NS
		vocabularies << LINKEDTV_NS
		vocabularies << DBPEDIAOWL_NS
		vocabularies << XSD_NS
		
		
		return vocabularies
	}
	
	public static getPrefixListString()
	{
		def prefixList = getVocabularies()
		StringBuilder builder = new StringBuilder()
		prefixList.each{p->
			builder.append("PREFIX "+p[0]+":"+"<"+p[1]+">")
			builder.append("\n")
		}
		
		return builder.toString()
	}
}
