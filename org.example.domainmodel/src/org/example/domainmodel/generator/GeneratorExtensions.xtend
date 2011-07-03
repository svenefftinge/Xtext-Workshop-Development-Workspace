package org.example.domainmodel.generator

import org.eclipse.xtext.common.types.JvmTypeReference
import org.eclipse.xtext.xbase.compiler.ImportManager

class GeneratorExtensions {
		def shortName(JvmTypeReference r, ImportManager importManager) {
		val builder = new StringBuilder()
		importManager.appendTypeRef(r, builder)
		builder.toString
	}
}