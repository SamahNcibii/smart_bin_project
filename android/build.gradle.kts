import org.gradle.api.tasks.Delete
import org.gradle.api.file.Directory

plugins {
    // Ajoute ici d'autres plugins globaux si nécessaires

    // Plugin Google services (Firebase)
    id("com.google.gms.google-services") version "4.4.2" apply false
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// ✅ Cette redirection est optionnelle – assure-toi que Flutter la supporte
val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.set(newBuildDir)

subprojects {
    // Redirige les dossiers de build de chaque sous-projet
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.set(newSubprojectBuildDir)

    // S'assure que les dépendances sont bien évaluées dans le bon ordre
    project.evaluationDependsOn(":app")
}

// Tâche de nettoyage du dossier build global
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
