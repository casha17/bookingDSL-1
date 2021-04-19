package org.xtext.example.mydsl.generator

import org.eclipse.xtext.generator.IFileSystemAccess2
import org.eclipse.emf.ecore.resource.Resource
import org.xtext.example.mydsl.bookingDSL.*;

class AppSettingsGenerator {
	static def void generateAppSettings(IFileSystemAccess2 fsa,
		Resource resource
	){
		var systemName = resource.allContents.toList.filter(System).get(0).getName();
		
		fsa.generateFile('''«systemName»/«systemName»/appsettings.json''', 
			'''
			{
			  "Logging": {
			      "LogLevel": {
			      "Default": "Information",
			      "Microsoft": "Warning",
			      "Microsoft.Hosting.Lifetime": "Information"
			      }
			    },
			
			    "PersistenceConfiguration": {
			      "MongoClusterConnectionString": "mongodb://mongodb_container:27017",
			      "DefaultDatabaseName": "«systemName»_Repo"
			    },
			  
			"AllowedHosts": "*"
			}
			''')
			
		fsa.generateFile('''«systemName»/«systemName»/appsettings.Development.json''',
			'''
			{
			  "Logging": {
			    "LogLevel": {
			      "Default": "Information",
			      "Microsoft": "Warning",
			      "Microsoft.Hosting.Lifetime": "Information"
			    }
			  }
			}
			'''
		)
	}
}