package org.xtext.example.mydsl.generator

import org.eclipse.xtext.generator.IFileSystemAccess2
import org.eclipse.emf.ecore.resource.Resource
import org.xtext.example.mydsl.bookingDSL.*;

class LaunchSettingsGenerator {
	static def void generateLaunchSettingsFile(IFileSystemAccess2 fsa,
		Resource resource)
	{
		var systemName = resource.allContents.toList.filter(System).get(0).getName();
		
		fsa.generateFile('''«systemName»/«systemName»/Properties/launchSettings.json''', 
			'''
			{
			  "iisSettings": {
			    "windowsAuthentication": false,
			    "anonymousAuthentication": true,
			    "iisExpress": {
			      "applicationUrl": "http://localhost:21025",
			      "sslPort": 44342
			    }
			  },
			  "profiles": {
			    "IIS Express": {
			      "commandName": "IISExpress",
			      "launchBrowser": true,
			      "environmentVariables": {
			        "ASPNETCORE_ENVIRONMENT": "Development"
			      }
			    },
			    "«systemName»": {
			      "commandName": "Project",
			      "launchBrowser": true,
			      "applicationUrl": "https://localhost:5001;http://localhost:5000",
			      "environmentVariables": {
			        "ASPNETCORE_ENVIRONMENT": "Development"
			      }
			    }
			  }
			}
			''')
	}
}