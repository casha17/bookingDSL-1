package org.xtext.example.mydsl.generator.controllers

import org.eclipse.xtext.generator.IFileSystemAccess2
import org.eclipse.emf.ecore.resource.Resource
import org.xtext.example.mydsl.bookingDSL.*;
import java.util.Map
import java.util.HashMap
import java.util.ArrayList

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
					if(mem.logic !== null){
						var parameters = newArrayList
						writeConstraint(mem.logic, parameters)
					}
				}
			}*/
		}
	}
	
	static def void writeConstraint(Logic log, ArrayList result){
		if(log.disjunction !== null){
			var disjunctionRoot = log.disjunction
			if(disjunctionRoot.left !== null){
				var leftConjunction = disjunctionRoot.left
				if(leftConjunction.left !== null){
					var prim = leftConjunction.left
					if(prim.comparison !== null){
						var comparison = prim.comparison
						comparison.computeVoid(result)
					}
					if(prim.logic !== null){
						var leafLogic = prim.logic
						leafLogic.writeConstraint(result)
					}
				}
				if(leftConjunction.right !== null){
					result.add("and")
					var prim = leftConjunction.right
					if(prim.comparison !== null){
						var comparison = prim.comparison
						comparison.computeVoid(result)
					}
					if(prim.logic !== null){
						var leafLogic = prim.logic
						leafLogic.writeConstraint(result)
					}
				}
			}
			if(disjunctionRoot.right !== null){
				result.add("or")
				var rightConjunction = disjunctionRoot.right
				if(rightConjunction.left !== null){
					var prim = rightConjunction.left
					if(prim.comparison !== null){
						var comparison = prim.comparison
						comparison.computeVoid(result)
					}
					if(prim.logic !== null){
						var leafLogic = prim.logic
						leafLogic.writeConstraint(result)
					}
				}
				if(rightConjunction.right !== null){
					var prim = rightConjunction.right
					print(" and ")
					result.add("and")
					if(prim.comparison !== null){
						var comparison = prim.comparison
						comparison.computeVoid(result)
					}
					if(prim.logic !== null){
						var leafLogic = prim.logic
						leafLogic.writeConstraint(result)
					}
				}
			}
		}
	}
	
	def static void computeVoid(Comparison comp, ArrayList result){
		if(comp.left !== null){
			comp.left.computeExpVoid(result)
		}
		if(comp.operator !== null){
			result.add(comp.operator)
		}
		if(comp.right !== null){
			comp.right.computeExpVoid(result)
		}
	}
	
	def static void computeExpVoid(Expression exp, ArrayList result){
		switch exp{
			Plus: {
				exp.left.computeExpVoid(result)
				result.add("+")
				exp.right.computeExpVoid(result)
			}
			Minus:{ 
				exp.left.computeExpVoid(result)
				result.add("-")
				exp.right.computeExpVoid(result) 
			}
			Mult:{ 
				exp.left.computeExpVoid(result)
				result.add("*")
				exp.right.computeExpVoid(result)
				}
			Div: {
				exp.left.computeExpVoid(result)
				result.add("/")
				exp.right.computeExpVoid(result)
			}
			Number:{
				result.add(exp.value)
			}
			Var:{ 
				result.add(exp.name.name)
			}
			default: throw new Exception("Error")
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