FROM jenkins/jenkins:alpine
ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false

# The JCASC plugin looks for CASC_JENKINS_CONFIG environment variable
ENV CASC_JENKINS_CONFIG /var/jenkins_home/casc.yaml

# JCASC doesn't come with plugins support yet, so we still need to
# manually list plugins using .sh
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt

# Make sure to have the casc.yaml ready. This file will be used by the JCASC
COPY casc.yaml /var/jenkins_home/casc.yaml