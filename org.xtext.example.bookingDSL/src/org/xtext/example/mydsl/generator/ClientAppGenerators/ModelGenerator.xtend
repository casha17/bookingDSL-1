package org.xtext.example.mydsl.generator.ClientAppGenerators

import org.eclipse.xtext.generator.IFileSystemAccess2
import org.eclipse.emf.ecore.resource.Resource
import org.xtext.example.mydsl.bookingDSL.Customer
import org.xtext.example.mydsl.bookingDSL.Attribute
import org.xtext.example.mydsl.bookingDSL.Declaration
import org.xtext.example.mydsl.bookingDSL.Entity
import org.xtext.example.mydsl.bookingDSL.Schedule
import org.xtext.example.mydsl.bookingDSL.Booking
import org.xtext.example.mydsl.bookingDSL.Relation

class ModelGenerator {
	
	private IFileSystemAccess2 fsa;
	private Resource resource;
	private String modelsRoot;
	private String requestModelsRoot;
	
	new(IFileSystemAccess2 fsa, Resource resource, String srcRoot) {
		this.fsa = fsa;
		this.resource = resource;
		this.modelsRoot = srcRoot + "/api/models";
		this.requestModelsRoot = srcRoot + "/api/requestModels";
	}
	
	def generate() {
		this.resource.allContents.filter(Declaration).forEach[generateModels(fsa)]
		this.resource.allContents.filter(Declaration).forEach[generateRequestModels]
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
		fsa.generateFile(this.modelsRoot +"/" + root + "/" +  decleration.name +".ts" , decleration.generateAttributes)
	}
	
	def generateAttribute(Attribute attri, String type) {
		return attri.name + ": " + type + (attri.array ? "[]" : "");
	}
	
	def generateRequestModels(Declaration declaration) {
		
		var type = "";
		
		
		switch declaration {
			Customer: type = "customers"
			org.xtext.example.mydsl.bookingDSL.Resource: type="resources"
			Entity: type="entities"
			Schedule: type="schedules"
			Booking: type="bookings"
		}
		
		this.fsa.generateFile(this.requestModelsRoot + "/Create" + declaration.name + "RequestModel.ts", 
			'''
			«FOR mem:declaration.members»
				«IF(mem instanceof Relation)»
				import {«mem.relationType.name.toFirstUpper»} from "../models/«getDeclarationType(mem.relationType)»/«mem.relationType.name.toFirstUpper»"
				«ENDIF»
			«ENDFOR»
			export type Create«declaration.name.toFirstUpper»RequestModel = {
				«FOR mem : declaration.members»
					«IF (mem instanceof Attribute)»
						«IF mem.type.value == 0 || mem.type.value == 3»
						«this.generateAttribute(mem, "number")»
						«ELSEIF mem.type.value == 2»
						«this.generateAttribute(mem, "boolean")»
						«ELSE»
						«this.generateAttribute(mem, "string")»
						«ENDIF»
					«ENDIF»
					«IF (mem instanceof Relation)»
						«IF(mem.plurality == "many")»
						«mem.name»: «mem.relationType.name»[]
						«ELSE»
						«mem.name»: «mem.relationType.name»
						«ENDIF»
					«ENDIF»
				«ENDFOR»
			} 
			'''
		)
		
		this.fsa.generateFile(this.requestModelsRoot + "/Update" + declaration.name + "RequestModel.ts",
			'''
			«FOR mem:declaration.members»
				«IF(mem instanceof Relation)»
				import {«mem.relationType.name.toFirstUpper»} from "../models/«getDeclarationType(mem.relationType)»/«mem.relationType.name.toFirstUpper»"
				«ENDIF»
			«ENDFOR»
			export type Update«declaration.name.toFirstUpper»RequestModel = {
				id: string
				«FOR mem : declaration.members»
					«IF (mem instanceof Attribute)»
						«IF mem.type.value == 0 || mem.type.value == 3»
						«this.generateAttribute(mem, "number")»
						«ELSEIF mem.type.value == 2»
						«this.generateAttribute(mem, "boolean")»
						«ELSE»
						«this.generateAttribute(mem, "string")»
						«ENDIF»
					«ENDIF»
					«IF (mem instanceof Relation)»
						«IF(mem.plurality == "many")»
						«mem.name»: «mem.relationType.name»[]
						«ELSE»
						«mem.name»: «mem.relationType.name»
						«ENDIF»
					«ENDIF»
				«ENDFOR»
			} 
			'''
		)
	}
	
	def getDeclarationType(Declaration declaration) {
		switch declaration {
			Customer: "customers"
			org.xtext.example.mydsl.bookingDSL.Resource: "resources"
			Entity: "entities"
			Schedule: "schedules"
			Booking: "bookings"
		}
	}
	
	def CharSequence generateAttributes(Declaration declaration) {
		
		var type = "";
		
		
		switch declaration {
			Customer: type = "customers"
			org.xtext.example.mydsl.bookingDSL.Resource: type="resources"
			Entity: type="entities"
			Schedule: type="schedules"
			Booking: type="bookings"
		}
		
		'''
		«FOR mem:declaration.members»
			«IF(mem instanceof Relation)»
			import {«mem.relationType.name.toFirstUpper»} from "../«getDeclarationType(mem.relationType)»/«mem.relationType.name.toFirstUpper»"
			«ENDIF»
		«ENDFOR»
		
		export type «declaration.name.toFirstUpper» = {
			id: string
			«FOR mem : declaration.members»
				«IF (mem instanceof Attribute)»
					«IF mem.type.value == 0 || mem.type.value == 3»
					«this.generateAttribute(mem, "number")»
					«ELSEIF mem.type.value == 2»
					«this.generateAttribute(mem, "boolean")»
					«ELSE»
					«this.generateAttribute(mem, "string")»
					«ENDIF»
				«ENDIF»
				«IF (mem instanceof Relation)»
					«IF(mem.plurality == "many")»
					«mem.name»: «mem.relationType.name»[]
					«ELSE»
					«mem.name»: «mem.relationType.name»
					«ENDIF»
				«ENDIF»
			«ENDFOR»
		} 
		'''
	}
	
	
	
}