# Étape de build avec Gradle
FROM gradle:jdk17 AS builder

# Définir le répertoire de travail
WORKDIR /app

# Copier le reste du code source
COPY . .

# Construire l'application avec Gradle
RUN gradle bootWar --no-daemon

# Étape d'exécution avec Tomcat
FROM tomcat:10

# Supprimer les applications par défaut de Tomcat
RUN rm -rf $CATALINA_HOME/webapps/*

# Créer l'utilisateur tomcat
RUN useradd -m tomcat

# Copier uniquement le fichier WAR de l'étape de build
COPY --from=builder "/app/build/libs/*.war" "$CATALINA_HOME/webapps/ROOT.war"

# Exposer le port 8080
EXPOSE 8080

# Utiliser l'utilisateur tomcat pour la sécurité
USER tomcat