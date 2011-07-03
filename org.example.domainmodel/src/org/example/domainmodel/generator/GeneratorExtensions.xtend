package org.example.domainmodel.generator

import org.eclipse.xtext.common.types.JvmTypeReference
import org.eclipse.xtext.xbase.compiler.ImportManager
import org.example.domainmodel.domainmodel.Operation

class GeneratorExtensions {
		def shortName(JvmTypeReference r, ImportManager importManager) {
		val builder = new StringBuilder()
		importManager.appendTypeRef(r, builder)
		builder.toString
	}
	
	def parameterList(Operation o, ImportManager importManager) {
		o.params.map(p| p.parameterType.shortName(importManager) + ' ' + p.name).join(''', 
			'''
		)
	}
}