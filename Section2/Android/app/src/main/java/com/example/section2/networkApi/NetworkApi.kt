package com.example.section2.networkApi

import Print
import okhttp3.Interceptor
import okhttp3.OkHttpClient
import okhttp3.Request
import okhttp3.Response
import retrofit2.Retrofit
import retrofit2.adapter.rxjava3.RxJava3CallAdapterFactory
import retrofit2.converter.gson.GsonConverterFactory
import java.io.IOException


object NetworkApi {
    private val retrofit: Retrofit

    fun <T> create(service: Class<T> ): T {
        return retrofit.create(service)
    }

    init {
        val mOkHttpClient = OkHttpClient.Builder()
            .addInterceptor(LoggingInterceptor())
            .build()

        retrofit = Retrofit.Builder()
            .baseUrl("https://itunes.apple.com")
            .addConverterFactory(GsonConverterFactory.create())
            .addCallAdapterFactory(RxJava3CallAdapterFactory.create())
            .client(mOkHttpClient)
            .build()
    }
}


internal class LoggingInterceptor : Interceptor {
    @Throws(IOException::class)
    override fun intercept(chain: Interceptor.Chain): Response {
        val request: Request = chain.request()
        val t1 = System.nanoTime()
        Print(String.format(
                "Sending request %s on %s%n%s",
                request.url, chain.connection(), request.headers
            )
        )
        val response: Response = chain.proceed(request)
        val t2 = System.nanoTime()
//        Print(String.format(
//                "Received response for %s in %.1fms%n%s",
//                response.request.url, (t2 - t1) / 1e6, response.headers
//            )
//        )
        return response
    }
}