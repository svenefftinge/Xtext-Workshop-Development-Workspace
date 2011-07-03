package org.example.domainmodel.generator 

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IGenerator
import org.eclipse.xtext.generator.IFileSystemAccess
import org.eclipse.xtext.naming.IQualifiedNameProvider
import com.google.inject.Inject
import org.example.domainmodel.domainmodel.*
import static extension org.eclipse.xtext.xtend2.lib.ResourceExtensions.*

class DomainmodelGenerator implements IGenerator {
    
    @Inject extension IQualifiedNameProvider nameProvider 
    
    override void doGenerate(Resource resource, IFileSystemAccess fsa) {
        for(e: resource.allContentsIterable.filter(typeof(Entity))) {
            fsa.generateFile(
                e.fullyQualifiedName.toString.replace(".", "/") + ".java",
                e.compile)
        }
    }
    
    def compile(Entity e) ''' 
        «IF e.eContainer != null»
            package «e.eContainer.fullyQualifiedName»;
        «ENDIF»
        
        public class «e.name» «IF e.superType != null
                       »extends «e.superType.fullyQualifiedName» «ENDIF»{
            «FOR f:e.features»
                «f.compile»
            «ENDFOR»
        }
    '''
    
    def compile(Feature f) '''
        private «f.type.fullyQualifiedName» «f.name»;
        
        public «f.type.fullyQualifiedName» get«f.name.toFirstUpper»() {
            return «f.name»;
        }
        
        public void set«f.name.toFirstUpper»(«f.type.fullyQualifiedName» «f.name») {
            this.«f.name» = «f.name»;
        }
    '''
} 
