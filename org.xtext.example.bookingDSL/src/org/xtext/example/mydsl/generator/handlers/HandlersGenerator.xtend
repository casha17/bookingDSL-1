package org.xtext.example.mydsl.generator.handlers

import org.eclipse.xtext.generator.IFileSystemAccess2
import org.eclipse.emf.ecore.resource.Resource
import org.xtext.example.mydsl.bookingDSL.*;

class HandlersGenerator {
	static var alreadyDeclared = newArrayList
	
	static def void generateHandlers(IFileSystemAccess2 fsa,
		Resource resource)
	{
		var systemName = resource.allContents.toList.filter(System).get(0).getName();
		var declarations = resource.allContents.toList.filter(Declaration);
		 //reload when creating new project since static
		
		for (Declaration c : declarations){
			alreadyDeclared = newArrayList
			genHandlerFile(fsa, resource, systemName, c.name, c)
		}
	}
	
	private static def void genHandlerFile(IFileSystemAccess2 fsa,
		Resource resource, String systemName, String name, Declaration dec){
			
			fsa.generateFile('''«systemName»/«systemName»/Handlers/«name»Handler.cs''', 
			'''
			using System;
			using System.Collections.Generic;
			using System.Linq;
			using System.Threading.Tasks;
			using AutoMapper;
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
			        Task<List<«name»>> GetAll(int page, int pageSize);
			        Task<«name»> Update(«name» model);
			        Task<«name»> Get(Guid id);
			        «IF(dec instanceof org.xtext.example.mydsl.bookingDSL.Resource)»
			        «scheduleRelationInterface(dec)»
			        «ENDIF»
			    }
			    
			    public class «name»Handler : I«name»Handler
			    {
			        private readonly I«name»Repository _«name»Repository;
			       «FOR subdec : dec.eContents»
			       «IF(subdec instanceof Relation)»
			       «relationDeclaration(subdec)»
			       «ENDIF»
			       «ENDFOR»
			
			        public «name»Handler(I«name»Repository «name»Repository
			                             «FOR subdec : dec.eContents»
			                             			       «IF(subdec instanceof Relation)»
			                             			       «relationConstructor(subdec)»
			                             			       «ENDIF»
			                             			       «ENDFOR»
			                             )
			        {
			            _«name»Repository = «name»Repository;
			            «FOR subdec : dec.eContents»
			            			       «IF(subdec instanceof Relation)»
			            			       «relationInitialization(subdec)»
			            			       «ENDIF»
			            			       «ENDFOR»
			        }
			        
			        private IMapper CreateMapperConf<T>()
	        		{
	        			var config = new MapperConfiguration(cfg =>
	        			{
	        				cfg.CreateMap<T, T>();
	        			});
	        			return config.CreateMapper();
	        		}
			
					public async Task<Guid> Create«name»(«name» model)
					{
						«FOR subdec : dec.eContents»
						«IF(subdec instanceof Relation)»
						«relationCreate(name, subdec)»
						«ENDIF»
						«ENDFOR»
						return await _«name»Repository.Insert(model);
					}
					
					public async Task<bool> Delete«name»(Guid id)
					{
						return await _«name»Repository.Delete(id);	
					}
					
					public async Task<List<«name»>> GetAll(int page, int pageSize)
					{
						var all = await _«name»Repository.GetPaged(page, pageSize);	
						var map = CreateMapperConf<«name»>();
						var protectiveCopy = all.Select(e => map.Map<«name», «name»>(e)).ToList();
						var finalResult = new List<«name»>();
						
						«FOR subdec : dec.eContents»
						«IF(subdec instanceof Relation)»
						«relationGetMany(name, subdec)»
						«ENDIF»
						«ENDFOR»
						
						if(finalResult.Count == 0) finalResult = protectiveCopy.ToList();
						return finalResult;
					}
					
					public async Task<«name»> Update(«name» model)
					{
						«FOR subdec : dec.eContents»
						«IF(subdec instanceof Relation)»
						«relationUpdate(name, subdec)»
						«ENDIF»
						«ENDFOR»
						return await _«name»Repository.Put(model);
					}
					
					public async Task<«name»> Get(Guid id)
					{
						var result = await _«name»Repository.GetById(id);
						var map = CreateMapperConf<«name»>();
						var finalResult = map.Map<«name», «name»>(result);
						«FOR subdec : dec.eContents»
						«IF(subdec instanceof Relation)»
						«relationGet(name, subdec)»
						«ENDIF»
						«ENDFOR»
						return finalResult;	
					}
			        
			        «IF(dec instanceof org.xtext.example.mydsl.bookingDSL.Resource)»
			        «scheduleRelationBody(dec)»
			        «ENDIF»
			    }
			}
			''')
		}
		
		static def CharSequence relationDeclaration(Relation re){
		var charSequence = ''''''
	        if(alreadyDeclared.contains(re.relationType.name+'''DEC''')){
	        	return charSequence 
	        }else{
	        	charSequence = '''I«re.relationType.name»Handler _«re.relationType.name»Handler;'''
	        }
	        alreadyDeclared.add(re.relationType.name+'''DEC''');
	        return charSequence;  
		}
		
		static def CharSequence relationConstructor(Relation re){
			var charSequence = ''''''
	        if(alreadyDeclared.contains(re.relationType.name+'''CONSTRUCTOR''')){
	        	return charSequence 
	        }else{
	        	charSequence = ''', I«re.relationType.name»Handler «re.relationType.name»Handler'''
	        }
	        alreadyDeclared.add(re.relationType.name+'''CONSTRUCTOR''');
	        return charSequence;  
		}
		
		static def CharSequence relationInitialization(Relation re){
		var charSequence = ''''''
	        if(alreadyDeclared.contains(re.relationType.name+'''INIT''')){
	        	return charSequence 
	        }else{
	        	charSequence = '''_«re.relationType.name»Handler = «re.relationType.name»Handler;'''
	        }
	        alreadyDeclared.add(re.relationType.name+'''INIT''');
	        return charSequence;  
		}
		
		static def CharSequence relationCreate(String name, Relation re){
			var result = '''''';
			
			if(re.plurality.equals("one")){
				result = '''
if(model.«re.name».Id.Equals(Guid.NewGuid())){
      model.«re.name».Id = new Guid();
      await _«re.relationType.name»Handler.Create«re.relationType.name»(model.«re.name»);
   }
				'''
			}else if(re.plurality.equals("many")){
				result = '''foreach(var sub in model.«re.name»)
{
	if (sub.Id.Equals(Guid.NewGuid())){
		sub.Id = new Guid();
		await _«re.relationType.name»Handler.Create«re.relationType.name»(sub);
	}
}
				'''
			}
		}
		
		static def CharSequence relationUpdate(String name, Relation re){
			var result = '''''';
			
			if(re.plurality.equals("one")){
				result = '''if(model.«re.name» != null) await _«re.relationType.name»Handler.Update(model.«re.name»);'''
			}else if(re.plurality.equals("many")){
				result = '''foreach(var single in model.«re.name») if(single != null) await _«re.relationType.name»Handler.Update(single);'''
			}
			
			return result;
		}
		
		static def CharSequence relationGet(String name, Relation re){
			var result = '''''';
			
			if(re.plurality.equals("one")){
				result = '''if(finalResult.«re.name» != null) finalResult.«re.name» = await _«re.relationType.name»Handler.Get(finalResult.«re.name».Id);'''
			}else if(re.plurality.equals("many")){
				result = '''if(result.«re.name» != null)
{
	var list = new List<«re.relationType.name»>();
	foreach(var item in result.«re.name»)
	{
		var res = await _«re.relationType.name»Handler.Get(item.Id);
		if (res != null) list.Add(res);
	}
	finalResult.«re.name» = list;
}'''
			}
			
			return result;
		}
		
		static def CharSequence relationGetMany(String name, Relation re){
			var result = '''''';
			
			if(re.plurality.equals("one")){
				result = '''foreach (var item in protectiveCopy) item.«re.name» = await _«re.relationType.name»Handler.Get(item.«re.name».Id);'''
			}else if(re.plurality.equals("many")){
				result = '''foreach(var item in protectiveCopy) item.«re.name» = new List<«re.relationType.name»>();
foreach(var item in all)
{
	var protectedSingle = protectiveCopy.ToList().Find(x => x.Id.Equals(item.Id));
	foreach(var single in item.«re.name»)
	{
		var res = await _«re.relationType.name»Handler.Get(single.Id);
		if (res != null) protectedSingle.«re.name».Add(res);
	}
	finalResult.Add(protectedSingle);
}
				'''
			}
			
			return result;
		}
		
		static def CharSequence scheduleRelationInterface(org.xtext.example.mydsl.bookingDSL.Resource res){
			var result = ''''''
			var alreadyAddedScheduleTypes = newArrayList
			
			for(subres : res.eContents){
				if(subres instanceof Relation){
					if(subres.plurality.equals("many")){
						if(!alreadyAddedScheduleTypes.contains(subres.relationType.name)){
							result += '''Task<List<«res.name»>> Add«subres.relationType.name»ToAllResources(List<«subres.relationType.name»> collection);
							'''
							alreadyAddedScheduleTypes.add(subres.relationType.name);
						}
					}
				}
			}
			
			return result
		}
		
		static def CharSequence scheduleRelationBody(org.xtext.example.mydsl.bookingDSL.Resource res){
			var result = ''''''
			
			for(subres : res.eContents){
				if(subres instanceof Relation){
					if(subres.plurality.equals("many")){
							result += '''public async Task<List<«res.name»>> Add«subres.relationType.name»ToAllResources(List<«subres.relationType.name»> collection)
{
	var all = await GetAll(0, 1000);
	
	foreach(var res in all)
	{
		res.«subres.name».AddRange(collection);
		await this.Update(res);
	}
	
	return all.ToList();
}
							'''
					}
				}
			}
			
			return result
		}
		
}