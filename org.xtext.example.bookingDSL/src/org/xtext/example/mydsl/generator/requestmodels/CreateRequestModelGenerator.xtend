package org.xtext.example.mydsl.generator.requestmodels

import org.eclipse.xtext.generator.IFileSystemAccess2
import org.eclipse.emf.ecore.resource.Resource
import org.xtext.example.mydsl.bookingDSL.*;

class CreateRequestModelGenerator {
	static def void generateRequestModelsFile(IFileSystemAccess2 fsa,
		Resource resource)
	{
		var systemName = resource.allContents.toList.filter(System).get(0).getName();
		var definedCustomerTypes = resource.allContents.toList.filter(Customer);
		var definedResourceTypes = resource.allContents.toList.filter(org.xtext.example.mydsl.bookingDSL.Resource);
		var definedEntityTypes = resource.allContents.toList.filter(Entity);
		var definedScheduleTypes = resource.allContents.toList.filter(Schedule);
		var definedBookingTypes = resource.allContents.toList.filter(Booking);
		
		for (Customer c : definedCustomerTypes){
			genFile(fsa, resource, systemName, c.name)
		}
		for (org.xtext.example.mydsl.bookingDSL.Resource c : definedResourceTypes){
			genFile(fsa, resource, systemName, c.name)
		}
		for (Entity c : definedEntityTypes){
			genFile(fsa, resource, systemName, c.name)
		}
		for (Schedule c : definedScheduleTypes){
			genFile(fsa, resource, systemName, c.name)
		}
		for (Booking c : definedBookingTypes){
			genFile(fsa, resource, systemName, c.name)
		}
	}
	
	private static def void genFile(IFileSystemAccess2 fsa,
		Resource resource, String systemName, String name){
	fsa.generateFile('''«systemName»/«systemName»/RequestModels/CreateUserRequestModels.cs''', 
	'''
	namespace «systemName».RequestModels
	{
	    public class Create«name»RequestModel
	    {
	        public string Name { get; set; }
	    }
	}
	''')
	}
		
}