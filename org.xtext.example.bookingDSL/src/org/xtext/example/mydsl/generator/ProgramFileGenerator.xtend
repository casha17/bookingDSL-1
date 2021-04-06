package org.xtext.example.mydsl.generator

import org.eclipse.xtext.generator.IFileSystemAccess2
import org.eclipse.emf.ecore.resource.Resource
import org.xtext.example.mydsl.bookingDSL.*;

class ProgramFileGenerator {
	static def void generateProgramFile(IFileSystemAccess2 fsa,
		Resource resource)
	{
		var systemName = resource.allContents.toList.filter(System).get(0).getName();
		
		fsa.generateFile('''«systemName»/«systemName»/Program.cs''', 
			'''
			using System;
			using System.Collections.Generic;
			using System.Linq;
			using System.Threading.Tasks;
			using Microsoft.AspNetCore.Hosting;
			using Microsoft.Extensions.Configuration;
			using Microsoft.Extensions.Hosting;
			using Microsoft.Extensions.Logging;
			
			namespace «systemName»
			{
			    public class Program
			    {
			        public static void Main(string[] args)
			        {
			            CreateHostBuilder(args).Build().Run();
			        }
			
			        public static IHostBuilder CreateHostBuilder(string[] args) =>
			            Host.CreateDefaultBuilder(args)
			                .ConfigureWebHostDefaults(webBuilder => { webBuilder.UseStartup<Startup>(); });
			    }
			}
			''')
	}
}