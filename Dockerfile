# Étape de build avec Gradle Alpine pour une image légère
FROM gradle:8.7-jdk21-alpine AS builder

# Définir le répertoire de travail
WORKDIR /app

# Copier le reste du code source
COPY . .

# Construire l'application avec Gradle
RUN gradle bootWar

# Étape d'exécution avec eclipse-temurin et JRE uniquement (plus léger que JDK)
FROM eclipse-temurin:17-jre-alpine

# Supprimer les applications par défaut de Tomcat pour réduire la taille
RUN rm -rf $CATALINA_HOME/webapps/*

# Copier uniquement le fichier WAR de l'étape de build
COPY --from=builder "/app/build/libs/*" "$CATALINA_HOME/webapps/ROOT.war"

# Exposer le port 8080
EXPOSE 8080

# Utiliser un utilisateur non-root pour plus de sécurité
USER tomcat