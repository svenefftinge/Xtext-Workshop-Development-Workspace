package org.example.domainmodel.scoping

import org.eclipse.xtext.xbase.scoping.XbaseScopeProvider
import org.eclipse.xtext.xbase.jvmmodel.IJvmModelAssociations
import com.google.inject.Inject
import org.eclipse.xtext.scoping.IScope
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EReference
import org.example.domainmodel.domainmodel.Operation
import org.eclipse.xtext.scoping.impl.MapBasedScope
import org.eclipse.xtext.common.types.JvmFormalParameter
import org.eclipse.xtext.naming.QualifiedName
import org.eclipse.xtext.resource.EObjectDescription
import org.eclipse.xtext.common.types.JvmType
import org.example.domainmodel.domainmodel.Entity
import org.eclipse.xtext.common.types.JvmDeclaredType
import org.eclipse.xtext.EcoreUtil2

class DomainmodelScopeProvider extends XbaseScopeProvider {

	@Inject extension IJvmModelAssociations associations
	
	override IScope createLocalVarScope(EObject context, EReference reference, IScope parent,
			boolean includeCurrentBlock, int idx) {
		if(context instanceof Operation){
				val descriptions = (context as Operation).params.map(e | e.createIEObjectDescription())
				return MapBasedScope::createScope(
						super.createLocalVarScope(context, reference, parent, includeCurrentBlock, idx), descriptions);	
		}
		return super.createLocalVarScope(context, reference, parent, includeCurrentBlock, idx)
	}
	
	def createIEObjectDescription(JvmFormalParameter jvmFormalParameter) {
		EObjectDescription::^create(QualifiedName::^create(jvmFormalParameter.name), jvmFormalParameter, null);
	}

	def JvmType getJvmType(Entity entity) {
		entity.jvmElements.filter(typeof(JvmType)).head
	}
	
	override JvmDeclaredType getContextType(EObject call) {
		if (call == null)
			return null
		val containerClass = EcoreUtil2::getContainerOfType(call, typeof(Entity));
		if (containerClass != null)
			return getJvmType(containerClass) as JvmDeclaredType
		else
			return super.getContextType(call)
	}
}