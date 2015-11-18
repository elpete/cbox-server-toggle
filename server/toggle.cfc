/**
 * Toggle an embedded CFML server.  Run command from the web root of the server, or use the short name.
 * .
 * {code:bash}
 * server toggle
 * server toggle --!open
 * server toggle serverName
 * {code}
 **/
component extends="commandbox.system.BaseCommand" aliases="toggle" excludeFromHelp=false {

	// DI
	property name="serverService" inject="ServerService";

	/**
	 * @name.hint the short name of the server to stop
	 * @name.optionsUDF serverNameComplete
	 * @directory.hint web root for the server
     * @open.hint    	open a browser after starting
	 **/
	function run(string name="", string directory="", boolean openbrowser=true) {

		// Discover by shortname or webroot and get server info
		variables.server = serverService.getServerInfoByDiscovery(
			directory 	= arguments.directory,
			name		= arguments.name
		);

        if (variables.server.keyExists("status") && (
                variables.server.status == "running" ||
                variables.server.status == "started" ||
                variables.server.status == "starting"
            )
        ) {
            runCommand("server stop")
        } else {
            var openFlag = arguments.openbrowser ? "" : " --!openbrowser";
            runCommand("server start #openFlag#");
        }

	}

	function serverNameComplete() {
		return serverService.getServerNames();
	}

}
