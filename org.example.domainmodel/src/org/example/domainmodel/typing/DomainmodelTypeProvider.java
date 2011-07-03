/*******************************************************************************
 * Copyright (c) 2011 itemis AG (http://www.itemis.eu) and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *******************************************************************************/
package org.example.domainmodel.typing;

import org.eclipse.emf.ecore.EReference;
import org.eclipse.xtext.common.types.JvmTypeReference;
import org.eclipse.xtext.xbase.typing.XbaseTypeProvider;
import org.example.domainmodel.domainmodel.DomainmodelPackage;
import org.example.domainmodel.domainmodel.Operation;

import com.google.inject.Singleton;

@SuppressWarnings("restriction")
@Singleton
public class DomainmodelTypeProvider extends XbaseTypeProvider {

	/**
	 * The operation body is expected to return the declared return type of 
	 * the operation itself.
	 * @return the operation's return type or null if queried with another reference or for an invalid reference.
	 */
	protected JvmTypeReference _expectedType(Operation operation, EReference reference, int index, boolean rawType) {
		if(reference == DomainmodelPackage.Literals.OPERATION__BODY) {
			return operation.getType();
		}				
		return null; 
	}
}
