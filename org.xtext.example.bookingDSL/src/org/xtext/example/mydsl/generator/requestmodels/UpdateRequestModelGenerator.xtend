package org.xtext.example.mydsl.generator.requestmodels

import org.eclipse.xtext.generator.IFileSystemAccess2
import org.eclipse.emf.ecore.resource.Resource
import org.xtext.example.mydsl.bookingDSL.*;
import java.util.ArrayList

class UpdateRequestModelGenerator {
	static def void generateRequestModelsFile(IFileSystemAccess2 fsa,
		Resource resource)
	{
		var systemName = resource.allContents.toList.filter(System).get(0).getName();
		for(dec : resource.allContents.toList.filter(Declaration)){
			if(dec instanceof Customer){
				genFile(fsa, dec, systemName, dec.name)
			}else if(dec instanceof org.xtext.example.mydsl.bookingDSL.Resource){
				genFile(fsa, dec, systemName, dec.name)
			}else{
				genFile(fsa, dec, systemName, dec.name)
			}
		}
	}
	
	private static def void genFile(IFileSystemAccess2 fsa,
		Customer cust, String systemName, String name){
		fsa.generateFile('''«systemName»/«systemName»/RequestModels/Update«name»RequestModels.cs''', 
		'''
		using «systemName».Persistence.Models;
		using System.Collections.Generic;
		using System;
				
		namespace «systemName».RequestModels
		{
			«IF(cust.superType !== null)»
			public class Update«name»RequestModel : Update«cust.superType.name»RequestModel
			{
		    «ENDIF»
		    «IF (cust.superType === null) »
		    public class Update«name»RequestModel
		    {
		    public Guid Id {get; set;}
		    «ENDIF»
				«FOR mem : cust.eContents»
				«IF(mem instanceof Attribute)»
				«attribute(mem)»
				«ENDIF»
				«IF(mem instanceof Relation)»
				«relation(mem)»
				«ENDIF»
				«ENDFOR»
		    }
		}
		''')	
	}
	
	private static def void genFile(IFileSystemAccess2 fsa,
		Declaration dec, String systemName, String name){
		fsa.generateFile('''«systemName»/«systemName»/RequestModels/Update«name»RequestModels.cs''', 
		'''
		using «systemName».Persistence.Models;
		using System.Collections.Generic;
		using System;
				
		namespace «systemName».RequestModels
		{
		    public class Update«name»RequestModel
		    {
		    	public Guid Id {get; set;}
		        «FOR mem : dec.eContents»
		        «IF(mem instanceof Attribute)»
				«attribute(mem)»
		        «ENDIF»
		        «IF(mem instanceof Relation)»
				«relation(mem)»
		        «ENDIF»
		        «ENDFOR»
		    }
		}
		''')	
	}
	
	private static def void genFile(IFileSystemAccess2 fsa,
		org.xtext.example.mydsl.bookingDSL.Resource resource, String systemName, String name){
		fsa.generateFile('''«systemName»/«systemName»/RequestModels/Update«name»RequestModels.cs''', 
		'''
		using «systemName».Persistence.Models;
		using System.Collections.Generic;
		using System;
		
		namespace «systemName».RequestModels
		{
			«IF(resource.superType === null)»
			public class Update«name»RequestModel
			{
			public Guid Id {get; set;}
		    «ENDIF»
		    «IF(resource.superType !== null)»
		    public class Update«name»RequestModel : Update«resource.superType.name»RequestModel
		    {
		    «ENDIF»
		        «FOR mem : resource.eContents»
		        «IF(mem instanceof Attribute)»
				«attribute(mem)»
		        «ENDIF»
		        «IF(mem instanceof Relation)»
				«relation(mem)»
		        «ENDIF»
		        «ENDFOR»
		    }
		}
		''')
	}
	
	static def CharSequence attribute(Attribute att){
		'''
		«IF (!att.array)»
		public «att.type» «att.name» {get; set;}
		«ENDIF»
		«IF (att.array)»
		public List<«att.type»> «att.name» {get; set;}
		«ENDIF»
		'''
	}
	
	static def CharSequence relation(Relation re){
		'''
		«IF (re.plurality.equals("one"))»
		public «re.relationType.name» «re.name» {get; set;} 
		«ENDIF»
		«IF (re.plurality.equals("many"))»
		public List<«re.relationType.name»> «re.name» {get; set;} 
		«ENDIF»
		'''
	}
}