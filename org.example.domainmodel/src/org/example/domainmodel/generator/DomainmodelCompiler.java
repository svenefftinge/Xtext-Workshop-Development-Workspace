package org.example.domainmodel.generator;

import org.eclipse.xtext.common.types.JvmFormalParameter;
import org.eclipse.xtext.common.types.JvmGenericType;
import org.eclipse.xtext.xbase.XAbstractFeatureCall;
import org.eclipse.xtext.xbase.XExpression;
import org.eclipse.xtext.xbase.compiler.IAppendable;
import org.eclipse.xtext.xbase.compiler.ImportManager;
import org.eclipse.xtext.xbase.compiler.StringBuilderBasedAppendable;
import org.eclipse.xtext.xbase.compiler.XbaseCompiler;
import org.example.domainmodel.domainmodel.Operation;

@SuppressWarnings("restriction")
public class DomainmodelCompiler extends XbaseCompiler {

	public String compile(Operation operation, ImportManager importManager) {
		StringBuilderBasedAppendable appendable = new StringBuilderBasedAppendable(importManager);
		for(JvmFormalParameter param: operation.getParams()) {
			appendable.declareVariable(param, param.getName());
		}
		return compile(operation.getBody(), appendable, operation.getType()).toString();
	}

	@Override
	protected boolean isVariableDeclarationRequired(XExpression expr, IAppendable b) {
		if (expr instanceof XAbstractFeatureCall 
				&& ((XAbstractFeatureCall)expr).getFeature() instanceof JvmGenericType) {
			return false;
		}
		return super.isVariableDeclarationRequired(expr,b);
	}

	@Override
	protected String getVarName(Object ex, IAppendable appendable) {
		if(ex instanceof JvmGenericType) {
			return "this";
		}
		return super.getVarName(ex, appendable);
	}
}
