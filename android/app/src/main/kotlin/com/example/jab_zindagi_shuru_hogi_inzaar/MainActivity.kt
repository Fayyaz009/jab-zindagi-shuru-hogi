package com.jabzindagishuruhogi.inzaar

import android.os.Bundle
import androidx.activity.enableEdgeToEdge
import io.flutter.embedding.android.FlutterFragmentActivity

class MainActivity : FlutterFragmentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        // Handle edge-to-edge for Android 15+
        enableEdgeToEdge()
        super.onCreate(savedInstanceState)
    }
}
