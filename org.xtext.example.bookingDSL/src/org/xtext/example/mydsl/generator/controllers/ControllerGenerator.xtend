package org.xtext.example.mydsl.generator.controllers

import org.eclipse.xtext.generator.IFileSystemAccess2
import org.eclipse.emf.ecore.resource.Resource
import org.xtext.example.mydsl.bookingDSL.*;

class ControllerGenerator {
	static def void generateControllers(IFileSystemAccess2 fsa,
		Resource resource)
	{
		var systemName = resource.allContents.toList.filter(System).get(0).getName();
		var declarations = resource.allContents.toList.filter(Declaration);
		
		for(Declaration dec : declarations){
			genControllerFile(fsa, resource, systemName, dec.name, dec)
			/*for(Member mem : dec.members){
				if(mem instanceof Constraint){
					print(mem.logic)
					for(t : mem.logic.eContents){
						print(t)
					}
					print("\n left left: " + mem.logic.disjunction.left.left.comparison.operator + "\n")
					print("\n left left: " + mem.logic.disjunction.left.left.comparison + "\n")
					print("left right: " + mem.logic.disjunction.left.right.comparison)
					
					
				}
			}*/
		}
	}
	
	static def void test(Logic log){
		var dis = log.disjunction
		var leftCon = dis.left
		var prim = leftCon.left
		if(prim.comparison !== null){
			var expres = prim.comparison.left
		}
		if(prim.logic !== null){
			
		}
	}
	
	//Have to pass name besides resource since not all resources have names (but all controllers will have)
	private static def void genControllerFile(IFileSystemAccess2 fsa,
		Resource resource, String systemName, String resourceName, Declaration dec){
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
				        
				        «IF(dec instanceof org.xtext.example.mydsl.bookingDSL.Resource)»
				        «scheduleRelationInterface(dec)»
				        «ENDIF»
				    }
				}
				'''
			)
		}
		
	static def CharSequence scheduleRelationInterface(org.xtext.example.mydsl.bookingDSL.Resource res){
			var result = ''''''
			var alreadyAddedScheduleTypes = newArrayList
			
			for(subres : res.eContents){
				if(subres instanceof Relation){
					if(subres.plurality.equals("many")){
						if(!alreadyAddedScheduleTypes.contains(subres.relationType.name)){
							result = '''
[HttpPut]
[Route("Add«subres.relationType.name»sToAll")]
public async Task<ActionResult<List<«res.name»>>> Add«subres.relationType.name»sToAll([FromBody] List<«subres.relationType.name»> list)
{
	var result = await _«res.name»Handler.Add«subres.relationType.name»ToAllResources(list);
	
	if(result == null) return BadRequest();
	
	return Ok(result);
}
							'''
							alreadyAddedScheduleTypes.add(subres.relationType.name);
						}
					}
				}
			}
			
			return result
		}
}