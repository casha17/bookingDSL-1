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
				using System.Collections.Generic;
				using AutoMapper;
				using «systemName».Persistence.Models;
				
				namespace «systemName».Controllers
				{
				    [Route("«resourceName»")]
				    public class «resourceName»Controller : ControllerBase
				    {
				        private readonly I«resourceName»Handler _«resourceName»Handler;
				        private readonly IMapper _mapper;
				
				        public «resourceName»Controller(I«resourceName»Handler «resourceName»Handler, IMapper mapper)
				        {
				            _«resourceName»Handler = «resourceName»Handler;
				            _mapper = mapper;
				        }
				
				        [HttpGet]
				        [Route("")]
				        public async Task<ActionResult<IEnumerable<«resourceName»>>> Get(int page = 0, int pageSize = 100)
				        {
				            var result = await _«resourceName»Handler.GetAll(page, pageSize);
				            
				            if (result == null)
				            	return NotFound();
				            
				            return Ok(result);
				        }
				
				        [HttpGet]
				        [Route("{id}")]
				        public async Task<ActionResult<«resourceName»>> Get(Guid id)
				        {
				            var result = await _«resourceName»Handler.Get(id);
				            
				            if (result == null)
				            	return NotFound();
				            				            
				           	return Ok(result);
				        }
				
				        [HttpPost]
				        [Route("")]
				        public async Task<ActionResult<Guid>> Create([FromBody]Create«resourceName»RequestModel rm)
				        {
				            var model = _mapper.Map<«resourceName»>(rm);
				            var result = await _«resourceName»Handler.Create«resourceName»(model);
				            
				            if (result == null)
				            	return NotFound();
				            				            
				            return Ok(result);
				        }
				        
				        [HttpPut]
				        [Route("")]
				        public async Task<ActionResult<«resourceName»>> Put([FromBody] Update«resourceName»RequestModel rm)
				        {
				        	var model = _mapper.Map<«resourceName»>(rm);
				        	var result = await _«resourceName»Handler.Update(model);
				        	
				        	if (result == null)
				        		return NotFound();
				        					            
				        	return Ok(result);
				        }
				        
				        [HttpDelete]
				        [Route("")]
				        public async Task<ActionResult<bool>> Delete(Guid id)
				        {
				        	var result = await _«resourceName»Handler.Delete«resourceName»(id);
				        	
				        	if (!result)
				        	     return NotFound();
				        	
				        	return Ok(result);
				        }
				    }
				}
				'''
			)
		}
}