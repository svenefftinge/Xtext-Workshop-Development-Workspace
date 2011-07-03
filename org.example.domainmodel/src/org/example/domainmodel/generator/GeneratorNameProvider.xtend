package org.example.domainmodel.generator

import org.example.domainmodel.domainmodel.*
import static org.eclipse.xtext.EcoreUtil2.*
import org.eclipse.xtext.naming.QualifiedName
import org.eclipse.emf.ecore.EObject
import com.google.inject.Inject
import org.eclipse.xtext.naming.IQualifiedNameProvider

class GeneratorNameProvider {
	
	@Inject IQualifiedNameProvider qualifiedNameProvider
	
	/* For Entities only the simpleName */
	def dispatch qualifiedName(Entity entity){
		entity.name.toQualifiedName
	}
	
	/* For DataTypes inside of java.lang only the simpleName */
	def dispatch qualifiedName(DataType dataType){
		val packageDeclaration = getContainerOfType(dataType, typeof(PackageDeclaration));
		if(packageDeclaration == null || packageDeclaration.name.equals("java.lang"))
			return dataType.name.toQualifiedName
		else
			(packageDeclaration.name + "." + dataType.name).toQualifiedName
	}
	
	def dispatch qualifiedName(EObject eObject){
		qualifiedNameProvider.getFullyQualifiedName(eObject)
	}
	
	def toQualifiedName(String name){
		QualifiedName::create(name)
	}
	
	def fullyQualifiedName(EObject eObject){
		qualifiedName(eObject);
	}
	
}