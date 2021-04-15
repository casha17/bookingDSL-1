package org.xtext.example.mydsl.generator

import org.eclipse.xtext.generator.IFileSystemAccess2
import org.eclipse.emf.ecore.resource.Resource
import org.xtext.example.mydsl.bookingDSL.*;

class StartupGenerator{
	
	static def void generateStartupFile(IFileSystemAccess2 fsa,
		Resource resource)
	{
		var systemName = resource.allContents.toList.filter(System).get(0).getName();
		var definedCustomerTypes = resource.allContents.toList.filter(Customer);
		var definedResourceTypes = resource.allContents.toList.filter(org.xtext.example.mydsl.bookingDSL.Resource);
		var definedEntityTypes = resource.allContents.toList.filter(Entity);
		var definedScheduleTypes = resource.allContents.toList.filter(Schedule);
		var definedBookingTypes = resource.allContents.toList.filter(Booking);
		
		fsa.generateFile('''«systemName»/«systemName»/Startup.cs''', 
			'''
			using «systemName».Configuration;
			using «systemName».Handlers;
			using «systemName».Persistence.Repositories;
			using Microsoft.AspNetCore.Builder;
			using Microsoft.AspNetCore.Hosting;
			using Microsoft.AspNetCore.HttpsPolicy;
			using Microsoft.AspNetCore.SpaServices.ReactDevelopmentServer;
			using Microsoft.Extensions.Configuration;
			using Microsoft.Extensions.DependencyInjection;
			using Microsoft.Extensions.Hosting;
			using Microsoft.Extensions.Options;
			using MongoDB.Driver;
			using AutoMapper;
			using «systemName».Mapping;
			using «systemName».Persistence.Models;
			using «systemName».RequestModels;
			
			namespace «systemName»
			{
			    public class Startup
			    {
			        private readonly IConfiguration _configuration;
			        
			        public Startup(IConfiguration config)
			        {
			            _configuration = config;
			        }
			
			        // This method gets called by the runtime. Use this method to add services to the container.
			        public void ConfigureServices(IServiceCollection services)
			        {
			            services.AddControllersWithViews();
			            
			            // Add Configurations
			            services.Configure<PersistenceConfiguration>(_configuration.GetSection(nameof(PersistenceConfiguration)));
			            
			            // Register MongoDB database
			            services.AddSingleton<IMongoClient>(ctx => new MongoClient(ctx.GetService<IOptions<PersistenceConfiguration>>().Value.MongoClusterConnectionString));
			            
			            // Register handlers
						«FOR element : definedCustomerTypes»
						services.AddScoped<I«element.name»Handler, «element.name»Handler>();
						«ENDFOR»
						«FOR element : definedResourceTypes»
						services.AddScoped<I«element.name»Handler, «element.name»Handler>();
						«ENDFOR»
						«FOR element : definedEntityTypes»
						services.AddScoped<I«element.name»Handler, «element.name»Handler>();
						«ENDFOR»
						«FOR element : definedScheduleTypes»
						services.AddScoped<I«element.name»Handler, «element.name»Handler>();
						«ENDFOR»
						«FOR element : definedBookingTypes»
						services.AddScoped<I«element.name»Handler, «element.name»Handler>();
						«ENDFOR»
			
			            // Register repositories
			            «FOR element : definedCustomerTypes»
			            services.AddScoped<I«element.name»Repository, «element.name»Repository>();
			            «ENDFOR»
			            «FOR element : definedResourceTypes»
			            services.AddScoped<I«element.name»Repository, «element.name»Repository>();
			            «ENDFOR»
			            «FOR element : definedEntityTypes»
			            services.AddScoped<I«element.name»Repository, «element.name»Repository>();
			            «ENDFOR»
						«FOR element : definedScheduleTypes»
						services.AddScoped<I«element.name»Repository, «element.name»Repository>();
						«ENDFOR»
						«FOR element : definedBookingTypes»
						services.AddScoped<I«element.name»Repository, «element.name»Repository>();
						«ENDFOR»
			
						//Register Mapper
						var mapperConfig = new MapperConfiguration(mc =>
						{
							mc.AddProfile(new MappingProfile());
						});
						
						IMapper mapper = mapperConfig.CreateMapper();
						services.AddSingleton(mapper);
						
			            // In production, the React files will be served from this directory
			            services.AddSpaStaticFiles(configuration => { configuration.RootPath = "ClientApp/build"; });
			        
			        	//Add swagger
			        	services.AddSwaggerGen();
			        }
			
			        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
			        public void Configure(IApplicationBuilder app, IWebHostEnvironment env)
			        {
			//Swaggerrr
			        	app.UseSwagger();
			        	//Enable middleware to serve ui
			        	app.UseSwaggerUI(c =>
			        	{
			        	    c.SwaggerEndpoint("/swagger/v1/swagger.json", "Booker app");
			     		});        	
			        	
			            if (env.IsDevelopment())
			            {
			                app.UseDeveloperExceptionPage();
			            }
			            else
			            {
			                app.UseExceptionHandler("/Error");
			                // The default HSTS value is 30 days. You may want to change this for production scenarios, see https://aka.ms/aspnetcore-hsts.
			                app.UseHsts();
			            }
			
			            app.UseHttpsRedirection();
			            app.UseStaticFiles();
			            app.UseSpaStaticFiles();
			
			            app.UseRouting();
			
			            app.UseEndpoints(endpoints =>
			            {
			                endpoints.MapControllerRoute(
			                    name: "default",
			                    pattern: "{controller}/{action=Index}/{id?}");
			            });
			
			            app.UseSpa(spa =>
			            {
			                spa.Options.SourcePath = "ClientApp";
			
			                if (env.IsDevelopment())
			                {
			                    spa.UseReactDevelopmentServer(npmScript: "start");
			                }
			            });
			        }
			    }
			}
			''')
	}
}