/*
 * generated by Xtext
 */
package org.example.domainmodel;

import org.eclipse.xtext.naming.IQualifiedNameProvider;
import org.example.domainmodel.naming.DomainmodelQualifiedNameProvider;
import org.example.domainmodel.scoping.DomainModelImportedNamespaceScopeprovider;

import com.google.inject.name.Names;

/**
 * Use this class to register components to be used at runtime / without the Equinox extension registry.
 */
public class DomainmodelRuntimeModule extends org.example.domainmodel.AbstractDomainmodelRuntimeModule {

	public void configureIScopeProviderDelegate(com.google.inject.Binder binder) {
		binder.bind(org.eclipse.xtext.scoping.IScopeProvider.class).annotatedWith(Names.named(org.eclipse.xtext.scoping.impl.AbstractDeclarativeScopeProvider.NAMED_DELEGATE)).to(DomainModelImportedNamespaceScopeprovider.class);
	}
	
	@Override
	public Class<? extends IQualifiedNameProvider> bindIQualifiedNameProvider() {
		return DomainmodelQualifiedNameProvider.class;
	}
}
