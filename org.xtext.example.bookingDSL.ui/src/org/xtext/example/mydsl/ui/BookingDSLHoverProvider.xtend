package org.xtext.example.mydsl.ui

import org.eclipse.xtext.ui.editor.hover.html.DefaultEObjectHoverProvider
import org.eclipse.emf.ecore.EObject
import org.xtext.example.mydsl.bookingDSL.Attribute
import org.xtext.example.mydsl.bookingDSL.Customer
import org.xtext.example.mydsl.bookingDSL.Entity
import org.xtext.example.mydsl.bookingDSL.Resource
import org.xtext.example.mydsl.bookingDSL.Booking
import org.xtext.example.mydsl.bookingDSL.Schedule

class BookingDSLHoverProvider extends DefaultEObjectHoverProvider {
	
	override protected String getFirstLine(EObject o) {
		if (o instanceof org.xtext.example.mydsl.bookingDSL.System) {
			return'''System'''
		}
		
		if (o instanceof Customer) {
			return'''Customer : <b>«o.name»</b>'''
		}
		
		if (o instanceof Entity) {
			return'''Entity : <b>«o.name»</b>'''
		}
		
		if (o instanceof Resource) {
			return'''Resource: <b>«o.name»</b>'''
		}
		if (o instanceof Booking) {
			return'''Booking : <b>«o.name»</b>'''
		}
		
		if (o instanceof Schedule) {
			return'''Schedule : <b>«o.name»</b>'''
		}
		return super.getFirstLine(o);
	}
	
	
}