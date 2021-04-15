package org.xtext.example.mydsl.generator.mapping

import org.eclipse.xtext.generator.IFileSystemAccess2
import org.eclipse.emf.ecore.resource.Resource
import org.xtext.example.mydsl.bookingDSL.*;

class MappingProfileGenerator {
	static def void generateModels(IFileSystemAccess2 fsa,
		Resource resource)
	{
		var systemName = resource.allContents.toList.filter(System).get(0).getName();
		var declarations = resource.allContents.toList.filter(Declaration);
		
		fsa.generateFile('''«systemName»/«systemName»/Mapping/MappingProfile.cs''', 
		'''
		using AutoMapper;
		using «systemName».Persistence.Models;
		using «systemName».RequestModels;
		using System;
		using System.Collections.Generic;
		using System.Linq;
		using System.Threading.Tasks;
		using System;
		using «systemName».RequestModels;
		using «systemName».Persistence.Models;
		
		namespace «systemName».Mapping
		{
		    public class MappingProfile : Profile{
		    	public MappingProfile()
		    	{
		    	«FOR dec : declarations»
		    		CreateMap<Create«dec.name»RequestModel, «dec.name»>().ReverseMap();
		    		CreateMap<Update«dec.name»RequestModel, «dec.name»>().ReverseMap();
		    	«ENDFOR»
		    	}	
		    }
		}
		''')
	}
	
}