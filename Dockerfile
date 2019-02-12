FROM ruby:2.6.1-alpine3.9

# Add command line argument variables used to customise the image at build-time.

ARG PARLIAMENT_API_VERSION
ARG OPENSEARCH_DESCRIPTION_URL
ARG OPENSEARCH_AUTH_TOKEN
ARG AIRBRAKE_PROJECT_ID
ARG AIRBRAKE_PROJECT_KEY
ARG BANDIERA_URL
ARG APPLICATION_INSIGHTS_INSTRUMENTATION_KEY
ARG RAILS_LOG_TO_STDOUT
ARG SECRET_KEY_BASE
ARG RACK_ENV=production
ARG IMAGE_SERVICE_URL
ARG PARLIAMENT_BASE_URL

# Add Gemfiles.
ADD Gemfile /app/
ADD Gemfile.lock /app/

# Set the working DIR.
WORKDIR /app

# Install system and application dependencies.
# The condition removes development and test dependencies in production (that's why we can't run test commands in production).
RUN echo "Environment (RACK_ENV): $RACK_ENV" && \
    apk --update add libcurl && \
    apk --update add --virtual build-dependencies build-base ruby-dev && \
    gem install bundler --no-document && \
    if [ "$RACK_ENV" == "production" ]; then \
      bundle install --without development test --path vendor/bundle; \
      apk del build-dependencies; \
    else \
      bundle install --path vendor/bundle; \
    fi

# Copy the application onto our image.
ADD . /app

# Make sure our user owns the application directory.
RUN if [ "$RACK_ENV" == "production" ]; then \
      chown -R nobody:nogroup /app; \
    else \
      chown -R nobody:nogroup /app /usr/local/bundle; \
    fi

# Set up our user and environment
USER nobody
ENV PARLIAMENT_API_VERSION $PARLIAMENT_API_VERSION
ENV OPENSEARCH_DESCRIPTION_URL $OPENSEARCH_DESCRIPTION_URL
ENV OPENSEARCH_AUTH_TOKEN $OPENSEARCH_AUTH_TOKEN
ENV AIRBRAKE_PROJECT_ID $AIRBRAKE_PROJECT_ID
ENV AIRBRAKE_PROJECT_KEY $AIRBRAKE_PROJECT_KEY
ENV BANDIERA_URL $BANDIERA_URL
ENV APPLICATION_INSIGHTS_INSTRUMENTATION_KEY $APPLICATION_INSIGHTS_INSTRUMENTATION_KEY
ENV RAILS_LOG_TO_STDOUT $RAILS_LOG_TO_STDOUT
ENV RACK_ENV $RACK_ENV
ENV SECRET_KEY_BASE $SECRET_KEY_BASE
ENV RAILS_SERVE_STATIC_FILES true
ENV IMAGE_SERVICE_URL $IMAGE_SERVICE_URL
ENV PARLIAMENT_BASE_URL $PARLIAMENT_BASE_URL

# Add additional labels to our image
ARG GIT_SHA=unknown
ARG GIT_TAG=unknown
LABEL git-sha=$GIT_SHA \
	    git-tag=$GIT_TAG \
	    rack-env=$RACK_ENV \
	    maintainer=mattrayner1@gmail.com

# Expose port 3000
EXPOSE 3000

# Setup a health check
HEALTHCHECK --interval=5s --timeout=3s CMD curl --fail http://localhost:3000/health-check || exit 1

# Launch puma
CMD ["bundle", "exec", "rails", "s", "-b", "0.0.0.0"]
