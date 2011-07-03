package org.example.domainmodel.scoping;

import java.util.List;

import org.eclipse.emf.ecore.EObject;
import org.eclipse.xtext.naming.IQualifiedNameProvider;
import org.eclipse.xtext.scoping.impl.ImportNormalizer;
import org.eclipse.xtext.xbase.scoping.XbaseImportedNamespaceScopeProvider;
import org.example.domainmodel.domainmodel.PackageDeclaration;

import com.google.inject.Inject;

@SuppressWarnings("restriction")
public class DomainModelImportedNamespaceScopeprovider extends XbaseImportedNamespaceScopeProvider{

	@Inject
	private IQualifiedNameProvider qualifiedNameProvider;
	
	@Override
	protected List<ImportNormalizer> internalGetImportedNamespaceResolvers(
			EObject context, boolean ignoreCase) {
		
		List<ImportNormalizer> importedNamespaceResolvers = super.internalGetImportedNamespaceResolvers(context, ignoreCase);
		EObject eContainer = context.eContainer();
		if(eContainer != null && eContainer instanceof PackageDeclaration){
			importedNamespaceResolvers.add(new ImportNormalizer(qualifiedNameProvider.getFullyQualifiedName(eContainer), true, false));
		}
		return importedNamespaceResolvers;
	}
}
