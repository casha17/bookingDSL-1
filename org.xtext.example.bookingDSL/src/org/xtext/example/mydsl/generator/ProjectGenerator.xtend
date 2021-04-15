package org.xtext.example.mydsl.generator

import org.eclipse.xtext.generator.IFileSystemAccess2
import org.xtext.example.mydsl.generator.ClientAppGenerators.ClientAppGenerator
import org.eclipse.emf.ecore.resource.Resource
import org.xtext.example.mydsl.bookingDSL.*;
import org.xtext.example.mydsl.generator.persistence.ModelsGenerator
import org.xtext.example.mydsl.generator.persistence.RepositoriesGenerator
import org.xtext.example.mydsl.generator.controllers.ControllerGenerator
import org.xtext.example.mydsl.generator.handlers.HandlersGenerator
import org.xtext.example.mydsl.generator.requestmodels.CreateRequestModelGenerator
import org.xtext.example.mydsl.generator.requestmodels.UpdateRequestModelGenerator
import org.xtext.example.mydsl.generator.mapping.MappingProfileGenerator

class ProjectGenerator {
	
	private IFileSystemAccess2 fsa;
	private Resource resource;
	private String systemName;
	private String slnRoot;
	private String projRoot;
	private ClientAppGenerator clientAppGenerator;
	
	new (IFileSystemAccess2 fsa, Resource resource) {
		this.fsa = fsa;
		this.resource = resource;
		
		var system = resource.allContents.toList.filter(System).get(0);
		
		this.systemName = system.getName();
		this.slnRoot = '''«systemName»/'''
		this.projRoot = '''«this.slnRoot»/«systemName»'''
		this.clientAppGenerator = new ClientAppGenerator(fsa, resource, this.projRoot);
	}
	
	
	 	
	def void generateProject() {
		generateSLN()
		this.clientAppGenerator.generate()
		DockerComposeGenerator.generateComposeFile(this.fsa, this.resource)
		AppSettingsGenerator.generateAppSettings(this.fsa, this.resource)
		CsprojGenerator.generateCSProjFile(this.fsa, this.resource)
		GitIgnoreGenerator.generateGitIgnoreFile(this.fsa, this.resource)
		ConfigurationGenerator.generateConfigurationFile(this.fsa, this.resource)
		StartupGenerator.generateStartupFile(this.fsa, this.resource)
		ProgramFileGenerator.generateProgramFile(this.fsa, this.resource)
		CreateRequestModelGenerator.generateRequestModelsFile(this.fsa, this.resource)
		UpdateRequestModelGenerator.generateRequestModelsFile(this.fsa, this.resource)
		LaunchSettingsGenerator.generateLaunchSettingsFile(this.fsa, this.resource)
		ModelsGenerator.generateModels(this.fsa, this.resource)
		RepositoriesGenerator.generateRepositories(this.fsa, this.resource)
		ControllerGenerator.generateControllers(this.fsa, this.resource)
		HandlersGenerator.generateHandlers(this.fsa, this.resource)
		MappingProfileGenerator.generateModels(this.fsa, this.resource)
	}
	
	 	
	 	
	private def void generateSLN(){
		this.fsa.generateFile('''«this.slnRoot»/«this.systemName».sln''',
			'''
			Microsoft Visual Studio Solution File, Format Version 12.00
			Project("{FAE04EC0-301F-11D3-BF4B-00C04F79EFBC}") = "«this.systemName»", "«this.systemName»\«this.systemName».csproj", "{EAB93814-2186-4066-92D6-465196A4DFA5}"
			EndProject
			Global
				GlobalSection(SolutionConfigurationPlatforms) = preSolution
					Debug|Any CPU = Debug|Any CPU
					Release|Any CPU = Release|Any CPU
				EndGlobalSection
				GlobalSection(ProjectConfigurationPlatforms) = postSolution
					{EAB93814-2186-4066-92D6-465196A4DFA5}.Debug|Any CPU.ActiveCfg = Debug|Any CPU
					{EAB93814-2186-4066-92D6-465196A4DFA5}.Debug|Any CPU.Build.0 = Debug|Any CPU
					{EAB93814-2186-4066-92D6-465196A4DFA5}.Release|Any CPU.ActiveCfg = Release|Any CPU
					{EAB93814-2186-4066-92D6-465196A4DFA5}.Release|Any CPU.Build.0 = Release|Any CPU
				EndGlobalSection
			EndGlobal
			'''
		)
	}
	
}