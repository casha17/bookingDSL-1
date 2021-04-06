package org.xtext.example.mydsl.generator.requestmodels

import org.eclipse.xtext.generator.IFileSystemAccess2
import org.eclipse.emf.ecore.resource.Resource
import org.xtext.example.mydsl.bookingDSL.*;

class UserRequestModelGenerator {
	static def void generateRequestModelsFile(IFileSystemAccess2 fsa,
		Resource resource)
	{
		var systemName = resource.allContents.toList.filter(System).get(0).getName();
		
		fsa.generateFile('''«systemName»/«systemName»/RequestModels/CreateUserRequestModels.cs''', 
			'''
			namespace «systemName».RequestModels
			{
			    public class CreateUserRequestModel
			    {
			        public string Name { get; set; }
			    }
			}
			''')
	}
}