FROM openjdk:8-jre-alpine@sha256:b2ad93b079b1495488cc01375de799c402d45086015a120c105ea00e1be0fd52

ENV SPRING_OUTPUT_ANSI_ENABLED=ALWAYS \
    JHIPSTER_SLEEP=0

# add directly the war
ADD *.war /app.war

VOLUME /tmp
EXPOSE 8761
CMD echo "The application will start in ${JHIPSTER_SLEEP}s..." && \
    sleep ${JHIPSTER_SLEEP} && \
    java -Djava.security.egd=file:/dev/./urandom -jar /app.war
