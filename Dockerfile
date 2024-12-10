FROM openjdk:8@sha256:86e863cc57215cfb181bd319736d0baf625fe8f150577f9eb58bd937f5452cb8 as builder
ADD . /code/
RUN \
    cd /code/ && \
    rm -Rf target node_modules && \
    chmod +x /code/mvnw && \
    sleep 1 && \
    ./mvnw package -Pprod -DskipTests && \
    mv /code/target/*.war /jhipster-registry.war && \
    rm -Rf /code/ /root/.m2 /root/.cache /tmp/*

FROM openjdk:8-jre-alpine@sha256:f362b165b870ef129cbe730f29065ff37399c0aa8bcab3e44b51c302938c9193
ENV SPRING_OUTPUT_ANSI_ENABLED=ALWAYS \
    SPRING_PROFILES_ACTIVE=prod,native \
    GIT_URI=https://github.com/jhipster/jhipster-registry/ \
    GIT_SEARCH_PATHS=central-config
EXPOSE 8761
COPY --from=builder /jhipster-registry.war .
RUN mkdir /target && \
    chmod g+rwx /target
CMD ["java","-Djava.security.egd=file:/dev/./urandom","-jar","/jhipster-registry.war","--spring.cloud.config.server.git.uri=${GIT_URI}","--spring.cloud.config.server.git.search-paths=${GIT_SEARCH_PATHS}"]
