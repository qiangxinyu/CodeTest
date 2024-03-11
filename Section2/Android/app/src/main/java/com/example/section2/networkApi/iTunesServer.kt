package com.example.section2.networkApi

import com.google.gson.annotations.SerializedName
import retrofit2.http.GET
import io.reactivex.rxjava3.core.Observable
import retrofit2.Response
import retrofit2.http.Query


val iTunesServers: iTunesServerInterface = NetworkApi.create(iTunesServerInterface::class.java)


interface iTunesServerInterface {
    @GET("/search")
    fun iTunesList(
        @Query("term") term: String,
        @Query("limit") limit: Int,
        @Query("country") country: String): Observable<Response<iTunesModel>>
}



data class iTunesModel (
    var resultCount: Int,
    var results: List<SongModel>
)

data class SongModel (
    var artistName: String,
    var trackName: String,
    @SerializedName("artworkUrl100")  var artworkUrl: String,
    var trackPrice: Float
) {

    private var _uppercaseArtistName: String? = null

    val uppercaseArtistName: String
        get() {
            if (_uppercaseArtistName == null) {
                _uppercaseArtistName = artistName.uppercase()
            }
            return _uppercaseArtistName!!
        }
}
