package org.xtext.example.mydsl.scoping

import org.eclipse.emf.ecore.EReference
import org.eclipse.xtext.scoping.IScope
import org.eclipse.emf.ecore.EObject
import org.xtext.example.mydsl.bookingDSL.Var
import org.xtext.example.mydsl.bookingDSL.Attribute
import org.xtext.example.mydsl.bookingDSL.BookingDSLPackage.Literals
import org.eclipse.xtext.EcoreUtil2
import org.xtext.example.mydsl.bookingDSL.Entity
import org.eclipse.xtext.scoping.Scopes
import java.util.ArrayList
import java.util.HashSet
import java.util.Collections
import org.xtext.example.mydsl.bookingDSL.Customer
import org.xtext.example.mydsl.bookingDSL.Resource

class BookingDSLScopeProvider  extends AbstractBookingDSLScopeProvider  {
	
	
	override IScope getScope(EObject context , EReference reference) {
		
		switch context{
			Var case reference==Literals.VAR__NAME: {
				val customer = EcoreUtil2::getContainerOfType(context,Customer)
				val resource = EcoreUtil2::getContainerOfType(context,Resource)
				if (resource == null) {
					return Scopes.scopeFor(customer.allAttributes)
				}else {
					return Scopes.scopeFor(resource.allAttributes)
				}
				
			}
		}
		
		super.getScope(context, reference)
	}
	
	def Iterable<? extends EObject> allAttributes(Customer entity) {
		val candidates = new ArrayList<Attribute>
		val seen = new HashSet<Customer>
		var e = entity
		while (e!==null) {
			if(seen.contains(e)) return Collections.EMPTY_LIST
			seen.add(e)
			candidates.addAll(AttributeNumbers(e.members.filter(Attribute)))
			e = e.superType
		}
		candidates
	}
	
	def Iterable<? extends EObject> allAttributes(Resource entity) {
		
		val candidates = new ArrayList<Attribute>
		val seen = new HashSet<Resource>
		var e = entity
		while (e!==null) {
			if(seen.contains(e)) return Collections.EMPTY_LIST
			seen.add(e)
			candidates.addAll(e.members.filter(Attribute))
			e = e.superType
		}
		candidates
	}
	
	def Iterable<Attribute> AttributeNumbers(Iterable<Attribute> attributes) {
		return attributes
	}
	
}