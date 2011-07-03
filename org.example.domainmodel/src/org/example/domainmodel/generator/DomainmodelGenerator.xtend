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
    @Inject DomainmodelCompiler domainmodelCompiler
    
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
    
    def dispatch compile(Property p, ImportManager importManager) '''
        private «p.type.shortName(importManager)» «p.name»;
        
        public «p.type.shortName(importManager)» get«p.name.toFirstUpper»() {
            return «p.name»;
        }
        
        public void set«p.name.toFirstUpper»(«p.type.shortName(importManager)» «p.name») {
            this.«p.name» = «p.name»;
        }
    '''
    
	def dispatch compile(Operation o, ImportManager importManager) '''
		public «o.type.shortName(importManager)» «o.name»(«o.parameterList(importManager)») {
			«domainmodelCompiler.compile(o, importManager)» 
		}
	'''
} 
