package org.example.domainmodel.generator 

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IGenerator
import org.eclipse.xtext.generator.IFileSystemAccess
import org.eclipse.xtext.naming.IQualifiedNameProvider
import com.google.inject.Inject
import org.example.domainmodel.domainmodel.*
import static extension org.eclipse.xtext.xtend2.lib.ResourceExtensions.*
import org.eclipse.xtext.xbase.compiler.ImportManager

class DomainmodelGenerator implements IGenerator {
    
    @Inject extension IQualifiedNameProvider nameProvider 
    @Inject extension GeneratorExtensions generatorExtensions
    
    override void doGenerate(Resource resource, IFileSystemAccess fsa) {
        for(e: resource.allContentsIterable.filter(typeof(Entity))) {
            fsa.generateFile(
                e.fullyQualifiedName.toString.replace(".", "/") + ".java",
                e.compile)
        }
    }
    
    def compile(Entity e) 
    	''' 
		«val importManager = new ImportManager(true)»
		«IF e.eContainer != null»
			package «e.eContainer.fullyQualifiedName»;
		«ENDIF»
		«val body = e.body(importManager)»
		«FOR i:importManager.imports»
			import «i»;
		«ENDFOR»
		«body»
       '''
    
    def body(Entity e, ImportManager importManager){
    	'''
		public class «e.name» «IF e.superType != null»extends «e.superType.shortName(importManager)» «ENDIF»{
			«FOR f:e.features»
				«f.compile(importManager)»
			«ENDFOR»
		}
    	'''
    }
    
    def compile(Feature f, ImportManager importManager) '''
        private «f.type.shortName(importManager)» «f.name»;
        
        public «f.type.shortName(importManager)» get«f.name.toFirstUpper»() {
            return «f.name»;
        }
        
        public void set«f.name.toFirstUpper»(«f.type.shortName(importManager)» «f.name») {
            this.«f.name» = «f.name»;
        }
    '''
} 
