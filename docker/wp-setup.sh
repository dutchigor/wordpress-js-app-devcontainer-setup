#!/bin/sh
# Path to WordPress installation
wp_path="/var/www/html";

# Give the db some time to start up
# sleep 5

# Exit if WordPress is already installed and update is not forced
if [ "$CONFIGURE_WP" != "true" ]; then
  if wp core is-installed --path=${wp_path}; then
    echo WordPress is already installed;
    exit 0;
  fi
elif [ "$#" -gt 0 ]; then
  echo the only valid flag is -i\: install only;
  exit 1;
fi

# Set up wordpress if not done already
echo Setting up WordPress;
wp core install \
  --path=${wp_path} \
  --url="http://localhost:${WORDPRESS_PORT}" \
  --title="$SITE_TITLE" \
  --admin_user="$ADMIN_USER" \
  --admin_email="$ADMIN_EMAIL" \
  --admin_password="$ADMIN_PASS" \
  --skip-email;
if [ "$?" -eq 1 ]; then
  sleep 5;
  exit 1;
fi

# Install theme
if [ -n "${INSTALL_THEME}" ]; then
  echo Installing theme ${INSTALL_THEME};
  wp theme install $INSTALL_THEME --force --activate --path=${wp_path};
else
  echo No theme provided;
fi

# Install 3rd party plugins
if [ -n "${INSTALL_PLUGINS}" ]; then
  echo Installing plugins\: ${INSTALL_PLUGINS};
  wp plugin install ${INSTALL_PLUGINS} --activate --path=${wp_path};
else
  echo No 3rd party plugins provided;
fi

# Install App plugin
if [ "${PROJECT_TYPE}" = "plugin" ]; then
  if [ -f ${wp_path}/wp-content/plugins/${PROJECT_NAME}/*.php ]; then
    echo Activating App plugin;
    wp plugin activate ${PROJECT_NAME} --path=${wp_path};
  else
    echo No dev plugin provided
  fi
# Install App plugin
elif [ "${PROJECT_TYPE}" = "theme" ]; then
  if [ -f ${wp_path}/wp-content/themes/${PROJECT_NAME}/style.css ]; then
    echo Activating App theme;
    wp theme activate ${PROJECT_NAME} --path=${wp_path};
  else
    echo No dev theme provided
  fi
else
  echo "Project type is not valid. Must be plugin or theme."
fi