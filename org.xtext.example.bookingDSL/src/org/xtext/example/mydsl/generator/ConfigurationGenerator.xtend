package org.xtext.example.mydsl.generator

import org.eclipse.xtext.generator.IFileSystemAccess2
import org.eclipse.emf.ecore.resource.Resource
import org.xtext.example.mydsl.bookingDSL.*;

class ConfigurationGenerator {
	static def void generateConfigurationFile(IFileSystemAccess2 fsa,
		Resource resource)
	{
		var systemName = resource.allContents.toList.filter(System).get(0).getName();
		
		fsa.generateFile('''«systemName»/«systemName»/Configuration/PersistenceConfiguration.cs''', 
			'''
			namespace «systemName».Configuration
			{
			    public class PersistenceConfiguration
			    {
			        public string MongoClusterConnectionString { get; set; }
			        public string DefaultDatabaseName { get; set; }
			    }
			}
			''')
	}
}