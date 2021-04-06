package org.xtext.example.mydsl.generator.ClientAppGenerators

import org.eclipse.xtext.generator.IFileSystemAccess2
import org.eclipse.emf.ecore.resource.Resource

class APIGenerator {
	
	private IFileSystemAccess2 fsa;
	private Resource resource;
	private String apiRoot;
	
	new(IFileSystemAccess2 fsa, Resource resource, String srcRoot) {
		this.fsa = fsa;
		this.resource = resource;
		this.apiRoot = srcRoot + "/api";
	}
	
	def generate() {
		this.fsa.generateFile(this.apiRoot + "/httpClient.ts", '''
		import axios, { AxiosError, AxiosRequestConfig, AxiosResponse, CancelTokenSource } from "axios";
		
		const httpDelete = 
		    async <T>(url: string, requestConfig?: AxiosRequestConfig): Promise<HttpResponse<T>> => {
		        try {
		            const result = await axios.delete<T>(url, requestConfig);
		            return new HttpResponseBuilder<T>().success(result.data, result.status);
		        } catch (err) {
		            console.error(err);
		            return new HttpResponseBuilder<T>().interpretError(err as AxiosError);
		        }
		    }
		
		const httpPut =
		    async <T>(url: string, requestBody?: any, requestConfig?: AxiosRequestConfig): Promise<HttpResponse<T>> => {
		        try {
		            const result = await axios.put<T>(url, requestBody, requestConfig);
		            return new HttpResponseBuilder<T>().success(result.data, result.status);
		        } catch (err) {
		            console.error(err);
		            return new HttpResponseBuilder<T>().interpretError(err as AxiosError);
		        }
		    }
		
		const httpGet = 
		    async <T>(url: string, requestConfig?: AxiosRequestConfig): Promise<HttpResponse<T>> => {
		        try {
		            const result = await axios.get<T>(url, requestConfig);
		            return new HttpResponseBuilder<T>().success(result.data, result.status);
		        } catch (err) {
		            console.error(err);
		            return new HttpResponseBuilder<T>().interpretError(err as AxiosError);
		        }
		    }
		
		const httpPost =
		    async <T>(url: string, requestBody?: any, requestConfig?: AxiosRequestConfig): Promise<HttpResponse<T>> => {
		        try {
		            const result = await axios.post<T>(url, requestBody, requestConfig);
		            return new HttpResponseBuilder<T>().success(result.data, result.status);
		        } catch (err) {
		            console.error(err);
		            return new HttpResponseBuilder<T>().interpretError(err as AxiosError);
		        }
		    }
		
		class HttpResponseBuilder<T> {
		
		    success = (data: T, statusCode: number): HttpResponse<T> => {
		        return new HttpResponse<T>(data, statusCode, true);
		    }
		
		    interpretError = (error: AxiosError): HttpResponse<T> => {
		        if (error.response) {
		            return this.handleServerErrorResponse(error.response);
		        } else {
		            return this.handleNetworkError(error);
		        }
		    }
		
		    aborted = (): HttpResponse<T> => {
		        const response = new HttpResponse<T>({} as T, 0, false)
		        response.requestAborted = true;
		        return response;
		    }
		
		    private handleServerErrorResponse = (response: AxiosResponse): HttpResponse<T> => {
		        if (response.data !== "") {
		            return new HttpResponse<T>({} as T,
		                response.status,
		                false,
		                response.statusText);
		        }
		        return new HttpResponse<T>({} as T, response.status, false, response.statusText);
		    }
		
		    private handleNetworkError = (error: AxiosError): HttpResponse<T> => {
		        let response = new HttpResponse<T>({} as T, 0, false, error.message);
		        response.networkError = true;
		        return response;
		    }
		
		}
		
		class HttpResponse<T> {
		    data: T;
		    isSuccess: boolean = false;
		    networkError: boolean = false;
		    statusCode: number = 0;
		    message: string = "";
		    requestAborted?: boolean = false;
		
		    constructor(data: T,
		        statusCode: number,
		        isSuccess: boolean = true,
		        message: string = "",
		        requestAborted?: boolean) {
		        this.data = data;
		        this.statusCode = statusCode;
		        this.isSuccess = isSuccess;
		        this.message = message;
		        this.requestAborted = requestAborted;
		    }
		}
		
		export {
		    HttpResponse,
		    HttpResponseBuilder,
		    httpPost,
		    httpGet,
		    httpDelete,
		    httpPut
		}
		''')
		
	}
}