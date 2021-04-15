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
			using System;
			using System.Collections.Generic;
			using System.Linq;
			using System.Threading.Tasks;
			using «systemName».Persistence.Repositories;
			using «systemName».Persistence.Models;
			using «systemName».RequestModels;
			using Microsoft.AspNetCore.Mvc.Infrastructure;
			
			namespace «systemName».Handlers
			{
			    public interface I«name»Handler
			    {
			        Task<Guid> Create«name»(«name» model);
			        Task<bool> Delete«name»(Guid id);
			        Task<IEnumerable<«name»>> GetAll(int page, int pageSize);
			        Task<«name»> Update(«name» model);
			        Task<«name»> Get(Guid id);
			    }
			    
			    public class «name»Handler : I«name»Handler
			    {
			        private readonly I«name»Repository _«name»Repository;
			
			        public «name»Handler(I«name»Repository «name»Repository)
			        {
			            _«name»Repository = «name»Repository;
			        }
			
					public Task<Guid> Create«name»(«name» model)
					{
						return _«name»Repository.Insert(model);
					}
					
					public Task<bool> Delete«name»(Guid id)
					{
						return _«name»Repository.Delete(id);	
					}
					
					public Task<IEnumerable<«name»>> GetAll(int page, int pageSize)
					{
						return _«name»Repository.GetPaged(page, pageSize);	
					}
					
					public Task<«name»> Update(«name» model)
					{
						return _«name»Repository.Put(model);
					}
					
					public Task<«name»> Get(Guid id)
					{
						return _«name»Repository.GetById(id);	
					}
			        
			    }
			}
			''')
		}
}