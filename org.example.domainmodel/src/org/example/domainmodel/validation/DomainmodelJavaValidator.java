package org.example.domainmodel.validation;

import org.eclipse.xtext.common.types.JvmTypeReference;
import org.eclipse.xtext.validation.Check;
import org.eclipse.xtext.xbase.typing.XbaseTypeConformanceComputer;
import org.eclipse.xtext.xbase.validation.XbaseJavaValidator;
import org.example.domainmodel.domainmodel.DomainmodelPackage;
import org.example.domainmodel.domainmodel.Operation;
import org.example.domainmodel.typing.DomainmodelTypeProvider;

import com.google.inject.Inject;


@SuppressWarnings("restriction")
public class DomainmodelJavaValidator extends XbaseJavaValidator {
	
	@Inject
	private XbaseTypeConformanceComputer typeConformanceComputer;
	
	@Inject 
	private DomainmodelTypeProvider typeProvider;
	
	
	@Check
	public void checkTypeConformanceOfOperation(Operation op){
		JvmTypeReference expectedType = typeProvider.getExpectedType(op.getBody());
		JvmTypeReference commonReturnType = typeProvider.getCommonReturnType(op.getBody(), true);
		if(!typeConformanceComputer.isConformant(expectedType, commonReturnType))
			error("Type is not conform to expected type!",DomainmodelPackage.Literals.OPERATION__BODY);
	}
	
}