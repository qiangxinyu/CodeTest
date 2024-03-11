package com.example.section2.app.home.viewModel

import android.annotation.SuppressLint
import androidx.compose.runtime.mutableStateListOf
import androidx.compose.runtime.mutableStateOf
import com.example.section2.networkApi.NetworkStatus
import com.example.section2.networkApi.SongModel
import com.example.section2.networkApi.iTunesServers
import io.reactivex.rxjava3.android.schedulers.AndroidSchedulers
import androidx.compose.runtime.MutableState
import io.reactivex.rxjava3.core.Observable
import retrofit2.Response

@SuppressLint("CheckResult")
class HomeViewModel {

    private var originList = listOf<SongModel>()
    var list = mutableStateListOf<SongModel>()

    var pullRefreshing = mutableStateOf(false)
    var showError: MutableState<ErrorInfo?> = mutableStateOf(null)

    init {
        NetworkStatus.subscribe {
            when (it) {
                NetworkStatus.Status.Normal ->
                    if (originList.isEmpty())
                        getList()
                     else
                        showError.value = null

                NetworkStatus.Status.NotPermission,
                NetworkStatus.Status.NotNetwork ->
                    if (originList.isEmpty())
                        showError.value = ErrorInfo(it)

            }
        }
    }

    private var sortType = HeaderViewModel.SortType.Artist
    private var keyword: String? = null

    fun registerObserver(observer: Observable<HeaderViewModel.Output>) {
        observer.subscribe {
            when (it.action) {
                HeaderViewModel.Output.Action.SortChange -> {
                    sortType = it.value as HeaderViewModel.SortType
                    handleAndSendRefreshList()
                }
                HeaderViewModel.Output.Action.KeywordChange -> {
                    keyword = it.value as String?
                    handleAndSendRefreshList()
                }
            }
        }
    }

    fun getList(){
        if (NetworkStatus.status != NetworkStatus.Status.Normal) {
            list.removeAll { true }
            originList = listOf()
            showError.value = ErrorInfo(NetworkStatus.status)
            return
        }

        showError.value = null
        pullRefreshing.value = true

        iTunesServers.iTunesList("歌", 200, "HK")
            .observeOn(AndroidSchedulers.mainThread())
            .onErrorReturn {
                showError.value = ErrorInfo(
                    it.localizedMessage ?: "get list error",
                    "Reload",
                    ErrorInfo.Action.ReloadList
                )
                return@onErrorReturn Response.success(null)
            }
            .subscribe {
                pullRefreshing.value = false

                if (it.body() != null) {
                    originList = it.body()!!.results
                    handleAndSendRefreshList()
                } else {
                    list.removeAll { true }
                }
            }
    }


    private fun handleAndSendRefreshList() {
        val songList = originList.filterBy(keyword).sortByType(sortType)
        list.removeAll {true}
        list.addAll(songList)
    }

    class ErrorInfo {
        lateinit var title: String
        lateinit var buttonTitle: String
        lateinit var action: Action

        enum class Action {
            GoSetting,
            ReloadList
        }
        constructor( title: String,
                     buttonTitle: String,
                     action: Action) {
            this.title = title
            this.buttonTitle = buttonTitle
            this.action = action
        }


        constructor(networkState: NetworkStatus.Status) {
            when (networkState) {
                NetworkStatus.Status.NotPermission -> {
                    title = "not permission, please change setting"
                    buttonTitle = "Go Setting"
                    action = Action.GoSetting
                }

                NetworkStatus.Status.NotNetwork -> {
                    title = "not network, please check your network connect"
                    buttonTitle = "Go Setting"
                    action = Action.GoSetting
                }
                else -> null
            }
        }
    }

}

fun List<SongModel>.sortByType(type: HeaderViewModel.SortType): List<SongModel> {
    return when (type) {
        HeaderViewModel.SortType.Artist -> sortedBy { it.artistName }
        HeaderViewModel.SortType.Price -> sortedBy { it.trackPrice }
    }
}

fun List<SongModel>.filterBy(key: String?): List<SongModel> {
    if (key.isNullOrEmpty()) return this
    return filter {
        it.trackName.contains(key) || it.uppercaseArtistName.contains(key)
    }
}
