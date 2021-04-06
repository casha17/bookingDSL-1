package org.xtext.example.mydsl.generator.controllers

import org.eclipse.xtext.generator.IFileSystemAccess2
import org.eclipse.emf.ecore.resource.Resource
import org.xtext.example.mydsl.bookingDSL.*;

class ControllerGenerator {
	static def void generateControllers(IFileSystemAccess2 fsa,
		Resource resource)
	{
		var systemName = resource.allContents.toList.filter(System).get(0).getName();
		genUserController(fsa, resource, systemName)
	}
	
	private static def void genUserController(IFileSystemAccess2 fsa,
		Resource resource, String systemName){
			fsa.generateFile('''«systemName»/«systemName»/Controllers/UserController.cs''',
				'''
				using System;
				using System.Threading.Tasks;
				using «systemName».Handlers;
				using «systemName».RequestModels;
				using Microsoft.AspNetCore.Mvc;
				
				namespace «systemName».Controllers
				{
				    [Route("users")]
				    public class UserController : ControllerBase
				    {
				        private readonly IUserHandler _userHandler;
				
				        public UserController(IUserHandler userHandler)
				        {
				            _userHandler = userHandler;
				        }
				
				        [HttpGet]
				        [Route("")]
				        public async Task<IActionResult> GetUsers(int page, int pageSize)
				        {
				            return new ObjectResult(new []{"Casper", "Ulrik", "Morten", "Oskar"});
				        }
				
				        [HttpGet]
				        [Route("{id}")]
				        public async Task<IActionResult> GetUser(Guid id)
				        {
				            return new ObjectResult(new {name = "Casper"});
				        }
				
				        [HttpPost]
				        [Route("")]
				        public async Task<IActionResult> CreateUser([FromBody]CreateUserRequestModel rm)
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