package org.xtext.example.mydsl.ui

import org.eclipse.xtext.documentation.IEObjectDocumentationProvider
import org.eclipse.emf.ecore.EObject
import org.xtext.example.mydsl.bookingDSL.Customer
import org.xtext.example.mydsl.bookingDSL.Entity
import org.xtext.example.mydsl.bookingDSL.Resource
import org.xtext.example.mydsl.bookingDSL.Booking
import org.xtext.example.mydsl.bookingDSL.Schedule

class BookingDSLEObjectDocumentationProvider implements IEObjectDocumentationProvider  {
	
	override getDocumentation(EObject o) {
		if (o instanceof org.xtext.example.mydsl.bookingDSL.System) {
			return'''System defines the overrall structure of the system being defined'''
		}
		
		if (o instanceof Customer) {
			return'''A customer is used to define the users of the system'''
		}
		
		if (o instanceof Entity) {
			return'''Entities in the system are used to define any entity which can have many resources'''
		}
		
		if (o instanceof Resource) {
			return'''Resources in the system are anything that can be booked by any customer and can live on any schedule'''
		}
		if (o instanceof Booking) {
			return'''Booking are the entity which holds all the information of a booking. It is important to have a relation to Customer, Schedule and resource'''
		}
		
		if (o instanceof Schedule) {
			return'''Schedule are used to defined the schedules that the resources exists on'''
		}
		return null
	}
	
}