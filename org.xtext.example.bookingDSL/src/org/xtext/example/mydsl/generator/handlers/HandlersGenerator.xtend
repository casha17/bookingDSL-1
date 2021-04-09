package org.xtext.example.mydsl.generator.handlers

import org.eclipse.xtext.generator.IFileSystemAccess2
import org.eclipse.emf.ecore.resource.Resource
import org.xtext.example.mydsl.bookingDSL.*;

class HandlersGenerator {
	static def void generateHandlers(IFileSystemAccess2 fsa,
		Resource resource)
	{
		var systemName = resource.allContents.toList.filter(System).get(0).getName();
		var definedCustomerTypes = resource.allContents.toList.filter(Customer);
		var definedResourceTypes = resource.allContents.toList.filter(org.xtext.example.mydsl.bookingDSL.Resource);
		var definedEntityTypes = resource.allContents.toList.filter(Entity);
		var definedScheduleTypes = resource.allContents.toList.filter(Schedule);
		var definedBookingTypes = resource.allContents.toList.filter(Booking);
		
		for (Customer c : definedCustomerTypes){
			genHandlerFile(fsa, resource, systemName, c.name)
		}
		for (org.xtext.example.mydsl.bookingDSL.Resource c : definedResourceTypes){
			genHandlerFile(fsa, resource, systemName, c.name)
		}
		for (Entity c : definedEntityTypes){
			genHandlerFile(fsa, resource, systemName, c.name)
		}
		for (Schedule c : definedScheduleTypes){
			genHandlerFile(fsa, resource, systemName, c.name)
		}
		for (Booking c : definedBookingTypes){
			genHandlerFile(fsa, resource, systemName, c.name)
		}
	}
	
	private static def void genHandlerFile(IFileSystemAccess2 fsa,
		Resource resource, String systemName, String name){
			fsa.generateFile('''«systemName»/«systemName»/Handlers/«name»Handler.cs''', 
			'''
			using System.Threading.Tasks;
			using «systemName».Persistence.Repositories;
			
			namespace «systemName».Handlers
			{
			    public interface I«name»Handler
			    {
			        Task<bool> Create();
			    }
			    
			    public class «name»Handler : I«name»Handler
			    {
			        private readonly I«name»Repository _«name»Repository;
			
			        public UserHandler(I«name»Repository «name»Repository)
			        {
			            _«name»Repository = «name»Repository;
			        }
			
			        public async Task<bool> Create()
			        {
			            // Do a lot of different logic here?
			            
			            // Insert into _userRepository
			            
			            // return a result in the end
			            return true;
			        }
			    }
			}
			''')
		}
}