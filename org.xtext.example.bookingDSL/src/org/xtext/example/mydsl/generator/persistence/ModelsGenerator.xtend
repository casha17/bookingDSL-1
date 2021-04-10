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
			genFile(fsa, dec, systemName, dec.name)
		}
		
		fsa.generateFile('''«systemName»/«systemName»/Persistence/Models/IEntity.cs''', 
			'''
			using System;
			
			namespace «systemName».Persistence.Models
			{
			    public interface IEntity
			    {
			        Guid Id { get; }
			    }
			}
			''')
	}
	
	static def void genFile(IFileSystemAccess2 fsa, Declaration dec, String systemName, String name){
		fsa.generateFile('''«systemName»/«systemName»/Persistence/Models/«name».cs''', 
			'''
			using System;
			
			namespace «systemName».Persistence.Models
			{
			    public class «name» : IEntity
			    {
			        public Guid Id { get; set; }
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