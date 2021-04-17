package org.xtext.example.mydsl.generator

import org.eclipse.xtext.generator.IFileSystemAccess2
import org.eclipse.emf.ecore.resource.Resource
import org.xtext.example.mydsl.bookingDSL.*;

class DockerComposeGenerator{
	
	static def void generateComposeFile(IFileSystemAccess2 fsa,
		Resource resource)
	{
		var systemName = resource.allContents.toList.filter(System).get(0).getName();
		
		fsa.generateFile('''«systemName»/docker-compose.yml''', 
			'''
			version: '3.7'
			services:
			  web:
			    build: .
			    ports:
			        - 80:80
			    depends_on:
			        - mongodb_container
			  mongodb_container:
			    image: mongo:latest
			    ports:
			      - 27017:27017
			''')
			
		fsa.generateFile('''«systemName»/Dockerfile''', 
			'''
			FROM mcr.microsoft.com/dotnet/core/sdk:3.1-buster AS build
			
			RUN curl --silent --location https://deb.nodesource.com/setup_10.x | bash -
			RUN apt-get install --yes nodejs
			
			WORKDIR /src
			COPY . .
			
			RUN dotnet restore "«systemName»/«systemName».csproj"
			
			RUN dotnet publish "«systemName»/«systemName».csproj" -c Release -o /app/publish
			
			FROM mcr.microsoft.com/dotnet/core/aspnet:3.1-buster-slim
			
			EXPOSE 80
			
			COPY --from=build /app/publish .
			
			ENTRYPOINT ["dotnet", "«systemName».dll"]
			'''
		)
	}
}