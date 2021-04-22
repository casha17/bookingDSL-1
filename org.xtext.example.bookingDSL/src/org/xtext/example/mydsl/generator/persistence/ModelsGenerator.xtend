package org.xtext.example.mydsl.generator.persistence

import org.eclipse.xtext.generator.IFileSystemAccess2
import org.eclipse.emf.ecore.resource.Resource
import org.xtext.example.mydsl.bookingDSL.*;

class ModelsGenerator {
	static def void generateModels(IFileSystemAccess2 fsa,
		Resource resource)
	{
		var systemName = resource.allContents.toList.filter(System).get(0).getName();
		var declarations = resource.allContents.toList.filter(Declaration);
		for(dec : declarations){
			if(dec instanceof Customer){
				genFile(fsa, dec, systemName)
			}else if(dec instanceof org.xtext.example.mydsl.bookingDSL.Resource){
				genFile(fsa, dec, systemName)
			}else{
				genFile(fsa, dec, systemName, dec.name)
			}
		}
		
		fsa.generateFile('''«systemName»/«systemName»/Persistence/Models/IEntity.cs''', 
			'''
			using System;
			using System.Collections.Generic;
			
			namespace «systemName».Persistence.Models
			{
			    public interface IEntity
			    {
			        Guid Id { get; }
			    }
			}
			''')
	}
	
	static def void genFile(IFileSystemAccess2 fsa, Customer cust, String systemName){
		var name = cust.name
		fsa.generateFile('''«systemName»/«systemName»/Persistence/Models/«name».cs''', 
			'''
			using System;
			using System.Collections.Generic;
			
			namespace «systemName».Persistence.Models
			{
				«IF(cust.superType === null)»
				public class «name» : IEntity
				{
					public Guid Id {get; set;}
			    «ELSE»
				public class «name» : «cust.superType.name», IEntity
				{
			    «ENDIF»
			        «FOR mem : cust.eContents»
			        «IF (mem instanceof Attribute )»
			        «attribute(mem)»
			        «ENDIF»
			        «IF (mem instanceof Relation )»
			        «relation(mem)»
			        «ENDIF»
			        «ENDFOR»
			    }
			}
			''')
	}
	
	static def void genFile(IFileSystemAccess2 fsa, org.xtext.example.mydsl.bookingDSL.Resource res, String systemName){
		var name = res.name
		fsa.generateFile('''«systemName»/«systemName»/Persistence/Models/«name».cs''', 
			'''
			using System;
			using System.Collections.Generic;
			
			namespace «systemName».Persistence.Models
			{
				«IF(res.superType === null)»
				public class «name» : IEntity
				{
					public Guid Id {get; set;}
			    «ELSE»
				public class «name» : «res.superType.name», IEntity
				{
			    «ENDIF»
			        «FOR mem : res.eContents»
			        «IF (mem instanceof Attribute )»
			        «attribute(mem)»
			        «ENDIF»
			        «IF (mem instanceof Relation )»
			        «relation(mem)»
			        «ENDIF»
			        «ENDFOR»
			    }
			}
			''')
	}
	
	static def void genFile(IFileSystemAccess2 fsa, Declaration dec, String systemName, String name){
		fsa.generateFile('''«systemName»/«systemName»/Persistence/Models/«name».cs''', 
			'''
			using System;
			using System.Collections.Generic;
			
			namespace «systemName».Persistence.Models
			{
			    public class «name» : IEntity
			    {
			    	public Guid Id {get; set;}
			        «FOR mem : dec.eContents»
			        «IF (mem instanceof Attribute )»
			        «attribute(mem)»
			        «ENDIF»
			        «IF (mem instanceof Relation )»
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