# Welcome to webMethods Package Manager (wpm) - version 0.1
Software AG 2024

# About

webMethods Package Manager (wpm) is a command line tool to allow developer to easily share and deploy webMethods packages. 
Conceptually similar to package managers such as npm (Node.js) or pip (Python).
Can be used with different registries, private, public and licensed. The last registry is provided by Software AG to allow customers to download licensed adds on for Integration and is available at https://packages.softwareag.com
This coupled with a base image from https://containers.softwareag.com allows customers to easily build their own bespoke solutions.

# Setup

You can install wpm in any directory of your choosing, make sure to add the bin directory 
to your PATH so that it can be called from anywhere, and check the permissions if running on 
MacOS/Linux

`
$ chmod u+x wpm.sh
`

### Configuring Java runtime

wpm is a java client and so you need to either install a java runtime or configure it to
work with the java that is installed with webMethods. By default it is setup to use the local
java runtime that you have on the machine.

Set the environment variable JRE_HOME to configure an alternative java runtime, for instance
to use the same JRE that was installed with webMethods

`
$ export JRE_HOME=/Applications/SoftwareAG/10.15/jvm/jvm
`

You can set the value directly in the ./bin/setenv.[sh|bat] or manually from the command line. 
Ensure that the java version reports 11.0 or better, confirm that using the command

`
$ java -version
`

**NOTE**: You cannot use the webMethods supplied JRE if using a webMethods version older than 10.11

### Running the command (wpm)

Once you have configured the Java runtime, check that the command works by simply typing wpm
into your command line.

```
$ wpm
Welcome to wpm - the webMethods Package Manager!

A list of commands:

install - download specified packages into the target installation
remove - remove specified packages from the target installation
update - update specified packages to the latest version
clean - clean up specified repositories or all the repositories in the working dir

A list of arguments:

-d - path to the target IS installation - required for install and update commands if it is not defined in the wpm.yml and not the same installation path as where wpm is installed
-u - username for repo connection - required for install and update commands that require authenticated access with basic authentication if the repo and the repo username are not defined in the wpm.yml
-p - password or passphrase for repo connection - required for install and update commands that require authenticated access with basic or private key authentication if the repo and the repo password or passphrase are not defined in the wpm.yml
-k - private key file path - required for install and update commands that require authenticated access with private key authentication if the repo and its private key are not defined in the wpm.yml
-r - Reference a preconfigured git or wpm server in your wpm.yml
-j - jwt token - optional, only required for install and update commands with token based authorization
-ws - the repo server url, in which must specify -u and -p options if secured.
-wr - The registry in the server repository to reference. This is optional as a default registry can be configured in the repository server
-sb - scan branches - optional, by default is true
-kr - keep the local repository - optional, by default is false
```

You should see the help text as above if the command executed properly

### Configuring wpm (wpm.yml)

You can run wpm without any prior configuration but understanding the wpm.yml file will
allow you preconfigure your environment avoid over long laborious command entry.
The configuration file wpm.yml can be found in the home directory of wpm and looks like 
the following
```
version: 1

switches:
  # relative path of the target installation of IS (-d)
  target_installation: /Applications/SoftwareAG/11.0/IntegrationServer/instances/default

  # scan branches for versions (-sb)
  scan_branches: true

  # delete contents of SCM on a successful install, or update (-kr)
  cleanup: true

# source  repos ( -r repeating switch )
repositories:
  # define your remote registries here (wpm or git) and reference them using -wr 
  default:
	type: wpr
	location: https://packages.softwareag.com
	working_dir: /tmp
	  creds:
	    token: <your package registry token>
  john:
	type: git
	location: https://github.com/johnpcarter
	working_dir: /tmp
  other:
	type: git
	location: https://github.com/other
	creds:
	  user: <git_id>
	  password: <developer_access_token>
```

Attributes that we would recommend setting are the following;

* **target_installation**: *indicates the location of the packages directory in which downloaded 
packages should be placed and means you can avoid having to input it each time with -d option*
* **repositories**: *This tell wpm where to fetch packages from, the first level names the repository 
and you can reference it from the command line using the -wr option*

The properties of the repository are as follows;
* **type**: *[wpr|git]*
* **location**: *url to git server or package registry*
* **creds**: *structure for defining secure access to resource*
* **working_dir**: *a safe location on your local computer, do not specify any directory that has 
important content as it will get deleted!!*

The creds structure only requires a token attribute if connecting to wpm and should reference the 
token you generated from the package registry for your user. If connecting to a git server then include
a user attribute specifying your git id and a password attribute with a developer access token.

# Installing a package

Now that you have setup your environment and configured your settings, lets try installing a package e.g.

```
$ install -r john JcPublicTools
(wpm) code: 5 severity: INFO, message: Installing packages: JcPublicTools.
(wpm) code: 6 severity: INFO, message: Installation result: Time spent cloning repository john from https://github.com/johnpcarter: 181
(wpm) code: 6 severity: INFO, message: Installation result: Time spent determining version to pull (result - main): 25
(wpm) code: 6 severity: INFO, message: Installation result: Time spent checking out version main: 1951
(wpm) code: 6 severity: INFO, message: Installation result: Package does not indicate a minimum required runtime version. Proceeding with the operation.
(wpm) code: 6 severity: INFO, message: Installation result: Time spent copying repo to /Applications/SoftwareAG/11.0/IntegrationServer/instances/default/packages/JcPublicTools: 6043
(wpm) code: 6 severity: INFO, message: Installation result: Package JcPublicTools successfully installed (version main).
```

If you configured your JRE and target directory correctly then you should see something like above.
Check that the package was installed by looking in the packages directory and verifying that the package is there.

**NOTE**: You will have to restart your Integration Server to get the package reloaded. This will be revisited in a later version.

# Next steps

### Use it with one of our images in a Dockerfile

You can try downloading one of our MSR images from https://containers.softwareag.com
They all have the wpm command baked in, so you can do cool things like this in a Dockerfile

```
FROM sagcr.azurecr.io/apigateway:10.15

COPY wpm.yml /opt/softwareag/wpm
WORKDIR /opt/softwareag
RUN wpm install -r -wr default john JcPublicTools
...
WORKDIR /
```

### Install licensed packages from our official Software AG package registry

You can also pull Software AG licensed packages from https://packages.softwareag.com
Visit the site, login using your empower credentials, go to settings and generate an access token,
then you can do stuff like

`
$ wpm install WmJDBCAdapter -j <token>
`

### Setup your own personal package registry running locally

You can even setup your own private package registry by downloading it. Yes, it's a package too!

`
$ wpm install -wr default WxPackageManager
`
You can find the instructions to set it up in the package registry or directly in its git page at
https://github.com/wm-packages/WxPackageManager

