package org.xtext.example.mydsl.generator.persistence

import org.eclipse.xtext.generator.IFileSystemAccess2
import org.eclipse.emf.ecore.resource.Resource
import org.xtext.example.mydsl.bookingDSL.*;

class ModelsGenerator {
	static def void generateModels(IFileSystemAccess2 fsa,
		Resource resource)
	{
		var systemName = resource.allContents.toList.filter(System).get(0).getName();
		
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
			
		fsa.generateFile('''«systemName»/«systemName»/Persistence/Models/User.cs''', 
			'''
			using System;
			
			namespace «systemName».Persistence.Models
			{
			    public class User : IEntity
			    {
			        public Guid Id { get; set; }
			        public string Name { get; set; }
			    }
			}
			''')
	}
}