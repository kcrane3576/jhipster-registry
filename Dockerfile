FROM openjdk:8 as builder
ADD . /code/
RUN \
    cd /code/ && \
    rm -Rf target node_modules && \
    chmod +x /code/mvnw && \
    sleep 1 && \
    ./mvnw package -Pprod -DskipTests && \
    mv /code/target/*.war /jhipster-registry.war && \
    rm -Rf /code/ /root/.m2 /root/.cache /tmp/*

FROM openjdk:8-jre-alpine@sha256:b2ad93b079b1495488cc01375de799c402d45086015a120c105ea00e1be0fd52
ENV SPRING_OUTPUT_ANSI_ENABLED=ALWAYS \
    SPRING_PROFILES_ACTIVE=prod,native \
    GIT_URI=https://github.com/jhipster/jhipster-registry/ \
    GIT_SEARCH_PATHS=central-config
EXPOSE 8761
COPY --from=builder /jhipster-registry.war .
RUN mkdir /target && \
    chmod g+rwx /target
CMD ["java","-Djava.security.egd=file:/dev/./urandom","-jar","/jhipster-registry.war","--spring.cloud.config.server.git.uri=${GIT_URI}","--spring.cloud.config.server.git.search-paths=${GIT_SEARCH_PATHS}"]
