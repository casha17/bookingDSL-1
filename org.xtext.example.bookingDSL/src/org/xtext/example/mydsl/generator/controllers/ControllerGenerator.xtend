package org.xtext.example.mydsl.generator.controllers

import org.eclipse.xtext.generator.IFileSystemAccess2
import org.eclipse.emf.ecore.resource.Resource
import org.xtext.example.mydsl.bookingDSL.*;

class ControllerGenerator {
	static def void generateControllers(IFileSystemAccess2 fsa,
		Resource resource)
	{
		var systemName = resource.allContents.toList.filter(System).get(0).getName();
		var definedCustomerTypes = resource.allContents.toList.filter(Customer);
		var definedResourceTypes = resource.allContents.toList.filter(org.xtext.example.mydsl.bookingDSL.Resource);
		var definedEntityTypes = resource.allContents.toList.filter(Entity);
		var definedScheduleTypes = resource.allContents.toList.filter(Schedule);
		var definedBookingTypes = resource.allContents.toList.filter(Booking);
		
		for (Customer c : definedCustomerTypes){
			genControllerFile(fsa, resource, systemName, c.name)
		}
		for (org.xtext.example.mydsl.bookingDSL.Resource c : definedResourceTypes){
			genControllerFile(fsa, resource, systemName, c.name)
		}
		for (Entity c : definedEntityTypes){
			genControllerFile(fsa, resource, systemName, c.name)
		}
		for (Schedule c : definedScheduleTypes){
			genControllerFile(fsa, resource, systemName, c.name)
		}
		for (Booking c : definedBookingTypes){
			genControllerFile(fsa, resource, systemName, c.name)
		}
	}
	
	//Have to pass name besides resource since not all resources have names (but all controllers will have)
	private static def void genControllerFile(IFileSystemAccess2 fsa,
		Resource resource, String systemName, String resourceName){
			fsa.generateFile('''«systemName»/«systemName»/Controllers/«resourceName»Controller.cs''',
				'''
				using System;
				using System.Threading.Tasks;
				using «systemName».Handlers;
				using «systemName».RequestModels;
				using Microsoft.AspNetCore.Mvc;
				
				namespace «systemName».Controllers
				{
				    [Route("«resourceName»")]
				    public class «resourceName»Controller : ControllerBase
				    {
				        private readonly I«resourceName»Handler _«resourceName»Handler;
				
				        public «resourceName»Controller(I«resourceName»Handler «resourceName»Handler)
				        {
				            _«resourceName»Handler = «resourceName»Handler;
				        }
				
				        [HttpGet]
				        [Route("")]
				        public async Task<IActionResult> Get(int page, int pageSize)
				        {
				            return new ObjectResult(new []{"Casper", "Ulrik", "Morten", "Oskar"});
				        }
				
				        [HttpGet]
				        [Route("{id}")]
				        public async Task<IActionResult> Get(Guid id)
				        {
				            return new ObjectResult(new {name = "Casper"});
				        }
				
				        [HttpPost]
				        [Route("")]
				        public async Task<IActionResult> Create([FromBody]Create«resourceName»RequestModel rm)
				        {
				            var guid = new Guid();
				            return new ObjectResult(new {id = guid.ToString(), name = rm.Name});
				        }
				    }
				}
				'''
			)
		}
}