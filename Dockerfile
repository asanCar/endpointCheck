FROM ubuntu:latest

RUN apt-get update && apt-get -y install cron curl nano

# Copy script to user's folder
COPY endpointcheck.sh /bin/checkScript.sh

# Add crontab file in the cron directory
COPY crontab /etc/cron.d/check-cron

# Give execution rights on the cron job
RUN chmod 755 /etc/cron.d/check-cron

# Give execution rights on the check script
RUN chmod 755 /bin/checkScript.sh

# Run the command on container startup
CMD ["cron", "-f"]