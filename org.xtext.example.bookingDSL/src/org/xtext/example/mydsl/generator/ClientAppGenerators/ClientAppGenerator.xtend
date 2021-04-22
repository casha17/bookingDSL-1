package org.xtext.example.mydsl.generator.ClientAppGenerators

import org.eclipse.xtext.generator.IFileSystemAccess2
import org.eclipse.emf.ecore.resource.Resource
import org.xtext.example.mydsl.bookingDSL.*;

class ClientAppGenerator {

	private IFileSystemAccess2 fsa;
	private Resource resource;
	private String clientRoot;
	private SrcGenerator srcGenerator;
	private String publicRoot;

	new (IFileSystemAccess2 fsa, Resource resource, String projRoot) {
		this.fsa = fsa;
		this.resource = resource;
		this.clientRoot = projRoot + "/ClientApp";
		this.srcGenerator = new SrcGenerator(fsa, resource, this.clientRoot);
		this.publicRoot = this.clientRoot + "/public"
	}
	
	def generate() {
		this.generatePublic();
		this.generateGitIgnore();
		this.generatePackageJson();
		//this.generatePackageLockJson();
		this.generateTsConfig();
		
		this.srcGenerator.generate();
	}
	
	private def generatePublic() {
		
		var system = resource.allContents.toList.filter(System).get(0);
		
		this.fsa.generateFile(this.publicRoot + "/index.html", '''
		<!DOCTYPE html>
		<html lang="en">
		  <head>
		    <meta charset="utf-8">
		    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
		    <meta name="theme-color" content="#000000">
		    <base href="%PUBLIC_URL%/" />
		    <!--
		      manifest.json provides metadata used when your web app is added to the
		      homescreen on Android. See https://developers.google.com/web/fundamentals/engage-and-retain/web-app-manifest/
		    -->
		    <link rel="manifest" href="%PUBLIC_URL%/manifest.json">
		    <link rel="shortcut icon" href="%PUBLIC_URL%/favicon.ico">
		    <!--
		      Notice the use of %PUBLIC_URL% in the tags above.
		      It will be replaced with the URL of the `public` folder during the build.
		      Only files inside the `public` folder can be referenced from the HTML.
		
		      Unlike "/favicon.ico" or "favicon.ico", "%PUBLIC_URL%/favicon.ico" will
		      work correctly both with client-side routing and a non-root public URL.
		      Learn how to configure a non-root public URL by running `npm run build`.
		    -->
		    <title>«system.getName()»</title>
		  </head>
		  <body>
		    <noscript>
		      You need to enable JavaScript to run this app.
		    </noscript>
		    <div id="root"></div>
		    <!--
		      This HTML file is a template.
		      If you open it directly in the browser, you will see an empty page.
		
		      You can add webfonts, meta tags, or analytics to this file.
		      The build step will place the bundled scripts into the <body> tag.
		
		      To begin the development, run `npm start` or `yarn start`.
		      To create a production bundle, use `npm run build` or `yarn build`.
		    -->
		  </body>
		</html>
		''')
		
		this.fsa.generateFile(this.publicRoot + "/manifest.json", '''
		{
		  "short_name": "«system.getName()»",
		  "name": "«system.getName()»",
		  "icons": [
		    {
		      "src": "favicon.ico",
		      "sizes": "64x64 32x32 24x24 16x16",
		      "type": "image/x-icon"
		    }
		  ],
		  "start_url": "./index.html",
		  "display": "standalone",
		  "theme_color": "#000000",
		  "background_color": "#ffffff"
		}
		''')
		
	}
	
	private def generateGitIgnore() {
		this.fsa.generateFile(this.clientRoot + "/.gitignore", '''
		# See https://help.github.com/ignore-files/ for more about ignoring files.
		
		# dependencies
		/node_modules
		
		# testing
		/coverage
		
		# production
		/build
		
		# misc
		.DS_Store
		.env.local
		.env.development.local
		.env.test.local
		.env.production.local
		
		npm-debug.log*
		yarn-debug.log*
		yarn-error.log*
		''')
	}
	
	private def generatePackageJson() {
		
		var system = resource.allContents.toList.filter(System).get(0);
		
		this.fsa.generateFile(this.clientRoot + "/package.json",'''
		{
		  "name": "«system.getName()»",
		  "version": "0.1.0",
		  "private": true,
		  "dependencies": {
		    "@material-ui/core": "^4.11.3",
	        "@material-ui/icons": "^4.11.2",
	        "@material-ui/lab": "^4.0.0-alpha.57",
	        "@types/axios": "^0.14.0",
	        "@types/jest": "^26.0.22",
	        "@types/node": "^14.14.37",
	        "@types/react": "^17.0.3",
	        "@types/react-dom": "^17.0.3",
	        "@types/react-router": "^5.1.13",
	        "@types/react-router-dom": "^5.1.7",
	        "bootstrap": "^4.1.3",
	        "jquery": "^3.4.1",
	        "material-ui-chip-input": "^2.0.0-beta.2",
	        "merge": "^1.2.1",
	        "oidc-client": "^1.9.0",
	        "react": "^16.0.0",
	        "react-dom": "^16.0.0",
	        "react-router-bootstrap": "^0.25.0",
	        "react-router-dom": "^5.1.2",
	        "react-scripts": "^3.4.1",
	        "reactstrap": "^8.4.1",
	        "rimraf": "^2.6.2"
		  },
		  "devDependencies": {
		    "ajv": "^6.9.1",
		    "cross-env": "^5.2.0",
		    "eslint": "^6.8.0",
		    "eslint-config-react-app": "^5.2.0",
		    "eslint-plugin-flowtype": "^4.6.0",
		    "eslint-plugin-import": "^2.20.1",
		    "eslint-plugin-jsx-a11y": "^6.2.3",
		    "eslint-plugin-react": "^7.18.3",
		    "nan": "^2.14.1",
		    "typescript": "^3.9.9"
		  },
		  "eslintConfig": {
		    "extends": "react-app"
		  },
		  "scripts": {
		    "start": "rimraf ./build && react-scripts start",
		    "build": "react-scripts build",
		    "test": "cross-env CI=true react-scripts test --env=jsdom",
		    "eject": "react-scripts eject",
		    "lint": "eslint ./src/"
		  },
		  "browserslist": {
		    "production": [
		      ">0.2%",
		      "not dead",
		      "not op_mini all"
		    ],
		    "development": [
		      "last 1 chrome version",
		      "last 1 firefox version",
		      "last 1 safari version"
		    ]
		  }
		}
		''')
	} 
	
	private def generatePackageLockJson() {
		
		var system = resource.allContents.toList.filter(System).get(0);
		// <-- npm install will create the package-lock.json
	}
	
	private def generateTsConfig() {
		this.fsa.generateFile(this.clientRoot + "/tsconfig.json", '''
		{
		  "compilerOptions": {
		    "target": "es5",
		    "module": "esnext",
		    "strict": true,
		    "esModuleInterop": true,
		    "skipLibCheck": true,
		    "forceConsistentCasingInFileNames": true,
		    "lib": [
		      "dom",
		      "dom.iterable",
		      "esnext",
		      "es6"
		    ],
		    "allowJs": true,
		    "allowSyntheticDefaultImports": true,
		    "moduleResolution": "node",
		    "resolveJsonModule": true,
		    "isolatedModules": true,
		    "noEmit": true,
		    "jsx": "react",
		    "noImplicitAny": true,
		    "noImplicitThis": true,
		    "strictNullChecks": true,
		    "downlevelIteration": true
		
		  },
		  "include": [
		    "src"
		  ]
		}
		''')
	}
}