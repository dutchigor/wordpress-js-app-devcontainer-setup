# Docker Dev setup for javascript app With WordPress using VSCode
#### Works for apps inside WordPress or with WP as backend

## Concept
This setup uses Docker for developing a wordpress plugin or theme in conjunction with a javascript app. This can be any kind of javascript app that requires a separate dev server during coding and is built as a static app for production, e.g. a React or Vue app. It can also be used for either a stand alone app that uses wordpress as a backend or as an app included in a wordpress plugin or theme.

## Set up
Prerequisite: requires VSCode extension Remote - Containers.

1. Update the .env variables in .docker.
2. Place Javascript app code in root folder. If you replace package.json, make sure you move the wpsetup script to your package.json
3. Place plugin or theme code in plugin folder
4. Run command `Remote-containers: Reopen in Container`


## How to use
The setup consists of 3 containers:
* Node devcontainer
* [Wordpress](https://hub.docker.com/_/wordpress)
* [MySQL](https://hub.docker.com/_/mysql)

By default, VSCode attaches to the Node container. The container has access to the full project folder so you can develop both the app and the plugin/theme code from here.

### Wordpress development
By default the containers are set up for plugin development. To switch to theme development, change `PROJECT_TYPE` to theme in .env and rename the "plugin" folder to "theme".

For wordpress development, some extensions are included in the container by default:
* [PHP Intelephense](https://marketplace.visualstudio.com/items?itemName=bmewburn.vscode-intelephense-client)
* [Wordpress Snippets](https://marketplace.visualstudio.com/items?itemName=wordpresstoolbox.wordpress-toolbox)
* [WordPress Hooks Intellisense](https://marketplace.visualstudio.com/items?itemName=johnbillion.vscode-wordpress-hooks)
* [PHP debug](https://marketplace.visualstudio.com/items?itemName=felixfbecker.php-debug)

[XDebug](https://xdebug.org/) is set up to work out of the box so just run the "Listen for XDebug" debugger.

If you need to access wordpress beyond the plugin/theme code there are 2 options:
* WordPress cli. This is accessible from the node container as a global `wp` command. It executes the commands on the WordPress container behind the scenes with /var/www/html as the base folder.
* Use the [docker](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-docker) extension. This is included in the container by default and allows you to attach either VSCode or a shell to one of the other containers.

If you need to change the environment variables at any point, rebuild the container and then run `wpsetup` or execute the wpsetup npm script. This will apply your changes to wordpress.

### App development
No app development extensions are included by default since the setup is frontend framework agnostic.

Note that node_modules is not shared with the container so you will have to `npm install` the first time you open the container on an existing project. It is persisted though so no need to run this each time.

#### App inside Plugin or Theme
To develop an app that should be included in a theme or plugin, set your build location for your app to be where needed in the plugin folder.

During development, run the app from a node dev server as you would normally. However, when registering the app's script in your plugin/the, do a check if the build file exists. If not, fall back to the address of the dev server. the port 

```php
$app_dir = dirname( __DIR__ ) . '/dist/js';
if ( file_exists( $app_dir ) ) {
    $app_url = plugin_dir_url( $app_dir );
} else {
    $site_url = parse_url( get_site_url() );
    $app_url = $site_url['scheme'] . '://localhost:' . getenv('NODE_PORT');
}

wp_register_script( 'my_app', $app_url . 'js/app.js' )
```

#### Standalone app
No special setup is needed. Wordpress is available on the port specified in the environment variables on the local machine and on port 80 in the Node container.

## Database
The database is accessible from the Node container on port 3306. It is also accessible out of the box from the [MySQL](https://marketplace.visualstudio.com/items?itemName=cweijan.vscode-mysql-client2) extension.

To import a database just place the dump in the wp-data folder and rebuild the container. For more information on this see the section Initializing a fresh instance in the [MySQL](https://hub.docker.com/_/mysql) docker readme.

For now, database exports can be done using the MySQL extension. I hope to include a script when I have the time to simplify this process.

## To do
* Include Composer and make it accessible from the Node Container
* Create db export script

## License
Distributed under the MIT License. See `LICENSE` for more information.

## Acknowledgements
A lot of insiration has been taken from the following projects, so a big thank you!
* [vscode-devcontainer-wordpress](https://github.com/valenvb/vscode-devcontainer-wordpress)
* [wordpress-docker-compose](https://github.com/nezhar/wordpress-docker-compose)
