package org.xtext.example.mydsl.generator.ClientAppGenerators

import org.eclipse.xtext.generator.IFileSystemAccess2
import org.eclipse.emf.ecore.resource.Resource
import org.xtext.example.mydsl.bookingDSL.Customer
import org.xtext.example.mydsl.bookingDSL.Attribute
import org.xtext.example.mydsl.bookingDSL.Declaration
import org.xtext.example.mydsl.bookingDSL.Entity
import org.xtext.example.mydsl.bookingDSL.Schedule
import org.xtext.example.mydsl.bookingDSL.Booking


class ModelGenerator {
	
	private IFileSystemAccess2 fsa;
	private Resource resource;
	private String modelsRoot;
	
	new(IFileSystemAccess2 fsa, Resource resource, String srcRoot) {
		this.fsa = fsa;
		this.resource = resource;
		this.modelsRoot = srcRoot + "/api/models";
	}
	
	def generate() {
		this.resource.allContents.filter(Declaration).forEach[generateModels(fsa)]
	}
	
	def generateModels(Declaration declaration , IFileSystemAccess2 access2) {
		switch declaration {
			Customer: generateModels(declaration , "customers")
			org.xtext.example.mydsl.bookingDSL.Resource: generateModels(declaration , "resources")
			Entity: generateModels(declaration , "entities")
			Schedule: generateModels(declaration , "schedules")
			Booking: generateModels(declaration , "bookings")
				
		}
	}
	
	def generateModels(Declaration decleration , String root) {
		fsa.generateFile(this.modelsRoot +"/" + root + "/" +  decleration.name.toFirstLower +".ts" , decleration.generateAttributes)
	}
	
	
	def CharSequence generateAttributes(Declaration declaration) {
		'''
		export type «declaration.name.toFirstUpper» = {
			«FOR mem : declaration.members»
			«IF (mem instanceof Attribute)»
			«IF mem.type.value == 0»
			«mem.name»: number
			
			«ELSEIF mem.type.value == 2»
			«mem.name»: boolean
			«ELSE»
			«mem.name»: «mem.type»;
			«ENDIF»
			«ENDIF»
			«ENDFOR»
		   
		} 
		'''
	}
	
	
	
}