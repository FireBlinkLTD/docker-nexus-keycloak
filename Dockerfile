FROM sonatype/nexus3:3.22.1

USER root

ENV NEXUS_HOME="/opt/sonatype/nexus"
ENV NEXUS_PLUGINS ${NEXUS_HOME}/system

WORKDIR "${NEXUS_HOME}"

# https://github.com/flytreeleft/nexus3-keycloak-plugin
ENV KEYCLOAK_PLUGIN_TAG 0.4.0-prev1-SNAPSHOT
ENV KEYCLOAK_PLUGIN_VERSION 0.4.0-SNAPSHOT
ENV KEYCLOAK_PLUGIN org/github/flytreeleft/nexus3-keycloak-plugin/${KEYCLOAK_PLUGIN_VERSION}

ADD https://github.com/flytreeleft/nexus3-keycloak-plugin/releases/download/${KEYCLOAK_PLUGIN_TAG}/nexus3-keycloak-plugin-${KEYCLOAK_PLUGIN_VERSION}.jar \
    ${NEXUS_PLUGINS}/${KEYCLOAK_PLUGIN}.jar

RUN chmod 644 ${NEXUS_PLUGINS}/${KEYCLOAK_PLUGIN}.jar
RUN chown nexus ${NEXUS_PLUGINS}/${KEYCLOAK_PLUGIN}.jar
RUN echo "reference\\:file\\:${KEYCLOAK_PLUGIN}.jar = 200" >> ${NEXUS_HOME}/etc/karaf/startup.properties

RUN cat ${NEXUS_HOME}/etc/karaf/startup.properties

EXPOSE 5000 8081 8443
USER nexus

CMD ["bin/nexus", "run"]