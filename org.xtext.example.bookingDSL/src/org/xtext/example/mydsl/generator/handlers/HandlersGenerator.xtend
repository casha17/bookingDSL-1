package org.xtext.example.mydsl.generator.handlers

import org.eclipse.xtext.generator.IFileSystemAccess2
import org.eclipse.emf.ecore.resource.Resource
import org.xtext.example.mydsl.bookingDSL.*;

class HandlersGenerator {
	static def void generateHandlers(IFileSystemAccess2 fsa,
		Resource resource)
	{
		var systemName = resource.allContents.toList.filter(System).get(0).getName();
		genUserHandler(fsa, resource, systemName)
		
	}
	
	private static def void genUserHandler(IFileSystemAccess2 fsa,
		Resource resource, String systemName){
			fsa.generateFile('''«systemName»/«systemName»/Handlers/UserHandler.cs''', 
			'''
			using System.Threading.Tasks;
			using «systemName».Persistence.Repositories;
			
			namespace «systemName».Handlers
			{
			    public interface IUserHandler
			    {
			        Task<bool> CreateUser();
			    }
			    
			    public class UserHandler : IUserHandler
			    {
			        private readonly IUserRepository _userRepository;
			
			        public UserHandler(IUserRepository userRepository)
			        {
			            _userRepository = userRepository;
			        }
			
			        public async Task<bool> CreateUser()
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