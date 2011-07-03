package org.example.domainmodel.jvmmodel
 
import org.eclipse.xtext.xbase.jvmmodel.IJvmModelInferrer
import org.eclipse.xtext.xbase.jvmmodel.IJvmModelAssociator
import org.eclipse.xtext.common.types.JvmDeclaredType
import org.eclipse.emf.ecore.EObject
import java.util.List
import com.google.inject.Inject
import org.eclipse.xtext.common.types.TypesFactory
import org.eclipse.xtext.xbase.jvmmodel.JvmVisibilityExtension
import static org.eclipse.xtext.EcoreUtil2.*
import org.eclipse.xtext.common.types.JvmGenericType
import org.example.domainmodel.domainmodel.Domainmodel
import org.example.domainmodel.domainmodel.PackageDeclaration
import org.example.domainmodel.domainmodel.Entity
import org.example.domainmodel.domainmodel.Import
import org.example.domainmodel.domainmodel.Feature
import org.eclipse.xtext.common.types.JvmVisibility
import org.example.domainmodel.domainmodel.Property
import org.example.domainmodel.domainmodel.Operation

/**
 * <p>Infers a JVM model from the source model.</p> 
 *
 * <p>The JVM model should contain all elements that would appear in the Java code 
 * which is generated from the source model. 
 * Other Xtend models link against the JVM model rather than the source model. The JVM
 * model elements should be associated with their source element by means of the
 * {@link IJvmModelAssociator}.</p>     
 */
class DomainmodelJvmModelInferrer implements IJvmModelInferrer {

	@Inject TypesFactory typesFactory
	
	@Inject extension IJvmModelAssociator jvmModelAssociator
	
	@Inject extension DomainmodelExtensions domainmodelExtensions

	override List<JvmDeclaredType> inferJvmModel(EObject sourceObject) {
		sourceObject.disassociate
		transform( sourceObject ).toList
	}
	
	def dispatch Iterable<JvmDeclaredType> transform(Domainmodel model) {
		model.elements.map(e | transform(e)).flatten
	}
	 
	def dispatch Iterable<JvmDeclaredType> transform(PackageDeclaration packageDecl) {
		packageDecl.elements.map(e | transform(e)).flatten
	}

	def dispatch Iterable<JvmDeclaredType> transform(Entity entity) {
		val jvmClass = typesFactory.createJvmGenericType 
		jvmClass.simpleName = entity.name
		jvmClass.packageName = entity.packageName
		entity.associatePrimary(jvmClass)
		jvmClass.setVisibility(JvmVisibility::PUBLIC)
		if (entity.superType != null)
			jvmClass.superTypes += cloneWithProxies(entity.superType)
		for(f : entity.features) {
			transform(f, jvmClass)
		} 
		newArrayList(jvmClass as JvmDeclaredType) 	 
	}
	
	def dispatch Iterable<JvmDeclaredType> transform(Import importDecl) {
		emptyList
	}
	
	def dispatch void transform(Property property, JvmGenericType type) {
		val jvmField = typesFactory.createJvmField
		jvmField.simpleName = property.name
		jvmField.type = cloneWithProxies(property.type)
		jvmField.setVisibility(JvmVisibility::PRIVATE)
		type.members += jvmField
		property.associatePrimary(jvmField)
		
		val jvmGetter = typesFactory.createJvmOperation
		jvmGetter.simpleName = "get" + property.name.toFirstUpper
		jvmGetter.returnType = cloneWithProxies(property.type)
		jvmGetter.setVisibility(JvmVisibility::PUBLIC)
		type.members += jvmGetter
		property.associatePrimary(jvmGetter)
		
		val jvmSetter = typesFactory.createJvmOperation
		jvmSetter.simpleName = "set" + property.name.toFirstUpper
		val parameter = typesFactory.createJvmFormalParameter
		parameter.name = property.name.toFirstUpper
		parameter.parameterType = cloneWithProxies(property.type)
		jvmSetter.setVisibility(JvmVisibility::PUBLIC)
		jvmSetter.parameters += parameter
		type.members += jvmSetter
		property.associatePrimary(jvmSetter)
	}
	
	def dispatch void transform(Operation operation, JvmGenericType type) {
		val jvmOperation = typesFactory.createJvmOperation
		jvmOperation.simpleName = operation.name
		jvmOperation.returnType = cloneWithProxies(operation.type)
		jvmOperation.parameters.addAll(operation.params.map(p|cloneWithProxies(p))) 
		jvmOperation.setVisibility(JvmVisibility::PUBLIC)
		type.members += jvmOperation
		operation.associatePrimary(jvmOperation)
	}
}
