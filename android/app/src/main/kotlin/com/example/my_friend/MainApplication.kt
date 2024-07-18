package com.example.my_friend

import android.app.Application
import com.yandex.mapkit.MapKitFactory

class MainApplication: Application() {
  override fun onCreate() {
    super.onCreate()
    MapKitFactory.setApiKey("d2b8aa04-4e89-47b4-b4a5-5acbc38eba3b") // Your generated API key
  }
}
